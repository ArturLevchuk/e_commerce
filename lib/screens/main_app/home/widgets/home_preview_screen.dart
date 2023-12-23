import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants.dart';

class HomePreviewScreen extends StatelessWidget {
  const HomePreviewScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: 20.w),
          Container(
            width: double.infinity,
            height: 90.w,
            margin: const EdgeInsets.symmetric(horizontal: 20).r,
            decoration: BoxDecoration(
              color: kSecondaryColor,
              borderRadius: BorderRadius.circular(20).r,
            ),
          ),
          SizedBox(height: 20.w),
          RPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                5,
                (index) => Column(
                  children: [
                    Container(
                      height: 50.w,
                      width: 50.w,
                      padding: const EdgeInsets.all(10).r,
                      decoration: BoxDecoration(
                        color: kSecondaryColor,
                        borderRadius: BorderRadius.circular(10).r,
                      ),
                    ),
                    ...List.generate(
                      2,
                      (index) => Container(
                        margin: const EdgeInsets.only(top: 5).r,
                        width: 35.w,
                        height: 4.w,
                        decoration: BoxDecoration(
                          color: kSecondaryColor,
                          borderRadius: BorderRadius.circular(10).r,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 30.w),
          RPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 0.4.sw,
                  height: 15.w,
                  decoration: BoxDecoration(
                    color: kSecondaryColor,
                    borderRadius: BorderRadius.circular(10).r,
                  ),
                ),
                Container(
                  width: 0.2.sw,
                  height: 15.w,
                  decoration: BoxDecoration(
                    color: kSecondaryColor,
                    borderRadius: BorderRadius.circular(10).r,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 10.w),
          Row(
            children: [
              SizedBox(
                width: 15.w,
              ),
              Container(
                width: 0.7.sw,
                height: 100.w,
                decoration: BoxDecoration(
                  color: kSecondaryColor,
                  borderRadius: BorderRadius.circular(20).r,
                ),
              ),
              const Spacer(),
              Container(
                width: 0.2.sw,
                height: 100.w,
                decoration: BoxDecoration(
                  color: kSecondaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20).r,
                      bottomLeft: const Radius.circular(20).r),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.w),
          RPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 0.4.sw,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: kSecondaryColor,
                    borderRadius: BorderRadius.circular(10).r,
                  ),
                ),
                Container(
                  width: 0.2.sw,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: kSecondaryColor,
                    borderRadius: BorderRadius.circular(10).r,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 15.w),
          RPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...List.generate(
                  2,
                  (_) => Container(
                    width: 140.w,
                    height: 130.w,
                    decoration: BoxDecoration(
                      color: kSecondaryColor,
                      borderRadius: BorderRadius.circular(10).r,
                    ),
                  ),
                ),
              ],
            ),
          ),
          RPadding(
            padding: const EdgeInsets.all(20),
            child: Container(
              height: 500.w,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10).r,
                color: kSecondaryColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
