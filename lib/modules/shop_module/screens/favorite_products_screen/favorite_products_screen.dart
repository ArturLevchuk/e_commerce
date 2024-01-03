import '/modules/shop_module/core_buisness_logic/products/vm/products_controller.dart';
import '/widgets/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'widgets/favorite_product_item.dart';

class FavoriteListScreen extends StatelessWidget {
  const FavoriteListScreen({super.key});
  static const routeName = '/FavoriteListScreen';

  @override
  Widget build(BuildContext context) {
    final productsController = context.read<ProductsController>();
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        titleTextStyle: Theme.of(context)
            .appBarTheme
            .titleTextStyle
            ?.copyWith(color: Theme.of(context).colorScheme.onBackground),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Favorite List",
              textAlign: TextAlign.center,
            ),
            SizedBox(width: 5.w),
            SvgPicture.asset(
              "assets/icons/Heart Icon_2.svg",
              color: Colors.red,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<ProductsState>(
          stream: productsController.stream,
          builder: (context, snap) {
            if (productsController.state.productsLoadStatus ==
                ProductsLoadStatus.loaded) {
              final favProductList = productsController.state.favItems;
              return ListView.builder(
                itemBuilder: (context, index) =>
                    FavoriteProductItem(product: favProductList[index]),
                itemCount: favProductList.length,
              );
            } else {
              return const LoadingScreen();
            }
          },
        ),
      ),
    );
  }
}
