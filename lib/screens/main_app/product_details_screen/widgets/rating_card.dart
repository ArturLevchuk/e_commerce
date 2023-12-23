import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RatingCard extends StatelessWidget {
  const RatingCard({
    super.key,
    required this.rating,
  });

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5).r,
      decoration: BoxDecoration(
        // color: Colors.white,
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14).r,
      ),
      child: Row(
        children: [
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 13.sp,
            ),
          ),
          const SizedBox(width: 5),
          Icon(Icons.star, color: Colors.yellow, size: 17.w),
        ],
      ),
    );
  }
}
