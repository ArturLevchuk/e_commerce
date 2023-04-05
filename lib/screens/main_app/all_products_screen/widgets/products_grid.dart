import 'package:flutter/material.dart';
import '../../../../repositories/models/product.dart';
import '../../../../size_config.dart';
import '../../../../widgets/ProductCard.dart';
import '../../product_details_screen/details_screen.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({
    Key? key,
    required this.products,
  }) : super(key: key);

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 0.9,
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) => Container(
        padding: const EdgeInsets.all(10),
        margin: EdgeInsets.all(getProportionateScreenWidth(5)),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              blurRadius: 2.5,
              color: Colors.black26,
            ),
          ],
          borderRadius: BorderRadius.circular(5),
        ),
        child: ProductCard(
          aspectRatio: 1.5,
          leftPadding: false,
          productId: products[index].id,
          press: () {
            Navigator.of(context).pushNamed(
              DetailsScreen.routeName,
              arguments: products[index].id,
            );
          },
        ),
      ),
      itemCount: products.length,
    );
  }
}
