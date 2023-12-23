import 'dart:math';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:e_commerce/constants.dart';
import 'package:e_commerce/screens/main_app/orders/orders_bloc/orders_bloc.dart';
import 'package:e_commerce/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../widgets/back_appbar_button.dart';
import '../../loading_screen.dart';
import 'widgets/order_Item_card.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  static const routeName = '/OrdersScreen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void didChangeDependencies() async {
    if (context.read<OrdersBloc>().state.ordersLoadStatus ==
        OrdersLoadStatus.initial) {
      context.read<OrdersBloc>().add(RequestOrders());
    }
    super.didChangeDependencies();
  }

  Future<void> _refresh() async {
    final bloc = context.read<OrdersBloc>().stream.firstWhere(
        (state) => state.ordersLoadStatus == OrdersLoadStatus.loaded);
    context.read<OrdersBloc>().add(RequestOrders());
    await bloc;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        if (state.ordersLoadStatus == OrdersLoadStatus.loaded) {
          final ordersProvItems = state.orders;
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
              child: ordersProvItems.isEmpty
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
                            bottom:
                                index == ordersProvItems.length - 1 ? 20 : 0,
                          ),
                          child: OrderItemCard(
                            orderItem: ordersProvItems[index],
                          ),
                        );
                      },
                      itemCount: ordersProvItems.length,
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
