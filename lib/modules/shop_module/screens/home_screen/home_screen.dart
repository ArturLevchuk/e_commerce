// ignore_for_file: unused_import

import 'package:awesome_notifications/awesome_notifications.dart';
import '/modules/core_modules/auth_module/vm/auth_controller.dart';
import '/modules/shop_module/core_buisness_logic/products/vm/products_controller.dart';
import '/services/abstracts/notification_service.dart';
import '/services/aw_notification_service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/HomeScreen';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final ProductsController productsController;

  bool showLoadingHomePreviewScreen = true;
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    productsController = Modular.get<ProductsController>();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.0, 0.0),
    ).animate(_controller);
    if (productsController.state.productsLoadStatus ==
        ProductsLoadStatus.loaded) {
      _controller.value = 1;
      setState(() {
        showLoadingHomePreviewScreen = false;
      });
    }
    _offsetAnimation.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        setState(() {
          showLoadingHomePreviewScreen = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ProductsState>(
      stream: productsController.stream,
      builder: (context, snapshot) {
        if (productsController.state.productsLoadStatus ==
                ProductsLoadStatus.loaded &&
            _controller.status == AnimationStatus.dismissed) {
          _controller.forward();
        }
        return Stack(
          children: [
            if (productsController.state.productsLoadStatus ==
                ProductsLoadStatus.loaded)
              Scaffold(
                // extendBody: true,
                body: SafeArea(
                  bottom: false,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 20.w),
                        const DiscountBanner(),
                        SizedBox(height: 20.w),
                        const Categories(),
                        SizedBox(height: 10.w),
                        const SpecialOffers(),
                        SizedBox(height: 10.w),
                        const PopularProducts(),
                        const SizedBox(
                            height: kBottomNavigationBarHeight * 1.2),
                      ],
                    ),
                  ),
                ),
              ),
            Visibility(
              visible: showLoadingHomePreviewScreen,
              child: SlideTransition(
                position: _offsetAnimation,
                child: const LoadingHomePreviewScreen(),
              ),
            ),
          ],
        );
      },
    );
  }
}
