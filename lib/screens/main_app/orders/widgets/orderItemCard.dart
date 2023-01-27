import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../constants.dart';
import '../../../../repositories/models/order_item.dart';
import '../../../../size_config.dart';
import '../../../../utils/HttpException.dart';
import '../../../../widgets/ProductColorCircleAvatar.dart';
import '../../../../widgets/ShadowBloc.dart';
import '../../../sign_in_up_screens/widgets/erros_show.dart';
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
    final double prodInfvlocHeight = (widget.orderItem.products.length - 1) *
        getProportionateScreenWidth(40);

    return GestureDetector(
      onTap: () {
        setState(() {
          openCancelOrderButton = !openCancelOrderButton;
        });
      },
      child: ShadowBloc(
        containerHeight: openCancelOrderButton
            ? getProportionateScreenWidth(255 + prodInfvlocHeight)
            : getProportionateScreenWidth(210 + prodInfvlocHeight),
        defPadding: 15,
        widget: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.orderItem.id,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(12),
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
              const SizedBox(height: 5),
              const CustomDivider(),
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
                              style: const TextStyle(color: Colors.black87),
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
                        SizedBox(width: getProportionateScreenWidth(5)),
                        ProductColorCircleAvatar(color: cartItem.color),
                      ],
                    ),
                    SizedBox(height: getProportionateScreenWidth(5)),
                  ],
                );
              }).toList(),
              const CustomDivider(),
              Text.rich(
                TextSpan(
                  text: "Delivery Place: ",
                  children: [
                    TextSpan(
                      style: const TextStyle(color: Colors.black),
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
                      style: const TextStyle(color: Colors.black),
                      text: widget.orderItem.payment
                              .contains("Payment upon receipt")
                          ? "Payment upon receipt"
                          : "Paid by card",
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
                      fontSize: getProportionateScreenWidth(16),
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "\$${widget.orderItem.totalPrice.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: getProportionateScreenWidth(16),
                    ),
                  ),
                ],
              ),
              if (openCancelOrderButton)
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          titlePadding: const EdgeInsets.only(
                              left: 24, right: 24, top: 24, bottom: 0),
                          title: const Text('Are you sure to cancel order?'),
                          actions: [
                            TextButton(
                              child: Text('Ok',
                                  style: Theme.of(context).textTheme.button),
                              onPressed: () async {
                                try {
                                  context
                                      .read<OrdersBloc>()
                                      .add(CancelOrder(widget.orderItem.id));
                                } on HttpException catch (err) {
                                  showErrorDialog(context, err).then((_) {
                                    Navigator.of(context).pop();
                                  });
                                } catch (err) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(err.toString())));
                                } finally {
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                            TextButton(
                              child: Text('Cancel',
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
                        fontSize: getProportionateScreenWidth(15),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 5),
      color: kSecondaryColor,
    );
  }
}
