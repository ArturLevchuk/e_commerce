import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../widgets/section_title.dart';

class SpecialOffers extends StatelessWidget {
  const SpecialOffers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle(
          text: "Special for you",
          press: () {},
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              SpecialOfferCard(
                category: "Smartphone",
                image: "assets/images/Image Banner 2.png",
                numOfBrands: 18,
                press: () {},
              ),
              SpecialOfferCard(
                category: "Fashion",
                image: "assets/images/Image Banner 3.png",
                numOfBrands: 24,
                press: () {},
              ),
              SizedBox(width: 20.w),
            ],
          ),
        ),
      ],
    );
  }
}

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key? key,
    required this.category,
    required this.image,
    required this.numOfBrands,
    required this.press,
  }) : super(key: key);

  final String category, image;
  final int numOfBrands;
  final Function() press;

  @override
  Widget build(BuildContext context) {
    return RPadding(
      padding: const EdgeInsets.only(left: 20),
      child: SizedBox(
        width: 230.w,
        height: 90.w,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20).r,
          child: Stack(
            children: [
              SizedBox.expand(
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xff343434).withOpacity(.4),
                      const Color(0xff343434).withOpacity(.15),
                    ],
                  ),
                ),
              ),
              RPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: Text.rich(
                  TextSpan(
                    style: const TextStyle(color: Colors.white),
                    children: [
                      TextSpan(
                        text: "$category\n",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: "$numOfBrands Brands"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
