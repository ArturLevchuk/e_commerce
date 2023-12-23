import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants.dart';
import '../../../../repositories/models/product.dart';
import '../../home/products_bloc/products_bloc.dart';

class ProductTopBar extends StatelessWidget {
  const ProductTopBar({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
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
                    if (product.prev_price > 0 &&
                        product.prev_price > product.price)
                      TextSpan(
                        text: "\$${product.prev_price}  ",
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
            BlocSelector<ProductsBloc, ProductsState, bool>(
              selector: (state) {
                return state.favById(product.id);
              },
              builder: (context, state) {
                return AnimatedFavButtonBlock(
                  productId: product.id,
                  state: state,
                );
              },
            )
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<ProductsBloc>().add(ToggleFav(widget.productId));
        _controller.forward().then((_) {
          _controller.value = 0;
        });
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
