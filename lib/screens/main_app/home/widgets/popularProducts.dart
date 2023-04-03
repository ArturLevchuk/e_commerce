import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../size_config.dart';
import '../../../../utils/customPageRouteBuilder.dart';
import '../../../../widgets/ProductCard.dart';
import '../../../../widgets/SectionTitle.dart';
import '../../all_products_screen/all_products_screen.dart';
import '../../product_details_screen/details_screen.dart';
import '../products_bloc/products_bloc.dart';

class PopularProducts extends StatelessWidget {
  const PopularProducts({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsBlocState = context.read<ProductsBloc>().state;
    return Column(
      children: [
        SectionTitle(
          text: "Popular Product",
          press: () {
            Navigator.of(context).pushReplacement(
              customPageRouteBuilder(
                moveTo: const AllProductsScreen(),
              ),
            );
          },
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(children: [
            ...List.generate(
              productsBlocState.popularItems.length,
              (index) {
                return ProductCard(
                  productId: productsBlocState.popularItems[index].id,
                  press: () {
                    Navigator.of(context).pushNamed(DetailsScreen.routeName,
                        arguments: productsBlocState.items[index].id);
                  },
                );
              },
            ),
            SizedBox(
              width: getProportionateScreenWidth(20),
            )
          ]),
        ),
      ],
    );
  }
}
