import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../constants.dart';
import '../../../../repositories/models/product.dart';
import '../../../../size_config.dart';
import '../../home/products_bloc/products_bloc.dart';

class ProductDescription extends StatelessWidget {
  const ProductDescription({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Text(
            product.title,
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
                  text: "\$${product.price} ",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(color: kPrimaryColor),
                  children: [
                    if (product.prev_price > 0 &&
                        product.prev_price > product.price)
                      TextSpan(
                        text: "\$${product.prev_price}  ",
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
                return state.favById(product.id);
              },
              builder: (context, state) {
                return InkWell(
                  onTap: () {
                    context.read<ProductsBloc>().add(ToggleFav(product.id));
                  },
                  child: AnimatedContainer(
                    duration: defaultDuration,
                    curve: Curves.easeInOut,
                    width: getProportionateScreenWidth(64),
                    padding: EdgeInsets.all(getProportionateScreenWidth(15)),
                    decoration: BoxDecoration(
                      color: state
                          ? kPrimaryColor.withOpacity(.15)
                          : const Color(0xfff5f6f9),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                    ),
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
        const SizedBox(height: 5),
        Padding(
          padding: EdgeInsets.only(
              left: getProportionateScreenWidth(20),
              right: SizeConfig.screenWidth * .2),
          child: Text(product.description, maxLines: 3),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: 10,
          ),
          child: GestureDetector(
            onTap: () {},
            child: Row(
              children: const [
                Text(
                  "See More Details",
                  style: TextStyle(
                      color: kPrimaryColor, fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: kPrimaryColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
