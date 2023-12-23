import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductColorCircleAvatar extends StatelessWidget {
  const ProductColorCircleAvatar({
    Key? key,
    required this.color,
  }) : super(key: key);
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12.w,
      height: 12.w,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
    );
  }
}
