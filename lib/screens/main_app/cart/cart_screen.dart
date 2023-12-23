import 'dart:math';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:e_commerce/constants.dart';
import 'package:e_commerce/screens/main_app/cart/cart_bloc/cart_bloc.dart';
import 'package:e_commerce/screens/auth_module/widgets/errors_show.dart';
import 'package:e_commerce/size_config.dart';
import 'package:e_commerce/widgets/default_button.dart';
import 'package:e_commerce/widgets/ProductColorCircleAvatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../repositories/models/cart_item.dart';
import '../../../repositories/models/product.dart';
import '../../../routs.dart';
import '../../../utils/CustomScrollBehavior.dart';
import '../orders/orders_confirm_screen/orders_confirm_screen.dart';
import '../home/products_bloc/products_bloc.dart';

part 'widgets/check_out_card.dart';
part 'widgets/cart_item_card.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  static const routeName = '/CartScreen';

  Future<void> _refresh(BuildContext context) async {
    final bloc = context
        .read<CartBloc>()
        .stream
        .firstWhere((state) => state.cartLoadStatus == CartLoadStatus.loaded);
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
          appBar: appBar(context),
          body: RPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: cartList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "It's time for Shopping!",
                          style: Theme.of(context).textTheme.headline5,
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
                      backgroundColor: Theme.of(context).colorScheme.surface,
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
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final CartItem item = cartList.values.elementAt(index);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Dismissible(
                            // key: Key(cartList.keys.elementAt(index)),
                            key: UniqueKey(),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20).r,
                              decoration: BoxDecoration(
                                // color: const Color(0xffffe6e6),
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(15).r,
                              ),
                              child: const Row(children: [
                                Spacer(),
                                Icon(Icons.delete, color: Colors.white),
                              ]),
                            ),
                            child: CartItemCard(
                              product: productListProv.state.prodById(
                                item.productId,
                              ),
                              color: item.color,
                              numOfItem: item.numOfItem,
                            ),
                            onDismissed: (direction) async {
                              context
                                  .read<CartBloc>()
                                  .add((RemoveFromCart(index: index)));
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
                                            style:
                                                TextStyle(color: Colors.red)),
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
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
                                          Navigator.of(context).pop(false);
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
          bottomNavigationBar: const CheckOutCard(),
        );
      },
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: BlocBuilder<CartBloc, CartState>(
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
                  text: "${state.items.length} items",
                  style: const TextStyle(height: 1, color: kgeneralTextColor),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
