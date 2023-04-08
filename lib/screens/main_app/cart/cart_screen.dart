import 'dart:math';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:e_commerce/constants.dart';
import 'package:e_commerce/screens/main_app/cart/cart_bloc/cart_bloc.dart';
import 'package:e_commerce/screens/sign_in_up_screens/widgets/erros_show.dart';
import 'package:e_commerce/size_config.dart';
import 'package:e_commerce/widgets/DefaultButton.dart';
import 'package:e_commerce/widgets/ProductColorCircleAvatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../repositories/models/cart_item.dart';
import '../../../repositories/models/product.dart';
import '../../../routs.dart';
import '../../../utils/CustomScrollBehavior.dart';
import '../orders/orders_confirm_screen/orders_confirm_screen.dart';
import '../home/products_bloc/products_bloc.dart';

part './widgets/checkOutCard.dart';
part './widgets/cartItemCard.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  static const routeName = '/CartScreen';

  Future<void> _refresh(BuildContext context) async {
    final bloc = context.read<CartBloc>().stream.first;
    context.read<CartBloc>().add(RequestCart());
    await bloc;
  }

  @override
  Widget build(BuildContext context) {
    final productListProv = context.read<ProductsBloc>();
    return BlocConsumer<CartBloc, CartState>(
      listener: (context, state) {
        if (state.error != null) {
          showErrorDialog(context, state.error.toString());
        }
      },
      builder: (context, state) {
        final cartList = state.items;
        return Scaffold(
          appBar: newAppBar(context),
          body: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: cartList.isEmpty
                ? Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text(
                        "It's time for Shopping!",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      SizedBox(
                        width: SizeConfig.screenWidth * .8,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: SvgPicture.asset(
                              'assets/images/shopping-sale.svg'),
                        ),
                      ),
                    ]),
                  )
                : CustomRefreshIndicator(
                    builder: MaterialIndicatorDelegate(
                      builder: (context, controller) {
                        final indicator = controller.value.clamp(0.0, 1.0);
                        return Transform.rotate(
                          angle: 2 * pi * controller.value,
                          child: Icon(
                            Icons.refresh,
                            color: kPrimaryColor.withOpacity(indicator),
                          ),
                        );
                      },
                    ),
                    onRefresh: () async {
                      await Future.delayed(
                        const Duration(milliseconds: 500),
                        () async {
                          await _refresh(context);
                        },
                      );
                    },
                    child: ScrollConfiguration(
                      behavior: CustomScrollBehavior(),
                      child: ListView.builder(
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Dismissible(
                            // key: Key(cartList.keys.elementAt(index)),
                            key: UniqueKey(),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: const Color(0xffffe6e6),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(children: [
                                const Spacer(),
                                SvgPicture.asset("assets/icons/Trash.svg"),
                              ]),
                            ),
                            child: CartItemCard(
                              product: productListProv.state.prodById(
                                cartList.values.elementAt(index).productId,
                              ),
                              color: cartList.values.elementAt(index).color,
                              numOfItem:
                                  cartList.values.elementAt(index).numOfItem,
                            ),
                            onDismissed: (direction) async {
                              context
                                  .read<CartBloc>()
                                  .add((RemoveFromCart(index: index)));
                            },
                            confirmDismiss: (dir) {
                              return showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text(
                                      'Are you sure to remove product?'),
                                  titlePadding: const EdgeInsets.only(
                                      left: 24, right: 24, top: 24, bottom: 0),
                                  actions: [
                                    TextButton(
                                        child: const Text('Remove'),
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        }),
                                    TextButton(
                                        child: const Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        }),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        itemCount: cartList.length,
                      ),
                    ),
                  ),
          ),
          bottomNavigationBar: const CheckOutCard(),
        );
      },
    );
  }

  AppBar newAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyText1,
              children: [
                TextSpan(
                    text: "Your Cart\n",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(18))),
                TextSpan(
                  text: "${state.items.length} items",
                  style: const TextStyle(height: 1),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
