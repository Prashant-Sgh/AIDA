  import 'package:flutter/material.dart';



void showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String confirmText,
  required void Function() onPressed,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontFamily: 'Baloo2SemiBold'),
        ),
        content: Text(
          content,
          style: TextStyle(
              fontFamily: 'QuicksandRegular',
              color: Theme.of(context).colorScheme.onSurface),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Cancel',
              style: TextStyle(fontFamily: 'QuicksandMedium'),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              confirmText,
              style: const TextStyle(
                  color: Colors.red, fontFamily: 'QuicksandMedium'),
            ),
            onPressed: () {
              onPressed();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}