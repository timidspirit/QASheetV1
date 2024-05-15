import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qasheets/services/excel_reader_service.dart';
import 'package:qasheets/utils/snackbar_utils.dart';
import 'package:path_provider/path_provider.dart';

class FileService {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController qaController = TextEditingController();

  bool fieldsNotEmpty = false;

  File? _selectedFile;
  String _selectedDirectory = '';

  String getTodayDate() {
    final now = DateTime.now();
    final formatter = DateFormat('MM-dd-yyyy');
    final formattedDate = formatter.format(now);
    return formattedDate;
  }

 
  Future<void> importExcel(BuildContext context, Function(List<Map<String, dynamic>>) onImport) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      try {
        File file = File(result.files.single.path!);
        ExcelReaderService excelReader = ExcelReaderService();
        List<Map<String, dynamic>> data = excelReader.readExcel(file);
        onImport(data);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Excel file imported successfully')),
          );
        }

        // Set the default export directory name based on the Excel file name
        String excelFileName = result.files.single.name.split('.').first;
        _selectedDirectory = '${(await getApplicationDocumentsDirectory()).path}/$excelFileName';
        Directory(_selectedDirectory).createSync();
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error importing Excel file: $e')),
          );
        }
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File import canceled')),
        );
      }
    }
  }

  Future<String> getExportDirectoryName() async {
    if (titleController.text.isNotEmpty) {
      return titleController.text;
    }
    if (_selectedDirectory.isNotEmpty) {
      return _selectedDirectory;
    }
    return (await getApplicationDocumentsDirectory()).path;
  }

  void clearFields(context) {
    titleController.clear();
    qaController.clear();

    SnackBarUtils.showSnackbar(context, Icons.delete_forever_rounded, 'Cleared');
  }

  void newDirectory(context) async {
    try {
      String? directory = await FilePicker.platform.getDirectoryPath();
      if (directory != null) {
        _selectedDirectory = directory;
        _selectedFile = null;
        if (context.mounted) {
          SnackBarUtils.showSnackbar(context, Icons.folder, 'Directory selected');
        }
      } else {
        if (context.mounted) {
          SnackBarUtils.showSnackbar(context, Icons.error, 'Failed to select directory');
        }
      }
    } catch (e) {
      if (context.mounted) {
        SnackBarUtils.showSnackbar(context, Icons.error, 'Failed to select directory');
      }
    }
  }
}
