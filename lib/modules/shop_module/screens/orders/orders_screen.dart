// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import '/modules/authorization/screens/widgets/errors_show.dart';
import '/modules/core_modules/auth_module/vm/auth_controller.dart';
import '/modules/shop_module/core_buisness_logic/orders/vm/orders_controller.dart';
import '/widgets/loading_screen.dart';
import '/widgets/back_appbar_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/order_Item_card.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  static const routeName = '/OrdersScreen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late final OrdersController ordersController =
      context.read<OrdersController>();
  @override
  void didChangeDependencies() async {
    try {
      if (ordersController.state.ordersLoadStatus == OrdersLoadStatus.initial) {
        final AuthController authController = context.read<AuthController>();
        final userId = authController.state.id;
        final authToken = authController.state.token;
        await ordersController.fetchAndSetOrders(
            authToken: authToken, userId: userId);
      }
    } catch (err) {
      showErrorDialog(context: context, err: err.toString());
    }

    super.didChangeDependencies();
  }

  Future<void> _refresh() async {
    try {
      final AuthController authController = context.read<AuthController>();
      final userId = authController.state.id;
      final authToken = authController.state.token;
      await ordersController.fetchAndSetOrders(
        userId: userId,
        authToken: authToken,
      );
    } catch (err) {
      showErrorDialog(context: context, err: err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<OrdersState>(
      stream: ordersController.stream,
      builder: (context, snap) {
        if (ordersController.state.ordersLoadStatus ==
            OrdersLoadStatus.loaded) {
          final ordersList = ordersController.state.orders;
          return Scaffold(
            appBar: appBar(context),
            body: CustomRefreshIndicator(
              builder: MaterialIndicatorDelegate(
                backgroundColor: Theme.of(context).colorScheme.surface,
                builder: (context, controller) {
                  final indicator = controller.value.clamp(0.0, 1.0);
                  return Transform.rotate(
                    angle: 2 * pi * controller.value,
                    child: Icon(
                      Icons.refresh,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(indicator),
                    ),
                  );
                },
              ),
              onRefresh: () async {
                await _refresh();
              },
              child: ordersList.isEmpty
                  ? CustomScrollView(
                      slivers: [
                        SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Looks like no orders yet",
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                                AspectRatio(
                                  aspectRatio: 1,
                                  child: Image.asset(
                                      "assets/images/orders list.png"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      // physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return RPadding(
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: index == ordersList.length - 1 ? 20 : 0,
                          ),
                          child: OrderItemCard(
                            key: ValueKey(ordersList[index].id),
                            orderItem: ordersList[index],
                          ),
                        );
                      },
                      itemCount: ordersList.length,
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
    return AppBar(
      title: Text(
        'Orders',
        style: TextStyle(
          // color: Colors.black,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      leading: backAppBarButton(context),
      titleSpacing: 0,
    );
  }
}
