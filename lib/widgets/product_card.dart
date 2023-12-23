import 'package:e_commerce/repositories/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants.dart';
import '../screens/main_app/home/products_bloc/products_bloc.dart';
import 'animated_fav_button.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    required this.productId,
    this.width = 130,
    this.aspectRatio = 1.1,
    required this.press,
    this.leftPadding = true,
  }) : super(key: key);

  final double width, aspectRatio;
  final String productId;
  final GestureTapCallback press;
  final bool leftPadding;

  @override
  Widget build(BuildContext context) {
    Product product = context.read<ProductsBloc>().state.prodById(productId);
    return RPadding(
      padding:
          leftPadding ? const EdgeInsets.only(left: 20).r : EdgeInsets.zero,
      child: GestureDetector(
        onTap: press,
        child: Material(
          color: Colors.transparent,
          child: SizedBox(
            width: width.w,
            height: width.w * 1.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: aspectRatio,
                  child: Container(
                    padding: const EdgeInsets.all(15).r,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(15).r,
                    ),
                    child: FadeInImage.assetNetwork(
                      alignment: Alignment.center,
                      placeholder: "assets/images/box.png",
                      image: product.images.first,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  product.title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: "\$${product.price} ",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        children: [
                          if (product.prev_price > 0 &&
                              product.prev_price > product.price)
                            TextSpan(
                              text: "\$${product.prev_price}",
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: kgeneralTextColor,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                    ),
                    BlocSelector<ProductsBloc, ProductsState, bool>(
                      selector: (state) {
                        return state.favById(productId);
                      },
                      builder: (context, state) {
                        return AnimatedFavRoundButton(
                          onTap: () {
                            context
                                .read<ProductsBloc>()
                                .add(ToggleFav(productId));
                          },
                          active: state,
                        );
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
