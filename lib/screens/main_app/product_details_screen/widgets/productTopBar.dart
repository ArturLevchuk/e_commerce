import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants.dart';
import '../../../../repositories/models/product.dart';
import '../../../../size_config.dart';
import '../../home/products_bloc/products_bloc.dart';

class ProductTopBar extends StatelessWidget {
  const ProductTopBar({
    super.key,
    required Product product,
  }) : _product = product;

  final Product _product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Text(
            _product.title,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
              child: Text.rich(
                TextSpan(
                  text: "\$${_product.price} ",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(color: kPrimaryColor),
                  children: [
                    if (_product.prev_price > 0 &&
                        _product.prev_price > _product.price)
                      TextSpan(
                        text: "\$${_product.prev_price}  ",
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              fontSize: getProportionateScreenWidth(15),
                              color: kSecondaryColor,
                              decoration: TextDecoration.lineThrough,
                            ),
                      ),
                  ],
                ),
              ),
            ),
            BlocSelector<ProductsBloc, ProductsState, bool>(
              selector: (state) {
                return state.favById(_product.id);
              },
              builder: (context, state) {
                return AnimatedFavButton(
                  productId: _product.id,
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

class AnimatedFavButton extends StatefulWidget {
  const AnimatedFavButton({
    super.key,
    required this.productId,
    required this.state,
  });

  final String productId;
  final bool state;

  @override
  State<AnimatedFavButton> createState() => _AnimatedFavButtonState();
}

class _AnimatedFavButtonState extends State<AnimatedFavButton>
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
        // if (_controller.status == AnimationStatus.completed) {
        //   _controller.reverse();
        // } else {
        //   _controller.forward();
        // }
        _controller.forward().then((_) {
          _controller.value = 0;
        });
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => AnimatedContainer(
          duration: defaultDuration,
          curve: Curves.easeInOut,
          width: getProportionateScreenWidth(64),
          padding: EdgeInsets.all(getProportionateScreenWidth(15)),
          decoration: BoxDecoration(
            color: widget.state
                ? kPrimaryColor.withOpacity(.15)
                : const Color(0xfff5f6f9),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
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
