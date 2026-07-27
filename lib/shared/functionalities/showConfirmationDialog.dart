  import 'package:flutter/material.dart';

void showConfirmationDialog(
      BuildContext context, void Function() onPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text(
          //   'Confirm',
          //   textAlign: TextAlign.center,
          //   style: TextStyle(fontFamily: 'Baloo2SemiBold'),
          // ),
          content: Text(
            'Are you sure you want to clear the chats?',
            style: TextStyle(
                fontFamily: 'QuicksandRegular',
                color: Theme.of(context).colorScheme.onSurface),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(fontFamily: 'QuicksandMedium'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Clear',
                style:
                    TextStyle(color: Colors.red, fontFamily: 'QuicksandMedium'),
              ),
              onPressed: () {
                // Perform the action to clear the chats
                onPressed();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
