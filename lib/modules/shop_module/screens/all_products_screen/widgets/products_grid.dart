import 'package:flutter_modular/flutter_modular.dart';

import '../../../../../apis/models/product.dart';
import '../../../../../widgets/product_card.dart';
import '/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 0.80.w,
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) => Container(
        padding: const EdgeInsets.all(10).r,
        margin: const EdgeInsets.all(10).r,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          // color: Colors.white,
          boxShadow: [
            themedBoxShadow(Theme.of(context).brightness),
          ],
          borderRadius: BorderRadius.circular(5).r,
        ),
        child: ProductCard(
          aspectRatio: 1.4.w,
          leftPadding: false,
          productId: products[index].id,
          press: () {
            // Navigator.of(context).push(
            //   customSlidePageRouteBuilder(
            //       moveTo: const DetailsScreen(), arguments: products[index].id),
            // );
            Modular.to.pushNamed("/shop${DetailsScreen.routeName}",
                arguments: products[index].id);
          },
        ),
      ),
      itemCount: products.length,
    );
  }
}
