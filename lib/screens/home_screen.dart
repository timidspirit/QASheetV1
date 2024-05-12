import "package:flutter/material.dart";
import "package:qasheets/Wdigets/custom_textfield.dart";
import "package:qasheets/services/file_service.dart";
import "package:qasheets/utils/app_styles.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FileService fileService = FileService();

  @override
  void initState() {
    super.initState();
    addListeners();
  }

  void _onFieldChange() {
    setState(() {
      fileService.fieldsNotEmpty = 
        fileService.titleController.text.isNotEmpty &&
          fileService.qaController.text.isNotEmpty &&
          fileService.workgroupController.text.isNotEmpty;
    });
  }

  void addListeners() {
    List<TextEditingController> controllers = [
      fileService.titleController,
      fileService.qaController,
      fileService.workgroupController,
    ];

    for (TextEditingController controller in controllers) {
      controller.addListener(_onFieldChange);
    }
  }

  void removeListeners() {
    List<TextEditingController> controllers = [
      fileService.titleController,
      fileService.qaController,
      fileService.workgroupController,
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
                _mainButton(() => fileService.newFile(context), 'New File'),
                Row(
                  children: [
                    _actionButton2(
                      () => fileService.clearFields(context), 
                      Icons.delete_forever_rounded),
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
            const SizedBox(height: 20),
            CustomTextField(
              maxLength: 100,
              hinttext: 'Completed or Just Starting',
              controller: fileService.qaController,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              maxLength: 100,
              hinttext: 'Select WorkGroup',
              controller: fileService.workgroupController,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
              _mainButton(
                fileService.fieldsNotEmpty 
                ? () => fileService.saveContent(context) 
                : null , 
                'Save Button'),
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