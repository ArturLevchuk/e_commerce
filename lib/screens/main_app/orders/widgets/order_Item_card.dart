import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../constants.dart';
import '../../../../repositories/models/order_item.dart';
import '../../../../widgets/ProductColorCircleAvatar.dart';
import '../../../../widgets/shadow_bloc.dart';
import '../../../auth_module/widgets/errors_show.dart';
import '../../home/products_bloc/products_bloc.dart';
import '../orders_bloc/orders_bloc.dart';

class OrderItemCard extends StatefulWidget {
  const OrderItemCard({
    Key? key,
    required this.orderItem,
  }) : super(key: key);

  final OrderItem orderItem;

  @override
  State<OrderItemCard> createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<OrderItemCard> {
  bool openCancelOrderButton = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrdersBloc, OrdersState>(
      listener: (context, state) {
        if (state.error != null) {
          showErrorDialog(context, state.error.toString());
        }
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            openCancelOrderButton = !openCancelOrderButton;
          });
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
                    .read<ProductsBloc>()
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
              if (openCancelOrderButton)
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
                              child: Text('Cancel order',
                                  style: Theme.of(context).textTheme.button),
                              onPressed: () async {
                                context
                                    .read<OrdersBloc>()
                                    .add(CancelOrder(widget.orderItem.id));
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('No',
                                  style: Theme.of(context).textTheme.button),
                              onPressed: () {
                                Navigator.of(context).pop();
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
    );
  }
}
