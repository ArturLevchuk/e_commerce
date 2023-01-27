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
            body: ordersProvItems.isEmpty
                ? Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text(
                        "Looks like no orders yet",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      SizedBox(
                        width: SizeConfig.screenWidth * .8,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.asset("assets/images/orders list.jpg"),
                        ),
                      ),
                    ]),
                  )
                : ListView.builder(
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
          );
        } else {
          return const LoadingScreen();
        }
      },
    );
  }
}
