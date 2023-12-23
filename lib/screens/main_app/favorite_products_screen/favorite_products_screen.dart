import 'package:e_commerce/utils/CustomScrollBehavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../routs.dart';
import '../../../size_config.dart';
import '../home/products_bloc/products_bloc.dart';
import 'widgets/favorite_product_item.dart';

class FavoriteListScreen extends StatelessWidget {
  const FavoriteListScreen({super.key});
  static const routeName = '/FavoriteListScreen';

  @override
  Widget build(BuildContext context) {
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
        child: BlocBuilder<ProductsBloc, ProductsState>(
          builder: (context, state) {
            final favProductList = state.favItems;
            return ListView.builder(
              itemBuilder: (context, index) =>
                  FavoriteProductItem(product: favProductList[index]),
              itemCount: favProductList.length,
            );
          },
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: MenuState.favourite.index,
      ),
    );
  }
}
