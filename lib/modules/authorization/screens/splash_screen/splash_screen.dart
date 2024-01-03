import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';

import '../sign_in_screen/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants.dart';
import '../../../../widgets/default_button.dart';

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

  @override
  void initState() {
    super.initState();
    animTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      pageController.animateToPage(
        currentPage < splashData.length
            ? currentPage++
            : pageController.initialPage,
        duration: kAnimationDuration,
        curve: currentPage < splashData.length
            ? Curves.easeInOut
            : Curves.fastOutSlowIn,
      );
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
        height: 1.sh,
        width: double.infinity,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Flexible(
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
                    RPadding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          splashData.length,
                          (index) => buildDot(index: index),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: RPadding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DefaultButton(
                        text: "Continue",
                        press: () {
                          Modular.to.navigate(".${SignInScreen.routeName}");
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
      duration: kAnimationDuration,
      curve: Curves.bounceInOut,
      height: 6,
      width: currentPage == index ? 20 : 6,
      margin: const EdgeInsets.only(right: 5).r,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : const Color(0xFF979797),
        borderRadius: BorderRadius.circular(3).r,
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
            fontSize: 34.sp,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 16.sp,
          ),
          textAlign: TextAlign.center,
        ),
        const Spacer(flex: 2),
        AspectRatio(
          aspectRatio: 1.5.w,
          child: Image.asset(
            image,
          ),
        ),
      ],
    );
  }
}
