import 'package:flutter/material.dart';
import '../../../../repositories/models/product.dart';
import '../../../../size_config.dart';
import '../../../../utils/customPageRouteBuilder.dart';
import '../../product_details_screen/details_screen.dart';

class FavoriteProductItem extends StatelessWidget {
  const FavoriteProductItem({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          customSlidePageRouteBuilder(
              moveTo: const DetailsScreen(), arguments: product.id),
        );
        //  Navigator.of(context)
        //     .pushNamed(DetailsScreen.routeName, arguments: product.id);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
          vertical: getProportionateScreenWidth(10),
        ),
        child: Row(
          children: [
            SizedBox(
              width: getProportionateScreenWidth(88),
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xfff5f6f9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: FadeInImage.assetNetwork(
                    alignment: Alignment.center,
                    placeholder: "assets/images/box.png",
                    image: product.images[0],
                  ),
                ),
              ),
            ),
            SizedBox(width: getProportionateScreenWidth(20)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  maxLines: 2,
                ),
                const SizedBox(height: 10),
                Text("\$${product.price}"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
