import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:qasheets/utils/app_styles.dart";
import "package:qasheets/utils/snackbar_utils.dart";

class CustomTextField extends StatefulWidget {
  final int maxLength;
  final int? maxLines;
  final String hinttext;
  final TextEditingController controller;


  const CustomTextField(
    {super.key, 
    required this.maxLength, 
    this.maxLines, 
    required this.hinttext,
    required this.controller,
    }
    );

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void copyToClipBoard(context, String text) {
    Clipboard.setData(ClipboardData(text:text));
    SnackBarUtils.showSnackbar(context, Icons.content_copy, 'Copied to Clipboard');

  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        focusNode: _focusNode,
        onEditingComplete: () => FocusScope.of(context).nextFocus(),
        controller: widget.controller,
        maxLength: widget.maxLength,
        maxLines: widget.maxLines,
        keyboardType: TextInputType.multiline,
        cursorColor: AppTheme.accent,
        style: AppTheme.inputStyle,
        decoration: InputDecoration(
          hintStyle: AppTheme.hintStyle,
          hintText: widget.hinttext,
          suffixIcon: _copyButton(context),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: AppTheme.accent
              ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: AppTheme.med,
              ),
            ),
            counterStyle: AppTheme.counterStyle
        ),
    );
  }

  IconButton _copyButton(BuildContext context) {
    return IconButton(onPressed: widget.controller.text.isNotEmpty ? () => copyToClipBoard(context, widget.controller.text) : null, 
    color: AppTheme.accent, 
    icon: const Icon(Icons.copy_rounded),
    );
  }
}