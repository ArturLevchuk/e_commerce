import 'package:e_commerce/repositories/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';
import '../constants.dart';
// import '../providers/auth.dart';
// import '../providers/products.dart';
import '../screens/main_app/home/products_bloc/products_bloc.dart';
import '../size_config.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    required this.productId,
    this.width = 140,
    this.aspectRatio = 1.02,
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
    return Padding(
      padding: leftPadding
          ? EdgeInsets.only(left: getProportionateScreenWidth(20))
          : EdgeInsets.zero,
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: getProportionateScreenWidth(width),
          height: getProportionateScreenWidth(width * 1.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: aspectRatio,
                child: Container(
                  padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  // child: Image.network(product.images[0]),
                  child: FadeInImage.assetNetwork(
                    alignment: Alignment.center,
                    placeholder: "assets/images/box.png",
                    image: product.images[0],
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                product.title,
                style: const TextStyle(color: Colors.black),
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
                        fontSize: getProportionateScreenWidth(18),
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                      children: [
                        if (product.prev_price > 0 &&
                            product.prev_price > product.price)
                          TextSpan(
                            text: "\$${product.prev_price}",
                            style: TextStyle(
                                fontSize: getProportionateScreenWidth(11.5),
                                fontWeight: FontWeight.w600,
                                color: kSecondaryColor,
                                decoration: TextDecoration.lineThrough),
                          ),
                      ],
                    ),
                  ),
                  BlocSelector<ProductsBloc, ProductsState, bool>(
                    selector: (state) {
                      return state.favById(productId);
                    },
                    builder: (context, state) {
                      return InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {
                          context
                              .read<ProductsBloc>()
                              .add(ToggleFav(productId));
                        },
                        child: Container(
                          width: getProportionateScreenWidth(28),
                          height: getProportionateScreenWidth(28),
                          decoration: BoxDecoration(
                            color: state
                                ? kPrimaryColor.withOpacity(.15)
                                : kSecondaryColor.withOpacity(.1),
                            shape: BoxShape.circle,
                          ),
                          padding:
                              EdgeInsets.all(getProportionateScreenWidth(8)),
                          child: SvgPicture.asset(
                            "assets/icons/Heart Icon_2.svg",
                            color: state ? Colors.red : Colors.grey,
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
