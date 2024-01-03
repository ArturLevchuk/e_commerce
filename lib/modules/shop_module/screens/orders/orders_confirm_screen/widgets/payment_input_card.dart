import '/utils/card_utils.dart';
import '/widgets/shadow_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum PaymentType { card, cash }

class PaymentCard extends StatefulWidget {
  const PaymentCard(
      {super.key, required this.updatePaymentInfo, required this.formKey});
  final GlobalKey<FormState> formKey;
  final Function(String paymentInfo) updatePaymentInfo;

  @override
  State<PaymentCard> createState() => _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard> {
  PaymentType _paymentType = PaymentType.cash;

  @override
  Widget build(BuildContext context) {
    return ShadowBloc(
      widget: Column(
        children: [
          Text(
            "Payment method",
            style: Theme.of(context).textTheme.headline6,
          ),
          RadioListTile<PaymentType>(
            value: PaymentType.cash,
            title: const Text("Payment upon receipt"),
            groupValue: _paymentType,
            onChanged: (value) {
              setState(() {
                _paymentType = value!;
              });
              widget.updatePaymentInfo("Payment upon receipt");
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20).r),
            activeColor: Theme.of(context).colorScheme.primary,
          ),
          RadioListTile<PaymentType>(
            value: PaymentType.card,
            title: const Text("By Card"),
            groupValue: _paymentType,
            onChanged: (value) {
              setState(() {
                _paymentType = value!;
              });
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20).r),
            activeColor: Theme.of(context).colorScheme.primary,
          ),
          if (_paymentType == PaymentType.card)
            CardInputFields(
              formKey: widget.formKey,
              updateCardInfo: (newValue) {
                widget.updatePaymentInfo(newValue);
              },
            ),
        ],
      ),
    );
  }
}

class CardInputFields extends StatefulWidget {
  const CardInputFields({
    super.key,
    required this.formKey,
    required this.updateCardInfo,
  });

  final GlobalKey<FormState> formKey;
  final Function(String newValue) updateCardInfo;

  @override
  State<CardInputFields> createState() => _CardInputFieldsState();
}

class _CardInputFieldsState extends State<CardInputFields> {
  String cardNum = '';
  String cardNameHolder = '';
  String cardCvvCode = '';
  String expDate = '';

  @override
  Widget build(BuildContext context) {
    return RPadding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: widget.formKey,
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
              // onSaved: widget._updateCardNum,
              onChanged: (value) {
                setState(() {
                  cardNum = value;
                });
              },
            ),
            RPadding(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
              ),
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
                onChanged: (value) {
                  setState(() {
                    cardNameHolder = value;
                  });
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
                    onChanged: (value) {
                      setState(() {
                        cardCvvCode = value;
                      });
                    },
                  ),
                ),
                SizedBox(width: 16.w),
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
                    onChanged: (value) {
                      setState(() {
                        expDate = value;
                      });
                    },
                    onSaved: (_) {
                      widget.updateCardInfo(
                          '$cardNum $cardNameHolder $expDate $cardCvvCode');
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

  InputDecoration get cardInputDecoration {
    OutlineInputBorder defaultOutlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: const BorderRadius.all(Radius.circular(12)).r,
    );
    return InputDecoration(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 20).r,
      filled: true,
      fillColor: Theme.of(context).colorScheme.background.withOpacity(.6),
      hintStyle: TextStyle(color: Theme.of(context).colorScheme.onBackground),
      border: defaultOutlineInputBorder,
      enabledBorder: defaultOutlineInputBorder,
      focusedBorder: defaultOutlineInputBorder,
    );
  }
}
