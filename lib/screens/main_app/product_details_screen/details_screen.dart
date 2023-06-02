import 'package:e_commerce/constants.dart';
import 'package:e_commerce/size_config.dart';
import 'package:e_commerce/utils/CustomScrollBehavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../repositories/models/product.dart';
import '../home/products_bloc/products_bloc.dart';
import 'widgets/productTopBar.dart';
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
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                appBar(context, product),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: getProportionateScreenWidth(15)),
                  child: ProductImages(product: product),
                ),
                // SizedBox(height: getProportionateScreenWidth(20)),
                TopRoundedContainer(
                  color: Colors.white,
                  child: Column(
                    children: [
                      ProductTopBar(product: product),
                      const SizedBox(height: 5),
                      ProductDescription(product: product),
                      SizedBox(height: getProportionateScreenWidth(10)),
                      ChooseAndAddToCart(product: product),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context, Product product) {
    return AppBar(
      leading: const SizedBox.shrink(),
      leadingWidth: 0,
      backgroundColor: const Color(0xfff5f6f9),
      title: Row(
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
                  product.rating.toStringAsFixed(1),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: kTextColor,
                    fontSize: getProportionateScreenWidth(14),
                  ),
                ),
                const SizedBox(width: 5),
                SvgPicture.asset("assets/icons/Star Icon.svg"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class CustomAppBar extends PreferredSize {
//   final double rating;
//   const CustomAppBar({
//     super.key,
//     required this.rating,
//     required super.child,
//     required super.preferredSize,
//   });
//   // @override
//   // Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Padding(
//         padding:
//             EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(15)),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//               margin: const EdgeInsets.only(top: 5),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//               ),
//               child: IconButton(
//                 splashRadius: 20,
//                 icon: const Icon(Icons.arrow_back_ios),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(14),
//               ),
//               child: Row(
//                 children: [
//                   Text(
//                     rating.toStringAsFixed(1),
//                     style: const TextStyle(fontWeight: FontWeight.w600),
//                   ),
//                   const SizedBox(width: 5),
//                   SvgPicture.asset("assets/icons/Star Icon.svg"),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
