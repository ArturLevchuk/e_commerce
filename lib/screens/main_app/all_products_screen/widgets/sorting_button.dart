import 'package:flutter/material.dart';

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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.black),
                ),
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
