import '/modules/shop_module/core_buisness_logic/products/vm/products_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../widgets/product_card.dart';
import '../../../../../widgets/section_title.dart';
import '../../all_products_screen/all_products_screen.dart';
import '../../product_details_screen/details_screen.dart';

class PopularProducts extends StatelessWidget {
  const PopularProducts({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductsController productsController =
        context.read<ProductsController>();
    return Column(
      children: [
        SectionTitle(
          text: "Popular Product",
          press: () {
            Modular.to.navigate(".${AllProductsScreen.routeName}");
          },
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: StreamBuilder<ProductsState>(
              stream: productsController.stream,
              builder: (context, snapshot) {
                final productsBlocState = productsController.state;
                return Row(
                  children: [
                    ...List.generate(
                      productsBlocState.popularItems.length,
                      (index) {
                        final productId =
                            productsBlocState.popularItems[index].id;
                        return ProductCard(
                          productId: productId,
                          press: () {
                            Modular.to.pushNamed(
                              ".${DetailsScreen.routeName}",
                              arguments: productId,
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(
                      width: 20.w,
                    )
                  ],
                );
              }),
        ),
      ],
    );
  }
}
