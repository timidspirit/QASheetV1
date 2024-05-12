import "package:flutter/material.dart";
import "package:qasheets/utils/app_styles.dart";


class SnackBarUtils {
  static void showSnackbar(BuildContext context, IconData icon, String message){
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [Icon(
            icon, color: AppTheme.accent,
            ),
            const SizedBox(width: 10,),
            Text(message,)
          ],
         ),
       ),
    );
  }
}