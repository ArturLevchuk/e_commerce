import 'dart:math';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import '/modules/shop_module/core_buisness_logic/cart/vm/cart_controller.dart';
import '/widgets/loading_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../apis/models/cart_item.dart';
import '../../../../apis/models/product.dart';
import '../../../core_modules/auth_module/vm/auth_controller.dart';
import '../../core_buisness_logic/products/vm/products_controller.dart';
import '/constants.dart';
import '/modules/authorization/screens/widgets/errors_show.dart';
import '/widgets/default_button.dart';
import '/widgets/ProductColorCircleAvatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../orders/orders_confirm_screen/orders_confirm_screen.dart';

part 'widgets/check_out_card.dart';
part 'widgets/cart_item_card.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  static const routeName = '/CartScreen';

  Future<void> _refresh(BuildContext context) async {
    try {
      final authController = context.read<AuthController>();
      final userId = authController.state.id;
      final authToken = authController.state.token;
      await context.read<CartController>().fetchAndSetCart(
            userId: userId,
            authToken: authToken,
            silentUpdate: true,
          );
    } catch (err) {
      // ignore: use_build_context_synchronously
      showErrorDialog(
        context: context,
        err: err.toString(),
        retryFun: () async {
          await _refresh(context);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsController = context.read<ProductsController>();
    final cartController = context.read<CartController>();
    final authController = context.read<AuthController>();
    return StreamBuilder<CartState>(
      stream: cartController.stream,
      builder: (context, state) {
        if (cartController.state.cartLoadStatus == CartLoadStatus.loaded) {
          final cartList = cartController.state.items;
          return SafeArea(
            child: Scaffold(
              appBar: appBar(context),
              body: Column(
                children: [
                  Expanded(
                    child: RPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: cartList.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "It's time for Shopping!",
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                  SizedBox(height: 10.w),
                                  AspectRatio(
                                    aspectRatio: 1,
                                    child: SvgPicture.asset(
                                      'assets/images/shopping-sale.svg',
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : CustomRefreshIndicator(
                              builder: MaterialIndicatorDelegate(
                                backgroundColor:
                                    Theme.of(context).colorScheme.surface,
                                builder: (context, controller) {
                                  final indicator =
                                      controller.value.clamp(0.0, 1.0);
                                  return Transform.rotate(
                                    angle: 2 * pi * controller.value,
                                    child: Icon(
                                      Icons.refresh,
                                      color:
                                          kPrimaryColor.withOpacity(indicator),
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
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  final CartItem item =
                                      cartList.values.elementAt(index);
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Dismissible(
                                      key: ValueKey(
                                          cartList.keys.elementAt(index)),
                                      // key: UniqueKey(),
                                      direction: DismissDirection.endToStart,
                                      background: Container(
                                        padding: const EdgeInsets.symmetric(
                                                horizontal: 20)
                                            .r,
                                        decoration: BoxDecoration(
                                          // color: const Color(0xffffe6e6),
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(15).r,
                                        ),
                                        child: const Row(children: [
                                          Spacer(),
                                          Icon(Icons.delete,
                                              color: Colors.white),
                                        ]),
                                      ),
                                      child: CartItemCard(
                                        product:
                                            productsController.state.prodById(
                                          item.productId,
                                        ),
                                        color: item.color,
                                        numOfItem: item.numOfItem,
                                      ),
                                      onDismissed: (direction) async {
                                        final userId = authController.state.id;
                                        final authToken =
                                            authController.state.token;
                                        try {
                                          cartController.removeFromCart(
                                            cartId:
                                                cartList.keys.elementAt(index),
                                            userId: userId,
                                            authToken: authToken,
                                          );
                                        } catch (err) {
                                          await showErrorDialog(
                                            context: context,
                                            err: err.toString(),
                                          );
                                        }
                                      },
                                      confirmDismiss: (_) {
                                        return showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text(
                                                'Are you sure to remove product?'),
                                            titlePadding: const EdgeInsets.only(
                                              left: 24,
                                              right: 24,
                                              top: 24,
                                              bottom: 0,
                                            ).r,
                                            actions: [
                                              TextButton(
                                                  child: const Text('Remove',
                                                      style: TextStyle(
                                                          color: Colors.red)),
                                                  onPressed: () {
                                                    Modular.to.pop(true);
                                                  }),
                                              TextButton(
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurface),
                                                  ),
                                                  onPressed: () {
                                                    Modular.to.pop(false);
                                                  }),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                                itemCount: cartList.length,
                              ),
                            ),
                    ),
                  ),
                  const CheckOutCard()
                ],
              ),
            ),
          );
        } else {
          return const LoadingScreen();
        }
      },
    );
  }

  AppBar appBar(BuildContext context) {
    final cartController = context.read<CartController>();
    return AppBar(
      centerTitle: true,
      title: StreamBuilder<CartState>(
        stream: cartController.stream,
        builder: (context, state) {
          return Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              children: [
                TextSpan(
                  text: "Your Cart\n",
                  style: TextStyle(
                      fontSize: 18.sp,
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                TextSpan(
                  text: "${cartController.state.items.length} items",
                  style: const TextStyle(
                    height: 1,
                    // color: kgeneralTextColor,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
