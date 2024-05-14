import "dart:io";
import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:qasheets/services/excel_reader_service.dart";
import "package:qasheets/utils/snackbar_utils.dart";

class FileService {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController qaController = TextEditingController();

  bool fieldsNotEmpty = false;

  File? _selectedFile; 
    String _selectedDirectory = '';

 String getTodayDate () {
   final now = DateTime.now();
   final formatter = DateFormat('MM-dd-yyyy');
   final formattedDate = formatter.format(now);
   return formattedDate;
   }

  void saveContent(context) async {
    final title = titleController.text;

    final textContent = 
        "Title:\n\n$title\n\n";
      
    try {
      if (_selectedFile!= null) {
        await _selectedFile!.writeAsString(textContent);
      } else {
        final todayDate = getTodayDate();
        String metadetaDirPath = _selectedDirectory;
        if(metadetaDirPath.isEmpty) {
          final directory = await FilePicker.platform.getDirectoryPath();
          _selectedDirectory = metadetaDirPath = directory!;
        }
        final filePath = '$metadetaDirPath/$todayDate - $title.txt';
        final newFile = File(filePath);
        await newFile.writeAsString(textContent);
      }
      SnackBarUtils.showSnackbar(context, Icons.check, 'Saved');
    }catch (e) {
      SnackBarUtils.showSnackbar(context, Icons.error, 'Failed to save');
    }
  }

Future<void> importExcel(BuildContext context, Function(List<Map<String, dynamic>>) onImport) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      ExcelReaderService excelReader = ExcelReaderService();
      List<Map<String, dynamic>> data = excelReader.readExcel(file);
      onImport(data);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Excel file imported successfully')),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File import canceled'),
          ),
        );
      }
    }
  }



  void clearFields(context) { 
    titleController.clear();
    qaController.clear();

    SnackBarUtils.showSnackbar(context, Icons.delete_forever_rounded, 'Cleared');
  }

  void newDirectory(context) async {
    try {
      String? directory = await FilePicker.platform.getDirectoryPath();
      _selectedDirectory = directory!;
      _selectedFile = null;
      SnackBarUtils.showSnackbar(context, Icons.folder, 'Directory selected');
    } catch (e) {
      SnackBarUtils.showSnackbar(context, Icons.error, 'Failed to select directory');
    }
  }
}