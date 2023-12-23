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
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30).r,
          decoration: BoxDecoration(
            // color: Colors.white,
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ).r,
            boxShadow: [themedBoxShadow(Theme.of(context).brightness)],
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
                        height: 32.w,
                        width: 32.w,
                        child: SvgPicture.asset("assets/icons/receipt.svg"),
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      Text.rich(
                        TextSpan(
                          text: "Total:\n",
                          children: [
                            TextSpan(
                              text: "\$${totalPrice.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 15.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: .45.sw,
                        child: DefaultButton(
                          text: "Check Out",
                          press: () {
                            if (state.items.isNotEmpty) {
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
        CustomNavigationBar(
          currentIndex: MenuState.cart.index,
          rounded: false,
        ),
      ],
    );
  }
}
