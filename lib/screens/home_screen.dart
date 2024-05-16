import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qasheets/Wdigets/custom_textfield.dart';
import 'package:qasheets/services/file_service.dart';
import 'package:qasheets/services/pdf_service.dart';
import 'package:qasheets/utils/app_styles.dart';

enum QAStatus {
  completed,
  starting,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FileService fileService = FileService();
  QAStatus? _selectedStatus = QAStatus.starting;
  List<Map<String, dynamic>> _excelData = [];

  @override
  void initState() {
    super.initState();
    addListeners();
  }

  void _onFieldChange() {
    setState(() {
      fileService.fieldsNotEmpty = fileService.titleController.text.isNotEmpty &&
          fileService.qaController.text.isNotEmpty;
    });
  }

  void addListeners() {
    List<TextEditingController> controllers = [
      fileService.titleController,
      fileService.qaController,
    ];

    for (TextEditingController controller in controllers) {
      controller.addListener(_onFieldChange);
    }
  }

  void removeListeners() {
    List<TextEditingController> controllers = [
      fileService.titleController,
      fileService.qaController,
    ];

    for (TextEditingController controller in controllers) {
      controller.removeListener(_onFieldChange);
    }
  }

  @override
  void dispose() {
    removeListeners();
    super.dispose();
  }

  void _importExcel() async {
    await fileService.importExcel(context, (data) {
      setState(() {
        _excelData = data;
        fileService.setExcelData(data);
        if (_excelData.isNotEmpty) {
          if (kDebugMode) {
            print("Excel Data Keys: ${_excelData[0].keys}");
          }
        } else {
          if (kDebugMode) {
            print("Excel Data is empty");
          }
        }
      });
    });
  }

  void _exportData() async {
    if (_excelData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please import Excel data first')),
      );
      return;
    }

    String folderName;
    if (fileService.titleController.text.isNotEmpty) {
      folderName = fileService.titleController.text;
    } else {
      folderName = (await fileService.getExportDirectoryName()).split('/').last;
    }

    String exportDirectoryPath = '${fileService.getSelectedDirectory()}/$folderName';
    Directory exportDirectory = Directory(exportDirectoryPath);
    if (!exportDirectory.existsSync()) {
      exportDirectory.createSync(recursive: true);
    }

    PdfService pdfService = PdfService();

    for (var row in _excelData) {
      if (kDebugMode) {
        print("Generating PDF for row: $row");
      }
      await pdfService.generatePdf(
        row,
        fileService.titleController.text,
        _selectedStatus?.toString().split('.').last ?? 'Unknown Status',
        exportDirectory,
      );
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All PDFs have been saved to $exportDirectoryPath')),
      );
    }
  }

  void _handleRightClick(BuildContext context, Offset position) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        position & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      items: [
        const PopupMenuItem(
          value: 'appReset',
          child: Text('App Reset'),
        ),
      ],
    ).then((value) {
      if (value != null) {
        switch (value) {
          case 'appReset':
            fileService.appReset(context);
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.dark,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _mainButton(_importExcel, 'Import New File'),
                _mainButton(() => fileService.newDirectory(context), 'Set Export Directory'),
                Row(
                  children: [
                    GestureDetector(
                      onSecondaryTapDown: (details) {
                        _handleRightClick(context, details.globalPosition);
                      },
                      child: _actionButton2(
                        () => fileService.clearFields(context),
                        Icons.delete_forever_rounded,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomTextField(
              maxLength: 100,
              maxLines: 3,
              hinttext: 'Leave blank or enter to name output folder',
              controller: fileService.titleController,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    title: const Text('Completed'),
                    titleTextStyle: AppTheme.optionStyle,
                    leading: Radio<QAStatus>(
                      value: QAStatus.completed,
                      groupValue: _selectedStatus,
                      onChanged: (QAStatus? value) {
                        setState(() {
                          _selectedStatus = value;
                          fileService.qaController.text = value.toString().split('.').last;
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('Just Starting'),
                    titleTextStyle: AppTheme.optionStyle,
                    leading: Radio<QAStatus>(
                      value: QAStatus.starting,
                      groupValue: _selectedStatus,
                      onChanged: (QAStatus? value) {
                        setState(() {
                          _selectedStatus = value;
                          fileService.qaController.text = value.toString().split('.').last;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _mainButton(
                      _excelData.isNotEmpty ? _exportData : null,
                      'Export to PDF',
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _mainButton(
                      _excelData.isNotEmpty && _excelData.isEmpty ? () {} : null,
                      'Export for Odoo',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: _mainButton(
                      _excelData.isNotEmpty && _excelData.isEmpty? () {} : null,
                      'Export Both',
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  ElevatedButton _mainButton(Function()? onPressed, String text) {
    return ElevatedButton(
      onPressed: onPressed,
      style: _buttonStyle(),
      child: Text(text),
    );
  }

  IconButton _actionButton2(Function()? onPressed, IconData icon) {
    return IconButton(
      onPressed: onPressed,
      splashRadius: 15,
      splashColor: AppTheme.accent,
      icon: Icon(
        icon,
        color: AppTheme.med,
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppTheme.accent,
      foregroundColor: AppTheme.light,
      disabledBackgroundColor: AppTheme.disabledbackgroundColor,
      disabledForegroundColor: AppTheme.disabledforegroundColor,
    );
  }
}
