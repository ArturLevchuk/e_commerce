import '/repositories/auth_repository.dart';
import '/screens/main_app/orders/orders_bloc/orders_bloc.dart';
import '/screens/main_app/orders/orders_confirm_screen/widgets/exit_dialog.dart';
import '/screens/auth_module/widgets/errors_show.dart';
import '/utils/HttpException.dart';
import '/widgets/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../repositories/models/user_information.dart';
import '../../../../widgets/alert_dialog_with_pic.dart';
import '../../../loading_screen.dart';
import '../../cart/cart_bloc/cart_bloc.dart';
import 'widgets/delivery_place_card.dart';
import 'widgets/payment_input_card.dart';

class OrdersConfirmScreen extends StatefulWidget {
  const OrdersConfirmScreen({super.key});
  static const routeName = '/OrdersConfirmScreen';

  @override
  State<OrdersConfirmScreen> createState() => _OrdersConfirmScreenState();
}

class _OrdersConfirmScreenState extends State<OrdersConfirmScreen> {
  late final Map<String, dynamic> cartItemInf =
      ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
  final _formKeyDeliveryPlace = GlobalKey<FormState>();
  final _formKeyCard = GlobalKey<FormState>();

  String deliveryArrivePlace = '';
  String paymentInfo = 'Payment upon receipt';

  UserInformation? userInformation;
  bool orderingProcess = false;
  bool isLoading = false;

  @override
  void didChangeDependencies() async {
    if (userInformation == null) {
      setState(() {
        isLoading = true;
      });
      try {
        userInformation =
            await context.read<AuthRepositiry>().getUserInformation();
        deliveryArrivePlace = userInformation!.adress;
        setState(() {
          isLoading = false;
        });
      } on HttpException catch (err) {
        showErrorDialog(context, err.toString()).then((_) {
          Navigator.of(context).pop();
        });
      } catch (err) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(err.toString())));
      }
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
      context.read<OrdersBloc>().add(AddOrder(
            cartProducts: cartItemInf["cartItems"],
            totalPrice: cartItemInf["totalPrice"],
            arrivePlace: deliveryArrivePlace,
            payment: paymentInfo,
          ));
      final bloc = context.read<OrdersBloc>().stream.first;
      context.read<CartBloc>().add(ClearCart());
      await bloc.then((state) {
        if (state.error != null) {
          throw state.error!;
        } else {
          showDialog(
            context: context,
            builder: (_) => const AlertDialogTextWithPic(
              text: "Order is processed!",
              svgSrc: "assets/icons/Check mark rounde.svg",
            ),
          ).then((_) {
            Navigator.of(context).pop();
          });
        }
      });
    } catch (err) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (_) => const AlertDialogTextWithPic(
          text: "Something went wrong!",
          svgSrc: "assets/icons/Close.svg",
        ),
      );
    }
    setState(() {
      orderingProcess = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? WillPopScope(
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
                          userInformation: userInformation!,
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
          )
        : const LoadingScreen();
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
                Navigator.of(context).pop();
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


