import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      appBar: AppBar(
        titleTextStyle: TextStyle(
            color: Colors.black, fontSize: getProportionateScreenWidth(18)),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Favorite List",
              textAlign: TextAlign.center,
            ),
            SizedBox(width: getProportionateScreenWidth(5)),
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
