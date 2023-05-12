import 'package:flutter/material.dart';

Future<bool?> showExitDialog(BuildContext context) => showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        titlePadding:
            const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 0),
        contentPadding:
            const EdgeInsets.only(left: 24, right: 24, top: 6, bottom: 0),
        title: const Text('Are you sure to cancel order?'),
        content: const Text("All entered data wont be saved"),
        actions: [
          TextButton(
            child: Text('Ok', style: Theme.of(context).textTheme.button),
            onPressed: () async {
              Navigator.of(context).pop(true);
            },
          ),
          TextButton(
            child: Text('Cancel', style: Theme.of(context).textTheme.button),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      ),
    );
