import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../../size_config.dart';

class LoadingHomeScreenSplash extends StatelessWidget {
  const LoadingHomeScreenSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenHeight(25)),
              Container(
                width: double.infinity,
                height: getProportionateScreenHeight(110),
                margin: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                decoration: BoxDecoration(
                  color: kSecondaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(25)),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    5,
                    (index) => Column(
                      children: [
                        Container(
                          height: getProportionateScreenWidth(55),
                          width: getProportionateScreenWidth(55),
                          padding:
                              EdgeInsets.all(getProportionateScreenWidth(15)),
                          decoration: BoxDecoration(
                            color: kSecondaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        ...List.generate(
                          2,
                          (index) => Container(
                            margin: const EdgeInsets.only(top: 5),
                            width: getProportionateScreenWidth(40),
                            height: getProportionateScreenWidth(6),
                            decoration: BoxDecoration(
                              color: kSecondaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(60)),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: SizeConfig.screenWidth * 0.4,
                      height: getProportionateScreenWidth(20),
                      decoration: BoxDecoration(
                        color: kSecondaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Container(
                      width: SizeConfig.screenWidth * 0.2,
                      height: getProportionateScreenWidth(20),
                      decoration: BoxDecoration(
                        color: kSecondaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(
                    width: getProportionateScreenWidth(20),
                  ),
                  Container(
                    width: SizeConfig.screenWidth * 0.7,
                    height: getProportionateScreenHeight(140),
                    decoration: BoxDecoration(
                      color: kSecondaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: SizeConfig.screenWidth * 0.2,
                    height: getProportionateScreenHeight(140),
                    decoration: const BoxDecoration(
                      color: kSecondaryColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: SizeConfig.screenWidth * 0.4,
                      height: getProportionateScreenWidth(20),
                      decoration: BoxDecoration(
                        color: kSecondaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Container(
                      width: SizeConfig.screenWidth * 0.2,
                      height: getProportionateScreenWidth(20),
                      decoration: BoxDecoration(
                        color: kSecondaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ...List.generate(
                      2,
                      (_) => Container(
                        width: getProportionateScreenWidth(140),
                        height: getProportionateScreenWidth(130),
                        decoration: const BoxDecoration(
                          color: kSecondaryColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
