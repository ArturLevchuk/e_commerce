// ignore_for_file: use_build_context_synchronously

import '/apis/models/order_item.dart';
import '/constants.dart';
import '/modules/authorization/screens/widgets/errors_show.dart';
import '/modules/core_modules/auth_module/vm/auth_controller.dart';
import '/modules/shop_module/core_buisness_logic/orders/vm/orders_controller.dart';
import '/modules/shop_module/core_buisness_logic/products/vm/products_controller.dart';
import '/widgets/ProductColorCircleAvatar.dart';
import '/widgets/shadow_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class OrderItemCard extends StatefulWidget {
  const OrderItemCard({
    Key? key,
    required this.orderItem,
  }) : super(key: key);

  final OrderItem orderItem;

  @override
  State<OrderItemCard> createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<OrderItemCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 500,
      ),
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutQuint,
      ),
    );
    _opacityAnimation = Tween<double>(begin: 1, end: 0).animate(_controller);
    super.initState();
  }

  bool expandCard = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTap: () {
            if (!_controller.isAnimating) {
              setState(() {
                expandCard = !expandCard;
              });
            }
          },
          child: ShadowBloc(
            defPadding: 15,
            widget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.orderItem.id,
                      style: TextStyle(
                        color: kgeneralTextColor,
                        fontSize: 12.sp,
                      ),
                    ),
                    Text(
                      DateFormat("dd MMMM yyyy HH:mm")
                          .format(widget.orderItem.dateTime),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Text(
                  widget.orderItem.status,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 5.w),
                const Divider(),
                ...widget.orderItem.products.map((cartItem) {
                  final String productTitle = context
                      .read<ProductsController>()
                      .state
                      .prodById(cartItem.productId)
                      .title;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: productTitle,
                          children: [
                            TextSpan(
                                style: const TextStyle(
                                  color: kgeneralTextColor,
                                ),
                                text: " x${cartItem.numOfItem}")
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Text(
                            'Color:',
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                          SizedBox(width: 5.w),
                          Align(
                            child:
                                ProductColorCircleAvatar(color: cartItem.color),
                          ),
                        ],
                      ),
                    ],
                  );
                }).toList(),
                // const CustomDivider(),
                const Divider(),
                Text.rich(
                  TextSpan(
                    text: "Delivery Place: ",
                    children: [
                      TextSpan(
                        style: const TextStyle(color: kgeneralTextColor),
                        text: widget.orderItem.arrivePlace,
                      ),
                    ],
                  ),
                ),
                Text.rich(
                  TextSpan(
                    text: "Payment: ",
                    children: [
                      TextSpan(
                        style: const TextStyle(color: kgeneralTextColor),
                        text: widget.orderItem.payment,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Price: ",
                      style: TextStyle(
                        fontSize: 15.sp,
                      ),
                    ),
                    Text(
                      "\$${widget.orderItem.totalPrice.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                      ),
                    ),
                  ],
                ),
                if (expandCard)
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Are you sure to cancel order?'),
                            actions: [
                              TextButton(
                                child: Text(
                                  'Cancel order',
                                  style: Theme.of(context).textTheme.button,
                                ),
                                onPressed: () async {
                                  try {
                                    final AuthController authController =
                                        context.read<AuthController>();
                                    final userId = authController.state.id;
                                    final authToken =
                                        authController.state.token;
                                    _controller.forward().then(
                                      (_) async {
                                        await context
                                            .read<OrdersController>()
                                            .cancelOrder(
                                                orderId: widget.orderItem.id,
                                                userId: userId,
                                                authToken: authToken);
                                      },
                                    );

                                    Modular.to.pop();
                                  } catch (err) {
                                    Modular.to.pop();
                                    await showErrorDialog(
                                      context: context,
                                      err: err.toString(),
                                    ).then((_) {
                                      _controller.reverse();
                                    });
                                  }
                                },
                              ),
                              TextButton(
                                child: Text('No',
                                    style: Theme.of(context).textTheme.button),
                                onPressed: () {
                                  Modular.to.pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text(
                        "Cancel Order",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
