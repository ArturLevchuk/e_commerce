import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<bool?> showExitDialog(BuildContext context) => showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        titlePadding:
            const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 0).r,
        contentPadding:
            const EdgeInsets.only(left: 24, right: 24, top: 6, bottom: 0).r,
        title: Text(
          'Are you sure to cancel order?',
          style: TextStyle(fontSize: 18.sp),
        ),
        content: Text(
          "All entered data will not be saved",
          style: TextStyle(fontSize: 16.sp),
        ),
        actions: [
          TextButton(
            child: Text(
              'Exit',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.error, fontSize: 14.sp),
            ),
            onPressed: () async {
              Navigator.of(context).pop(true);
            },
          ),
          TextButton(
            child: Text(
              'Continue order',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 14.sp),
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      ),
    );
