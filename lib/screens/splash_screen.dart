import 'dart:async';

import 'package:e_commerce/screens/sign_in_up_screens/sign_in_screen.dart';
import 'package:e_commerce/size_config.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/DefaultButton.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const routeName = '/SplashScreen';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int currentPage = 0;
  final PageController pageController = PageController();
  late final Timer animTimer;
  final List<Map<String, String>> splashData = [
    {
      "text": "Welcome to Ecommerce, Let’s shop!",
      "image": "assets/images/splash_1.png"
    },
    {
      "text": "We help people conect with store \naround Ukraine",
      "image": "assets/images/splash_2.png"
    },
    {
      "text": "We show the easy way to shop. \nJust stay at home with us",
      "image": "assets/images/splash_3.png"
    },
  ];

  @override
  void initState() {
    super.initState();
    animTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (currentPage < splashData.length) {
        pageController.animateToPage(
          currentPage++,
          duration: defaultDuration,
          curve: Curves.easeInOut,
        );
      } else {
        pageController.animateToPage(
          pageController.initialPage,
          duration: defaultDuration,
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  @override
  void dispose() {
    animTimer.cancel();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: PageView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => SplashContent(
                    text: splashData[index]['text']!,
                    image: splashData[index]['image']!,
                  ),
                  itemCount: splashData.length,
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  controller: pageController,
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: getProportionateScreenWidth(20),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          splashData.length,
                          (index) => buildDot(index: index),
                        ),
                      ),
                      const Spacer(),
                      // const Spacer(flex: 2),
                      DefaultButton(
                        text: "Continue",
                        press: () {
                          Navigator.of(context)
                              .popAndPushNamed(SignInScreen.routeName);
                        },
                      ),
                      // const Spacer(),
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

  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      duration: defaultDuration,
      curve: Curves.bounceInOut,
      height: 6,
      width: currentPage == index ? 20 : 6,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : Colors.black12,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class SplashContent extends StatelessWidget {
  final String text;
  final String image;
  const SplashContent({
    Key? key,
    required this.image,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Text(
          "Ecommerce",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(36),
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            color: kTextColor,
            fontSize: getProportionateScreenWidth(16),
          ),
          textAlign: TextAlign.center,
        ),
        const Spacer(flex: 2),
        AspectRatio(
          aspectRatio: 1.8,
          child: Image.asset(
            image,
            // height: getProportionateScreenHeight(265),
            // width: getProportionateScreenWidth(235),
          ),
        ),
      ],
    );
  }
}
