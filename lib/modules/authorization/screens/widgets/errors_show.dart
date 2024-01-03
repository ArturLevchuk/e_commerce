import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<dynamic> showErrorDialog(
    {required BuildContext context,
    required String err,
    Function()? retryFun}) {
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
        if (retryFun != null)
          TextButton(
            onPressed: () {
              Modular.to.pop();
              retryFun();
            },
            child: Text(
              "Retry",
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
        TextButton(
          onPressed: () {
            // Modular.to.pop();;
            Modular.to.pop();
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
