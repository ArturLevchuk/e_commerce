import 'package:e_commerce/constants.dart';
import 'package:e_commerce/repositories/auth_repository.dart';
import 'package:e_commerce/screens/main_app/orders/orders_bloc/orders_bloc.dart';
import 'package:e_commerce/screens/sign_in_up_screens/widgets/erros_show.dart';
import 'package:e_commerce/utils/HttpException.dart';
import 'package:e_commerce/widgets/DefaultButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repositories/models/user_information.dart';
import '../../../utils/card_utils.dart';
import '../../../size_config.dart';
import '../../../widgets/AlertDialogTextWithPic.dart';
import '../../../widgets/ShadowBloc.dart';
import '../../loading_screen.dart';
import '../cart/cart_bloc/cart_bloc.dart';

class OrdersConfirmScreen extends StatefulWidget {
  const OrdersConfirmScreen({super.key});
  static const routeName = '/OrdersConfirmScreen';

  @override
  State<OrdersConfirmScreen> createState() => _OrdersConfirmScreenState();
}

class _OrdersConfirmScreenState extends State<OrdersConfirmScreen> {
  late TextEditingController _customArrivePlaceController;

  @override
  void initState() {
    _customArrivePlaceController = TextEditingController();
    super.initState();
  }

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

  @override
  void dispose() {
    _customArrivePlaceController.dispose();
    super.dispose();
  }

  String deliveryArrivePlace = '';
  bool customArrivePlace = false;
  int paymentType = 1;
  final _formKeyArrivePlace = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  String cardNum = '', cvv = '', expdate = '', cardNameHolder = '';
  UserInformation? userInformation;
  bool orderingProcess = false;

