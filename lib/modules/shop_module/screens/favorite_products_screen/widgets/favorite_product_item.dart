import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../apis/models/product.dart';
import '../../product_details_screen/details_screen.dart';

class FavoriteProductItem extends StatelessWidget {
  const FavoriteProductItem({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Modular.to
            .pushNamed(".${DetailsScreen.routeName}", arguments: product.id);
      },
      child: RPadding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: SizedBox(
          height: 86.w,
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  padding: const EdgeInsets.all(10).r,
                  decoration: BoxDecoration(
                    // color: const Color(0xfff5f6f9),
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(15).r,
                  ),
                  child: FadeInImage.assetNetwork(
                    alignment: Alignment.center,
                    placeholder: "assets/images/box.png",
                    image: product.images.first,
                  ),
                ),
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(flex: 2),
                    Text(
                      product.title,
                      style: TextStyle(
                        fontSize: 15.sp,
                        // color: Colors.black,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 2,
                    ),
                    const Spacer(),
                    Text("\$${product.price}"),
                    const Spacer(flex: 2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
