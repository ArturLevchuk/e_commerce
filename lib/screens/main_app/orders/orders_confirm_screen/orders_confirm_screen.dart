import 'package:e_commerce/constants.dart';
import 'package:e_commerce/repositories/auth_repository.dart';
import 'package:e_commerce/screens/main_app/orders/orders_bloc/orders_bloc.dart';
import 'package:e_commerce/screens/main_app/orders/orders_confirm_screen/widgets/exit_dialog.dart';
import 'package:e_commerce/screens/sign_in_up_screens/widgets/erros_show.dart';
import 'package:e_commerce/utils/CustomScrollBehavior.dart';
import 'package:e_commerce/utils/HttpException.dart';
import 'package:e_commerce/widgets/DefaultButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../repositories/models/card_information.dart';
import '../../../../repositories/models/user_information.dart';
import '../../../../size_config.dart';
import '../../../../widgets/AlertDialogTextWithPic.dart';
import '../../../../widgets/ShadowBloc.dart';
import '../../../loading_screen.dart';
import '../../cart/cart_bloc/cart_bloc.dart';
import 'widgets/CustomArrivePlaceTextField.dart';
import 'widgets/card_input_fields.dart';

enum PaymentType { card, cash }

enum DeliveryPlaceType { defaultPlace, customPlace }

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

  PaymentType _paymentType = PaymentType.cash;
  DeliveryPlaceType _deliveryPlaceType = DeliveryPlaceType.defaultPlace;

  String deliveryArrivePlace = '';
  // bool customArrivePlace = false;
  // bool customArrivePlaceHasError = false;

  CardInformation? cardInformation;
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

  Future<void> tryToMakeOrder() async {
    bool error = false;
    if (_deliveryPlaceType == DeliveryPlaceType.customPlace) {
      if (_formKeyDeliveryPlace.currentState!.validate()) {
        _formKeyDeliveryPlace.currentState!.save();
      } else {
        error = true;
      }
    }
    String paymentInf = "Payment upon receipt";
    if (_paymentType == PaymentType.card) {
      if (_formKeyCard.currentState!.validate()) {
        _formKeyCard.currentState?.save();
        paymentInf =
            "Card: ${cardInformation?.cardNumber} Cvv: ${cardInformation?.cvvCode} ExpDate: ${cardInformation?.expdate} CardNameHolder: ${cardInformation?.cardNameHolder}";
      } else {
        error = true;
      }
    }
    if (error) return;

    // if (customArrivePlace) {
    //   if (_formKeyDeliveryPlace.currentState!.validate()) {
    //     _formKeyDeliveryPlace.currentState!.save();
    //     setState(() {
    //       customArrivePlaceHasError = false;
    //     });
    //   } else {
    //     setState(() {
    //       customArrivePlaceHasError = true;
    //     });
    //     error = true;
    //   }
    // } else {
    //   deliveryArrivePlace = userInformation!.adress;
    // }
    // String paymentInf = "Payment upon receipt";
    // if (paymentType == 2) {
    //   if (_formKeyCard.currentState!.validate()) {
    //     _formKeyCard.currentState?.save();
    //     paymentInf =
    //         "Card: ${cardInformation?.cardNumber} Cvv: ${cardInformation?.cvvCode} ExpDate: ${cardInformation?.expdate} CardNameHolder: ${cardInformation?.cardNameHolder}";
    //   } else {
    //     error = true;
    //   }
    // }
    // if (error) return;

    setState(() {
      orderingProcess = true;
    });
    try {
      context.read<OrdersBloc>().add(AddOrder(
            cartProducts: cartItemInf["cartItems"],
            totalPrice: cartItemInf["totalPrice"],
            arrivePlace: deliveryArrivePlace,
            payment: paymentInf,
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
        ? GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: WillPopScope(
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
                appBar: customAppBar(context),
                body: ScrollConfiguration(
                  behavior: CustomScrollBehavior(),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(20)),
                      child: Column(
                        children: [
                          deliveryAdressCard(context),
                          paymentMethodCard(context),
                          SizedBox(
                            height: getProportionateScreenWidth(20),
                          )
                          // const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
                bottomNavigationBar: Padding(
                  padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                  child: !orderingProcess
                      ? DefaultButton(
                          text: "Make order",
                          press: () async {
                            await tryToMakeOrder();
                          })
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                              CircularProgressIndicator(color: kPrimaryColor)
                            ]),
                ),
              ),
            ),
          )
        : const LoadingScreen();
  }

  ShadowBloc paymentMethodCard(BuildContext context) {
    return ShadowBloc(
      widget: Column(
        children: [
          Text(
            "Payment method",
            style: Theme.of(context).textTheme.headline6,
          ),
          RadioListTile(
            value: PaymentType.cash,
            title: const Text("Payment upon receipt"),
            groupValue: _paymentType,
            onChanged: (value) {
              setState(() {
                _paymentType = value as PaymentType;
              });
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            activeColor: kPrimaryColor,
          ),
          RadioListTile(
            value: PaymentType.card,
            title: const Text("By Card"),
            groupValue: _paymentType,
            onChanged: (value) {
              setState(() {
                _paymentType = value as PaymentType;
              });
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            activeColor: kPrimaryColor,
          ),
          if (_paymentType == PaymentType.card)
            CardInputFields(
              formKey: _formKeyCard,
              updateCardNum: (newValue) {
                cardInformation?.cardNumber = newValue;
              },
              updateCardNameHolder: (newValue) {
                cardInformation?.cardNameHolder = newValue;
              },
              updateExpdate: (newValue) {
                cardInformation?.expdate = newValue;
              },
              updateCVV: (newValue) {
                cardInformation?.cvvCode = newValue;
              },
            ),
        ],
      ),
    );
  }

  ShadowBloc deliveryAdressCard(BuildContext context) {
    return ShadowBloc(
      widget: Column(
        children: [
          Text(
            "Delivery Adress",
            style: Theme.of(context).textTheme.headline6,
          ),
          RadioListTile(
            value: DeliveryPlaceType.defaultPlace,
            title: const Text("Standart Place"),
            subtitle: Text(userInformation!.adress),
            groupValue: _deliveryPlaceType,
            onChanged: (value) {
              setState(() {
                _deliveryPlaceType = value as DeliveryPlaceType;
              });
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            activeColor: kPrimaryColor,
          ),
          RadioListTile(
            value: DeliveryPlaceType.customPlace,
            title: const Text("Custom"),
            groupValue: _deliveryPlaceType,
            onChanged: (value) {
              setState(() {
                _deliveryPlaceType = value as DeliveryPlaceType;
              });
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            activeColor: kPrimaryColor,
          ),
          if (_deliveryPlaceType == DeliveryPlaceType.customPlace)
            CustomArrivePlaceTextField(
              formKeyArrivePlace: _formKeyDeliveryPlace,
              deliveryArrivePlaceUpdate: (newValue) {
                deliveryArrivePlace = newValue!;
              },
            ),
        ],
      ),
    );
  }

  AppBar customAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          splashRadius: getProportionateScreenWidth(25),
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
          color: Colors.black,
          fontSize: getProportionateScreenWidth(18),
        ),
      ),
      titleSpacing: 0,
    );
  }
}
