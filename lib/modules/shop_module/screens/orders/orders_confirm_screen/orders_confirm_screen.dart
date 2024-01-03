// ignore_for_file: use_build_context_synchronously

import '/apis/models/user_information.dart';
import '/modules/authorization/screens/widgets/errors_show.dart';
import '/modules/core_modules/auth_module/vm/auth_controller.dart';
import '/modules/core_modules/user_settings_module/vm/user_settings_controller.dart';
import '/modules/shop_module/core_buisness_logic/cart/vm/cart_controller.dart';
import '/modules/shop_module/core_buisness_logic/orders/vm/orders_controller.dart';
import '/modules/shop_module/screens/orders/orders_confirm_screen/widgets/exit_dialog.dart';
import '/widgets/alert_dialog_with_pic.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '/widgets/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/delivery_place_card.dart';
import 'widgets/payment_input_card.dart';

class OrderPreparationScreen extends StatefulWidget {
  const OrderPreparationScreen({super.key, required this.cartItemInf});
  static const routeName = '/OrderPreparationScreen';
  final Map<String, dynamic> cartItemInf;

  @override
  State<OrderPreparationScreen> createState() => _OrderPreparationScreenState();
}

class _OrderPreparationScreenState extends State<OrderPreparationScreen> {
  final _formKeyDeliveryPlace = GlobalKey<FormState>();
  final _formKeyCard = GlobalKey<FormState>();

  String deliveryArrivePlace = '';
  String paymentInfo = 'Payment upon receipt';

  late final UserInformation userInformation;
  bool orderingProcess = false;

  @override
  void didChangeDependencies() async {
    try {
      final UserSettingsController userSettingsController =
          context.read<UserSettingsController>();
      userInformation = userSettingsController.state.userInformation;
      deliveryArrivePlace = userInformation.adress;
    } catch (err) {
      showErrorDialog(context: context, err: err.toString());
    }
    super.didChangeDependencies();
  }

  Future<void> makeOrder() async {
    bool error = false;
    if (_formKeyDeliveryPlace.currentState != null) {
      if (_formKeyDeliveryPlace.currentState!.validate()) {
        _formKeyDeliveryPlace.currentState!.save();
      } else {
        error = true;
      }
    }
    if (_formKeyCard.currentState != null) {
      if (_formKeyCard.currentState!.validate()) {
        _formKeyCard.currentState?.save();
      } else {
        error = true;
      }
    }
    if (error) {
      return;
    }
    setState(() {
      orderingProcess = true;
    });
    try {
      final authController = context.read<AuthController>();
      final userId = authController.state.id;
      final authToken = authController.state.token;
      await context.read<OrdersController>().addOrder(
            cartProducts: widget.cartItemInf["cartItems"],
            totalPrice: widget.cartItemInf["totalPrice"],
            arrivePlace: deliveryArrivePlace,
            payment: paymentInfo,
            userId: userId,
            authToken: authToken,
          );
      await context.read<CartController>().clearCart(
            userId: userId,
            authToken: authToken,
          );
      showDialog(
        context: context,
        builder: (_) => const AlertDialogTextWithPic(
          text: "Order is processed!",
          svgSrc: "assets/icons/Check mark rounde.svg",
        ),
      ).then((_) {
        Modular.to.pop();
      });
    } catch (err) {
      showErrorDialog(
        context: context,
        err: err.toString(),
      );
    } finally {
      setState(() {
        orderingProcess = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showExitDialog(context).then((value) {
          if (value == null) {
            return false;
          } else {
            return value;
          }
        });
      },
      child: Scaffold(
        appBar: appBar(context),
        body: SingleChildScrollView(
          child: RPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                DeliveryAdressCard(
                    userInformationAdress: userInformation.adress,
                    updateAdress: (adress) {
                      setState(() {
                        deliveryArrivePlace = adress;
                      });
                    },
                    formKey: _formKeyDeliveryPlace),
                PaymentCard(
                  updatePaymentInfo: (paymentInfo) {
                    setState(() {
                      paymentInfo = paymentInfo;
                    });
                  },
                  formKey: _formKeyCard,
                ),
                SizedBox(
                  height: 20.w,
                )
                // const Spacer(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: RPadding(
          padding: const EdgeInsets.all(20),
          child: !orderingProcess
              ? DefaultButton(
                  text: "Make order",
                  press: () async {
                    await makeOrder();
                  })
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    )
                  ],
                ),
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          splashRadius: 25.w,
          onPressed: () async {
            await showExitDialog(context).then((exitConfrim) {
              if (exitConfrim == null || !exitConfrim) {
                return;
              } else if (exitConfrim) {
                Modular.to.pop();
              }
            });
          }),
      title: Text(
        'Orders Confirm',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 18.sp,
        ),
      ),
      titleSpacing: 0,
    );
  }
}
