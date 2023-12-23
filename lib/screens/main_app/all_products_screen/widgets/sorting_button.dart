import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SortingButton extends StatelessWidget {
  const SortingButton({
    Key? key,
    required this.press,
    required this.title,
    required this.subtitle,
    required this.icon,
  }) : super(key: key);
  final Function() press;
  final String title, subtitle;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: RPadding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            SizedBox(width: 5.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(
                  subtitle,
                  style: const TextStyle(height: 1),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
