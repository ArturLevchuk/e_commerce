import '/modules/authorization/screens/widgets/errors_show.dart';
import '/modules/core_modules/auth_module/vm/auth_controller.dart';
import '/modules/shop_module/core_buisness_logic/products/vm/products_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../apis/models/product.dart';
import '../constants.dart';
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
    final ProductsController productsController =
        Modular.get<ProductsController>();
    final Product product = productsController.state.prodById(productId);
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
                          if (product.prevPrice > 0 &&
                              product.prevPrice > product.price)
                            TextSpan(
                              text: "\$${product.prevPrice}",
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: kgeneralTextColor,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                    ),
                    StreamBuilder<ProductsState>(
                      stream: productsController.stream,
                      builder: (context, snap) {
                        return AnimatedFavRoundButton(
                          onTap: () async {
                            final AuthController authController =
                                context.read<AuthController>();
                            final String userId = authController.state.id;
                            final String authToken = authController.state.token;
                            try {
                              await productsController.changeFavoriteStatus(
                                productid: productId,
                                userId: userId,
                                authToken: authToken,
                              );
                            } catch (err) {
                              // ignore: use_build_context_synchronously
                              showErrorDialog(
                                  context: context, err: err.toString());
                            }
                            // context
                            //     .read<ProductsBloc>()
                            //     .add(ToggleFav(productId));
                          },
                          active: productsController.state.favById(productId),
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
