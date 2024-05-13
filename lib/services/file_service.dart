import "dart:io";

import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:qasheets/utils/snackbar_utils.dart";

class FileService {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController qaController = TextEditingController();
  final TextEditingController workgroupController = TextEditingController();

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
    final workgroup = workgroupController.text;

    final textContent = 
        "Title:\n\n$title\n\nWorkgroup:\n\n$workgroup";
      
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
        final filePath = '$metadetaDirPath/$todayDate - $title - $workgroup.txt';
        final newFile = File(filePath);
        await newFile.writeAsString(textContent);
      }
      SnackBarUtils.showSnackbar(context, Icons.check, 'Saved');
    }catch (e) {
      SnackBarUtils.showSnackbar(context, Icons.error, 'Failed to save');
    }
  }

  void newFile(context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result!= null) { 
        File file = File(result.files.single.path!);
        _selectedFile = file;

        final fileContent = await file.readAsString();

        final lines = fileContent.split('\n');
        titleController.text = lines[2];
        qaController.text = lines[4];
        workgroupController.text = lines[6];
        SnackBarUtils.showSnackbar(context, Icons.upload_file, 'Loaded');
      } else {SnackBarUtils.showSnackbar(context, Icons.error_rounded, 'Failed to load');
      }
    } catch (e) {
      SnackBarUtils.showSnackbar(context, Icons.error, 'Failed to load');
    }
  }

  void clearFields(context) { 
    titleController.clear();
    qaController.clear();
    workgroupController.clear();
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