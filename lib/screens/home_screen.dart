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
      });
    });
  }

  void _exportData() async {
    if (_excelData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please import Excel data first')),
      );
      return;
    }

    PdfService pdfService = PdfService();
    String pdfPath = await pdfService.generatePdf(
      _excelData,
      fileService.titleController.text,
      _selectedStatus?.toString().split('.').last ?? 'Unknown Status',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF saved to $pdfPath')),
    );
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
                _mainButton(_importExcel, 'New File'),
                Row(
                  children: [
                    _actionButton2(
                      () => fileService.clearFields(context),
                      Icons.delete_forever_rounded,
                    ),
                    const SizedBox(width: 8),
                    _actionButton2(() => fileService.newDirectory(context), Icons.folder),
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
            const SizedBox(height: 100),
            Row(
              children: [
                _mainButton(
                  _excelData.isNotEmpty
                      ? _exportData
                      : null,
                  'Export to PDF',
                ),
              ],
            ),
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
