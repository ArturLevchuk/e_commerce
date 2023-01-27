import 'package:e_commerce/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../repositories/models/product.dart';
import '../home/products_bloc/products_bloc.dart';
import 'widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});
  static const routeName = '/DetailsScreen';

  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context)!.settings.arguments as String;
    final Product product = context.read<ProductsBloc>().state.prodById(id);
    return Scaffold(
      backgroundColor: const Color(0xfff5f6f9),
      appBar: CustomAppBar(
          preferredSize: AppBar().preferredSize,
          rating: product.rating,
          child: AppBar()),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProductImages(product: product),
            SizedBox(height: getProportionateScreenWidth(20)),
            TopRoundedContainer(
              color: Colors.white,
              child: Column(
                children: [
                  ProductDescription(product: product),
                  SizedBox(height: getProportionateScreenWidth(10)),
                  ChooseAndAddToCart(product: product),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAppBar extends PreferredSize {
  final double rating;
  const CustomAppBar(
      {super.key,
      required this.rating,
      required super.child,
      required super.preferredSize});

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 5),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                splashRadius: 20,
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Text(
                    rating.toStringAsFixed(1),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 5),
                  SvgPicture.asset("assets/icons/Star Icon.svg"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
