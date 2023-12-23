import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<dynamic> showErrorDialog(BuildContext context, String err) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      titlePadding:
          const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 0).r,
      contentPadding:
          const EdgeInsets.only(left: 24, right: 24, top: 6, bottom: 0).r,
      title: const Text('Error occured!'),
      content: Text(
        err,
        maxLines: 6,
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Close',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
      ],
    ),
  );
}
