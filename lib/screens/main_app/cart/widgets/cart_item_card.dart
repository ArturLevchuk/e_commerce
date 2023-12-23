part of '../cart_screen.dart';

class CartItemCard extends StatelessWidget {
  final Product product;
  final Color color;
  final int numOfItem;

  const CartItemCard({
    super.key,
    required this.product,
    required this.color,
    required this.numOfItem,
  });

  String getTotalCartItemPrice(double price, int numOfItems) {
    final double res = product.price * numOfItem;
    return res.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 84.w,
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              padding: const EdgeInsets.all(10).r,
              decoration: BoxDecoration(
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
        ),
        SizedBox(width: 20.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.title,
                style: TextStyle(fontSize: 16.sp),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  Text(
                    "Color:",
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 14.sp),
                  ),
                  const SizedBox(width: 5),
                  ProductColorCircleAvatar(color: color),
                ],
              ),
              Text.rich(
                TextSpan(
                  text: "\$${product.price}",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    // color: kPrimaryColor,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  children: [
                    TextSpan(
                      text: " x$numOfItem =  ",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    TextSpan(
                      text:
                          "\$${getTotalCartItemPrice(product.price, numOfItem)}",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
