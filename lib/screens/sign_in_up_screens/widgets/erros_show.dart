import 'package:flutter/material.dart';

import '../../../utils/HttpException.dart';

Future<dynamic> showErrorDialog(BuildContext context, String err) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      titlePadding:
          const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 0),
      contentPadding:
          const EdgeInsets.only(left: 24, right: 24, top: 6, bottom: 0),
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
            style: Theme.of(context).textTheme.button,
          ),
        ),
      ],
    ),
  );
}
