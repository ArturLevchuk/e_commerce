import '/modules/shop_module/core_buisness_logic/products/vm/products_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../apis/models/product.dart';
import '/widgets/back_appbar_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/top_bar.dart';
import 'widgets/rating_card.dart';
import 'widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.productId});
  static const routeName = '/DetailsScreen';

  final String productId;

  @override
  Widget build(BuildContext context) {
    final Product product =
        context.read<ProductsController>().state.prodById(productId);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              appBar(context, product.rating),
              RPadding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: ProductImages(product: product),
              ),
              TopRoundedContainer(
                color: Theme.of(context).colorScheme.surface,
                child: Column(
                  children: [
                    ProductTopBar(product: product),
                    SizedBox(height: 5.w),
                    ExpandableDescription(description: product.description),
                    SizedBox(height: 10.w),
                    ProductOptions(product: product),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context, double rating) {
    return AppBar(
      leading: const SizedBox.shrink(),
      leadingWidth: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          backAppBarButton(context),
          RatingCard(rating: rating),
        ],
      ),
    );
  }
}
