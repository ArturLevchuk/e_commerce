import 'package:e_commerce/widgets/back_appbar_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../repositories/models/product.dart';
import '../home/products_bloc/products_bloc.dart';
import 'widgets/top_bar.dart';
import 'widgets/rating_card.dart';
import 'widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});
  static const routeName = '/DetailsScreen';

  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context)!.settings.arguments as String;
    final Product product = context.read<ProductsBloc>().state.prodById(id);
    return Scaffold(
      // backgroundColor: const Color(0xfff5f6f9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              appBar(context, product),
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

  AppBar appBar(BuildContext context, Product product) {
    return AppBar(
      leading: const SizedBox.shrink(),
      leadingWidth: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          backAppBarButton(context),
          RatingCard(rating: product.rating),
        ],
      ),
    );
  }
}
