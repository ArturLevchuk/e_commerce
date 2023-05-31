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

class OrdersConfirmScreen extends StatefulWidget {
  const OrdersConfirmScreen({super.key});
  static const routeName = '/OrdersConfirmScreen';

  @override
  State<OrdersConfirmScreen> createState() => _OrdersConfirmScreenState();
}

class _OrdersConfirmScreenState extends State<OrdersConfirmScreen> {
  late final Map<String, dynamic> cartItemInf =
      ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
  String deliveryArrivePlace = '';
  bool customArrivePlace = false;
  bool customArrivePlaceHasError = false;
  int paymentType = 1;
  final _formKeyArrivePlace = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  CardInformation? cardInformation;
  UserInformation? userInformation;
  bool orderingProcess = false;
  bool isLoading = false;

  bool _hasFocus = false;
  List<FocusNode> _focusNodes = [];

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
    if (customArrivePlace) {
      if (_formKeyArrivePlace.currentState!.validate()) {
        _formKeyArrivePlace.currentState!.save();
        setState(() {
          customArrivePlaceHasError = false;
        });
      } else {
        setState(() {
          customArrivePlaceHasError = true;
        });
        error = true;
      }
    } else {
      deliveryArrivePlace = userInformation!.adress;
    }
    String paymentInf = "Payment upon receipt";
    if (paymentType == 2) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState?.save();
        paymentInf =
            "Card: ${cardInformation?.cardNumber} Cvv: ${cardInformation?.cvvCode} ExpDate: ${cardInformation?.expdate} CardNameHolder: ${cardInformation?.cardNameHolder}";
      } else {
        error = true;
      }
    }
    if (error) return;

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

  void _getFocusNodes() {
    final focusScope = FocusScope.of(context);
    _focusNodes = focusScope.descendants.whereType<FocusNode>().toList();
    for (var focusNode in _focusNodes) {
      focusNode.addListener(() {
        setState(() {
          _hasFocus = focusNode.hasFocus;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? FutureBuilder(
            future: Future.delayed(Duration.zero, () {
              _getFocusNodes();
            }),
            builder: (context, snapshot) {
              return GestureDetector(
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
                          physics: _hasFocus
                              ? const AlwaysScrollableScrollPhysics()
                              : const NeverScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              SizedBox(
                                height: SizeConfig.screenHeight * 0.75,
                                child: ListView(
                                  // physics: const BouncingScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: getProportionateScreenWidth(20),
                                  ),
                                  children: [
                                    ShadowBloc(
                                      widget: ScrollConfiguration(
                                        behavior: CustomScrollBehavior(),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Text(
                                                "Delivery Adress",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6,
                                              ),
                                              RadioListTile(
                                                value: false,
                                                title: const Text(
                                                    "Standart Place"),
                                                subtitle: Text(
                                                    userInformation!.adress),
                                                groupValue: customArrivePlace,
                                                onChanged: (value) {
                                                  setState(() {
                                                    customArrivePlace = value!;
                                                  });
                                                },
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                activeColor: kPrimaryColor,
                                              ),
                                              RadioListTile(
                                                value: true,
                                                title: const Text("Custom"),
                                                groupValue: customArrivePlace,
                                                onChanged: (value) {
                                                  setState(() {
                                                    customArrivePlace = value!;
                                                    customArrivePlaceHasError =
                                                        false;
                                                  });
                                                },
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                activeColor: kPrimaryColor,
                                              ),
                                              if (customArrivePlace)
                                                CustomArrivePlaceTextField(
                                                  formKeyArrivePlace:
                                                      _formKeyArrivePlace,
                                                  deliveryArrivePlaceUpdate:
                                                      (newValue) {
                                                    deliveryArrivePlace =
                                                        newValue!;
                                                  },
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    ShadowBloc(
                                      widget: ScrollConfiguration(
                                        behavior: CustomScrollBehavior(),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Text(
                                                "Payment method",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6,
                                              ),
                                              RadioListTile(
                                                value: 1,
                                                title: const Text(
                                                    "Payment upon receipt"),
                                                groupValue: paymentType,
                                                onChanged: (value) {
                                                  setState(() {
                                                    paymentType = 1;
                                                  });
                                                },
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                activeColor: kPrimaryColor,
                                              ),
                                              RadioListTile(
                                                value: 2,
                                                title: const Text("By Card"),
                                                groupValue: paymentType,
                                                onChanged: (value) {
                                                  setState(() {
                                                    paymentType = 2;
                                                  });
                                                },
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                activeColor: kPrimaryColor,
                                              ),
                                              if (paymentType == 2)
                                                CardInputFields(
                                                  formKey: _formKey,
                                                  updateCardNum: (newValue) {
                                                    cardInformation
                                                        ?.cardNumber = newValue;
                                                  },
                                                  updateCardNameHolder:
                                                      (newValue) {
                                                    cardInformation
                                                            ?.cardNameHolder =
                                                        newValue;
                                                  },
                                                  updateExpdate: (newValue) {
                                                    cardInformation?.expdate =
                                                        newValue;
                                                  },
                                                  updateCVV: (newValue) {
                                                    cardInformation?.cvvCode =
                                                        newValue;
                                                  },
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenWidth(10),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: SizeConfig.screenHeight * 0.15,
                                // color: Colors.pink,
                                padding: EdgeInsets.symmetric(
                                    horizontal: getProportionateScreenWidth(20),
                                    vertical: getProportionateScreenWidth(26)),
                                child: !orderingProcess
                                    ? DefaultButton(
                                        text: "Make order",
                                        press: () async {
                                          await tryToMakeOrder();
                                        })
                                    : const Align(
                                        alignment: Alignment.center,
                                        child: CircularProgressIndicator(
                                            color: kPrimaryColor),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
              );
            })
        : const LoadingScreen();
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
