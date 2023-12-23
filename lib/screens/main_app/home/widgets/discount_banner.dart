import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DiscountBanner extends StatelessWidget {
  const DiscountBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20).r,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ).r,
      decoration: BoxDecoration(
        color: const Color(0xff4a3298),
        borderRadius: BorderRadius.circular(20).r,
      ),
      child: Text.rich(
        TextSpan(
          text: "A Summer Surprise\n",
          style: const TextStyle(color: Colors.white),
          children: [
            TextSpan(
              text: "Cashback 20%",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
