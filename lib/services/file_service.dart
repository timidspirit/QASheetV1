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
  List<Map<String, dynamic>> _excelData = [];

  File? _selectedFile;
  String _selectedDirectory = '';

  String getTodayDate() {
    final now = DateTime.now();
    final formatter = DateFormat('MM-dd-yyyy');
    final formattedDate = formatter.format(now);
    return formattedDate;
  }

  void saveContent(BuildContext context) async {
    final title = titleController.text;

    final textContent = "Title:\n\n$title\n\n";

    try {
      if (_selectedFile != null) {
        await _selectedFile!.writeAsString(textContent);
      } else {
        final todayDate = getTodayDate();
        String metadetaDirPath = _selectedDirectory;
        if (metadetaDirPath.isEmpty) {
          final directory = await FilePicker.platform.getDirectoryPath();
          _selectedDirectory = metadetaDirPath = directory!;
        }
        final filePath = '$metadetaDirPath/$todayDate - $title.txt';
        final newFile = File(filePath);
        await newFile.writeAsString(textContent);
      }
      if (context.mounted) {
        SnackBarUtils.showSnackbar(context, Icons.check, 'Saved');
      }
    } catch (e) {
      if (context.mounted) {
        SnackBarUtils.showSnackbar(context, Icons.error, 'Failed to save');
      }
    }
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

  void clearFields(BuildContext context) {
    titleController.clear();
    qaController.clear();
    _excelData.clear(); // Clear the Excel data

    SnackBarUtils.showSnackbar(context, Icons.delete_forever_rounded, 'Cleared');
  }

  void newDirectory(BuildContext context) async {
    try {
      String? directory = await FilePicker.platform.getDirectoryPath();
      if (directory != null) {
        _selectedDirectory = directory;
        _selectedFile = null;
        
        // Create the directory if it doesn't exist
        Directory(_selectedDirectory).createSync(recursive: true);
        
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

  void setExcelData(List<Map<String, dynamic>> excelData) {
    _excelData = excelData;
  }

  List<Map<String, dynamic>> getExcelData() {
    return _excelData;
  }

  void appReset(BuildContext context) {
    clearFields(context);
    _selectedFile = null;
    _selectedDirectory = '';
    SnackBarUtils.showSnackbar(context, Icons.refresh, 'App reset');
  }

  String getSelectedDirectory() {
    return _selectedDirectory;
  }
}
