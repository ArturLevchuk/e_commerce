part of '../cart_screen.dart';

class CheckOutCard extends StatelessWidget {
  const CheckOutCard({
    Key? key,
  }) : super(key: key);

  double getTotalprice(Map<String, CartItem> items, ProductsBloc productsBloc) {
    double totalPrice = 0;
    for (var cartItem in items.values) {
      totalPrice += productsBloc.state.getPriceOfItem(cartItem.productId) *
          cartItem.numOfItem;
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    // final cartListProv = Provider.of<CartList>(context);
    final productBloc = context.read<ProductsBloc>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              vertical: getProportionateScreenWidth(15),
              horizontal: getProportionateScreenWidth(30)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, -15),
                  blurRadius: 20,
                  color: Colors.black.withOpacity(.08)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  final totalPrice = getTotalprice(state.items, productBloc);
                  return Row(
                    children: [
                      SizedBox(
                        height: getProportionateScreenWidth(35),
                        width: getProportionateScreenWidth(35),
                        child: SvgPicture.asset("assets/icons/receipt.svg"),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(15),
                      ),
                      Text.rich(
                        TextSpan(
                          text: "Total:\n",
                          children: [
                            TextSpan(
                              text: "\$${totalPrice.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: SizeConfig.screenWidth * .45,
                        child: DefaultButton(
                          text: "Check Out",
                          press: () {
                            if (totalPrice > 0) {
                              Navigator.of(context).pushNamed(
                                OrdersConfirmScreen.routeName,
                                arguments: {
                                  "cartItems": state.items.values.toList(),
                                  "totalPrice": totalPrice,
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        CustomNavigationBar(currentIndex: MenuState.cart.index),
      ],
    );
  }
}
