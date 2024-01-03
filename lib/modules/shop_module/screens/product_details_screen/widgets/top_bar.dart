// ignore_for_file: use_build_context_synchronously

import '/apis/models/product.dart';
import '/modules/authorization/screens/widgets/errors_show.dart';
import '/modules/core_modules/auth_module/vm/auth_controller.dart';
import '/modules/shop_module/core_buisness_logic/products/vm/products_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../constants.dart';

class ProductTopBar extends StatelessWidget {
  const ProductTopBar({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    final productsController = context.read<ProductsController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            product.title,
            style: TextStyle(fontSize: 20.sp),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RPadding(
              padding: const EdgeInsets.only(left: 20),
              child: Text.rich(
                TextSpan(
                  text: "\$${product.price} ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20.sp,
                  ),
                  children: [
                    if (product.prevPrice > 0 &&
                        product.prevPrice > product.price)
                      TextSpan(
                        text: "\$${product.prevPrice}  ",
                        style: TextStyle(
                          color: kgeneralTextColor,
                          fontSize: 14.sp,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            StreamBuilder<ProductsState>(
              stream: productsController.stream,
              builder: (context, snapshot) {
                return AnimatedFavButtonBlock(
                  productId: product.id,
                  state: productsController.state.favById(product.id),
                );
              },
            ),
          ],
        )
      ],
    );
  }
}

class AnimatedFavButtonBlock extends StatefulWidget {
  const AnimatedFavButtonBlock({
    super.key,
    required this.productId,
    required this.state,
  });

  final String productId;
  final bool state;

  @override
  State<AnimatedFavButtonBlock> createState() => _AnimatedFavButtonBlockState();
}

class _AnimatedFavButtonBlockState extends State<AnimatedFavButtonBlock>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.3), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.3, end: 0.7), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.7, end: 1.0), weight: 1),
    ]).animate(_controller);
  }

  Future<void> changeFavStatus() async {
    try {
      final authController = context.read<AuthController>();
      final userId = authController.state.id;
      final authToken = authController.state.token;
      await context.read<ProductsController>().changeFavoriteStatus(
            productid: widget.productId,
            userId: userId,
            authToken: authToken,
          );
      _controller.forward().then((_) {
        _controller.value = 0;
      });
    } catch (err) {
      showErrorDialog(
        context: context,
        err: err.toString(),
        retryFun: () async {
          await changeFavStatus();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        // context.read<ProductsBloc>().add(ToggleFav(widget.productId));
        await changeFavStatus();
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => AnimatedContainer(
          duration: kAnimationDuration,
          curve: Curves.easeInOut,
          width: 60.w,
          padding: const EdgeInsets.all(15).r,
          decoration: BoxDecoration(
            color: widget.state
                ? kPrimaryColor.withOpacity(.15)
                : Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ).r,
          ),
          child: Transform.scale(
            scale: _animation.value,
            child: SvgPicture.asset(
              "assets/icons/Heart Icon_2.svg",
              color: widget.state ? Colors.red : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
