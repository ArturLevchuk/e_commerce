import 'dart:math';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:e_commerce/constants.dart';
import 'package:e_commerce/screens/main_app/orders/orders_bloc/orders_bloc.dart';
import 'package:e_commerce/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../loading_screen.dart';
import 'widgets/orderItemCard.dart';

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
            appBar: AppBar(
              title: Text(
                'Orders',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: getProportionateScreenWidth(18),
                ),
              ),
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  splashRadius: getProportionateScreenWidth(25),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              titleSpacing: 0,
            ),
            body: CustomRefreshIndicator(
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
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                  SizedBox(
                                    width: SizeConfig.screenWidth * .8,
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: Image.asset(
                                          "assets/images/orders list.jpg"),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      // physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(20),
                          ),
                          child: Column(
                            children: [
                              OrderItemCard(
                                orderItem: ordersProvItems[index],
                              ),
                              if (index == ordersProvItems.length - 1)
                                SizedBox(
                                  height: getProportionateScreenWidth(20),
                                ),
                            ],
                          ),
                        );
                      },
                      itemCount: ordersProvItems.length),
            ),
          );
        } else {
          return const LoadingScreen();
        }
      },
    );
  }
}
