import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';
import '../size_config.dart';

class IconBtnWithCounter extends StatelessWidget {
  const IconBtnWithCounter({
    Key? key,
    required this.svgSrc,
    this.numOfItems = 0,
    required this.press,
  }) : super(key: key);

  final String svgSrc;
  final int numOfItems;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      borderRadius: BorderRadius.circular(50),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: getProportionateScreenWidth(46),
            width: getProportionateScreenWidth(46),
            padding: EdgeInsets.all(getProportionateScreenWidth(12)),
            decoration: BoxDecoration(
              color: kSecondaryColor.withOpacity(.1),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(svgSrc),
          ),
          if (numOfItems > 1)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                height: getProportionateScreenWidth(16),
                width: getProportionateScreenWidth(16),
                decoration: BoxDecoration(
                  color: const Color(0xffff4848),
                  shape: BoxShape.circle,
                  border: Border.all(width: 1.5, color: Colors.red),
                ),
                child: Center(
                  child: Text(
                    "$numOfItems",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: getProportionateScreenWidth(10),
                      height: 1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class IconWithCounter extends StatelessWidget {
  const IconWithCounter({
    super.key,
    required this.svgSrc,
    this.numOfItems = 0,
    this.color = Colors.grey,
  });

  final String svgSrc;
  final int numOfItems;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getProportionateScreenWidth(35),
      height: getProportionateScreenWidth(30),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: AlignmentDirectional.centerStart,
        children: [
          SizedBox(
            height: getProportionateScreenWidth(24),
            width: getProportionateScreenWidth(24),
            // padding: EdgeInsets.all(getProportionateScreenWidth(3)),
            child: SvgPicture.asset(
              svgSrc,
              color: color,
            ),
          ),
          if (numOfItems > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                height: getProportionateScreenWidth(15),
                width: getProportionateScreenWidth(15),
                decoration: BoxDecoration(
                  color: const Color(0xffff4848),
                  shape: BoxShape.circle,
                  border: Border.all(width: 1.5, color: Colors.red),
                ),
                child: Center(
                  child: Text(
                    "$numOfItems",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: getProportionateScreenWidth(10),
                      height: 1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
