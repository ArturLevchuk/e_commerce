import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utils/customPageRouteBuilder.dart';
import '../../../../widgets/product_card.dart';
import '../../../../widgets/section_title.dart';
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
              customFadePageRouteBuilder(
                moveTo: const AllProductsScreen(),
              ),
            );
          },
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              ...List.generate(
                productsBlocState.popularItems.length,
                (index) {
                  return ProductCard(
                    productId: productsBlocState.popularItems[index].id,
                    press: () {
                      Navigator.of(context).push(
                        customSlidePageRouteBuilder(
                          moveTo: const DetailsScreen(),
                          arguments: productsBlocState.items[index].id,
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(
                width: 20.w,
              )
            ],
          ),
        ),
      ],
    );
  }
}
