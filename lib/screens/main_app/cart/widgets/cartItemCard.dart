part of  '../cart_screen.dart';

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
          width: getProportionateScreenWidth(88),
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xfff5f6f9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: FadeInImage.assetNetwork(
                alignment: Alignment.center,
                placeholder: "assets/images/box.png",
                image: product.images[0],
              ),
            ),
          ),
        ),
        SizedBox(width: getProportionateScreenWidth(20)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.title,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              maxLines: 2,
            ),
            Row(
              children: [
                const Text(
                  "Color:",
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                SizedBox(width: getProportionateScreenWidth(5)),
                ProductColorCircleAvatar(color: color),
              ],
            ),
            Text.rich(
              TextSpan(
                text: "\$${product.price}",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: kPrimaryColor,
                ),
                children: [
                  TextSpan(
                    text: " x$numOfItem =  ",
                    style: const TextStyle(color: kTextColor),
                  ),
                  TextSpan(
                    text:
                        "\$${getTotalCartItemPrice(product.price, numOfItem)}",
                    style: const TextStyle(color: kPrimaryColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