  @override
  Widget build(BuildContext context) {
    final cartItemInf =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    return !isLoading
        ? Scaffold(
            appBar: customAppBar(context),
            body: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.75,
                        child: ListView(
                          padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(20),
                          ),
                          children: [
                            ShadowBloc(
                              containerHeight: customArrivePlace
                                  ? getProportionateScreenWidth(220)
                                  : getProportionateScreenWidth(165),
                              widget: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Text(
                                      "Delivery Adress",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                    RadioListTile(
                                      value: false,
                                      title: const Text("Standart Place"),
                                      subtitle: Text(userInformation!.adress),
                                      groupValue: customArrivePlace,
                                      onChanged: (value) {
                                        setState(() {
                                          customArrivePlace = value!;
                                        });
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      activeColor: kPrimaryColor,
                                    ),
                                    RadioListTile(
                                      value: true,
                                      title: const Text("Custom"),
                                      groupValue: customArrivePlace,
                                      onChanged: (value) {
                                        setState(() {
                                          customArrivePlace = value!;
                                        });
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      activeColor: kPrimaryColor,
                                    ),
                                    if (customArrivePlace)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20, bottom: 10),
                                        child: Form(
                                          key: _formKeyArrivePlace,
                                          child: TextFormField(
                                            controller:
                                                _customArrivePlaceController,
                                            decoration: const InputDecoration(
                                              contentPadding: EdgeInsets.zero,
                                              enabledBorder:
                                                  UnderlineInputBorder(),
                                              focusedBorder:
                                                  UnderlineInputBorder(),
                                              errorBorder:
                                                  UnderlineInputBorder(),
                                              hintText:
                                                  "Where do you want delivery?",
                                            ),
                                            validator: (value) {
                                              if (value == null) {
                                                return "Please enter destination place!";
                                              }
                                              if (value.length < 5) {
                                                return "Please enter destination place!";
                                              }
                                              return null;
                                            },
                                            onSaved: (newValue) {
                                              deliveryArrivePlace = newValue!;
                                            },
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            ShadowBloc(
                              containerHeight: paymentType == 1
                                  ? getProportionateScreenWidth(150)
                                  : getProportionateScreenWidth(395),
                              widget: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Text(
                                      "Payment method",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                    RadioListTile(
                                      value: 1,
                                      title: const Text("Payment upon receipt"),
                                      groupValue: paymentType,
                                      onChanged: (value) {
                                        setState(() {
                                          paymentType = 1;
                                        });
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
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
                                              BorderRadius.circular(20)),
                                      activeColor: kPrimaryColor,
                                    ),
                                    if (paymentType == 2) cardIput(),
                                  ],
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
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(20),
                            vertical: getProportionateScreenWidth(25)),
                        child: !orderingProcess
                            ? DefaultButton(
                                text: "Make order",
                                press: () async {
                                  setState(() {
                                    orderingProcess = true;
                                  });
                                  if (customArrivePlace) {
                                    if (_formKeyArrivePlace.currentState!
                                        .validate()) {
                                      _formKeyArrivePlace.currentState!.save();
                                    }
                                  } else {
                                    deliveryArrivePlace =
                                        userInformation!.adress;
                                  }
                                  String paymentInf = "Payment upon receipt";
                                  if (paymentType == 2) {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState?.save();
                                      paymentInf =
                                          "Card: $cardNum Cvv: $cvv ExpDate: $expdate CardNameHolder: $cardNameHolder";
                                    }
                                  }

                                  try {
                                    context.read<OrdersBloc>().add(AddOrder(
                                          cartProducts:
                                              cartItemInf["cartItems"],
                                          totalPrice: cartItemInf["totalPrice"],
                                          arrivePlace: deliveryArrivePlace,
                                          payment: paymentInf,
                                        ));
                                    final bloc =
                                        context.read<OrdersBloc>().stream.first;
                                    context.read<CartBloc>().add(ClearCart());
                                    await bloc.then((state) {
                                      if (state.error != null) {
                                        throw state.error!;
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (_) =>
                                              const AlertDialogTextWithPic(
                                            text: "Order is processed!",
                                            svgSrc:
                                                "assets/icons/Check mark rounde.svg",
                                          ),
                                        ).then((_) {
                                          Navigator.of(context).pop();
                                        });
                                      }
                                    });
                                  } catch (err) {
                                    showDialog(
                                      context: context,
                                      builder: (_) =>
                                          const AlertDialogTextWithPic(
                                        text: "Something went wrong!",
                                        svgSrc: "assets/icons/Close.svg",
                                      ),
                                    );
                                  }
                                  setState(() {
                                    orderingProcess = false;
                                  });
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
              ),
            ))
        : const LoadingScreen();
  }

  AppBar customAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          splashRadius: getProportionateScreenWidth(25),
          onPressed: () {
            Navigator.of(context).pop();
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

  InputDecoration get cardInputDecoration {
    const OutlineInputBorder defaultOutlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(12)),
    );
    return const InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      filled: true,
      fillColor: Color(0xFFF8F8F9),
      hintStyle: TextStyle(
        color: Color(0xFFB8B5C3),
      ),
      border: defaultOutlineInputBorder,
      enabledBorder: defaultOutlineInputBorder,
      focusedBorder: defaultOutlineInputBorder,
    );
  }

  Widget cardIput() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16),
                CardNumberInputFormatter(),
              ],
              decoration: cardInputDecoration.copyWith(hintText: 'Card number'),
              validator: (value) {
                return CardUtils.validateCardNum(value);
              },
              onSaved: (newValue) {
                cardNum = newValue!;
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: getProportionateScreenWidth(16)),
              child: TextFormField(
                decoration: cardInputDecoration.copyWith(
                  hintText: "Full name",
                ),
                validator: (value) {
                  if (value == null) {
                    return "Enter Full name";
                  } else if (value.length < 3) {
                    return "Full name too short";
                  }
                  return null;
                },
                onSaved: (newValue) {
                  cardNameHolder = newValue!;
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    decoration: cardInputDecoration.copyWith(
                      hintText: "CVV",
                    ),
                    validator: (value) {
                      return CardUtils.validateCVV(value);
                    },
                    onSaved: (newValue) {
                      cvv = newValue!;
                    },
                  ),
                ),
                SizedBox(width: getProportionateScreenWidth(16)),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                      CardMonthInputFormatter(),
                    ],
                    decoration: cardInputDecoration.copyWith(
                      hintText: "MM/YY",
                    ),
                    validator: (value) {
                      return CardUtils.validateDate(value);
                    },
                    onSaved: (newValue) {
                      expdate = newValue!;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
