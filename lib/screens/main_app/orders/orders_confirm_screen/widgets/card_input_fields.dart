import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../size_config.dart';
import '../../../../../utils/card_utils.dart';

class CardInputFields extends StatefulWidget {
  const CardInputFields({
    super.key,
    required GlobalKey<FormState> formKey,
    required Function(String? newValue) updateCardNum,
    required Function(String? newValue) updateCardNameHolder,
    required Function(String? newValue) updateCVV,
    required Function(String? newValue) updateExpdate,
  })  : _formKey = formKey,
        _updateCardNum = updateCardNum,
        _updateCardNameHolder = updateCardNameHolder,
        _updateCVV = updateCVV,
        _updateExpdate = updateExpdate;

  final GlobalKey<FormState> _formKey;
  final Function(String? newValue) _updateCardNum;
  final Function(String? newValue) _updateCardNameHolder;
  final Function(String? newValue) _updateCVV;
  final Function(String? newValue) _updateExpdate;

  @override
  State<CardInputFields> createState() => _CardInputFieldsState();
}

class _CardInputFieldsState extends State<CardInputFields> {
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: widget._formKey,
        child: Column(
          children: [
            TextFormField(
              focusNode: _focusNode1,
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
              onSaved: widget._updateCardNum,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: getProportionateScreenWidth(16)),
              child: TextFormField(
                focusNode: _focusNode2,
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
                onSaved: widget._updateCardNameHolder,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    focusNode: _focusNode3,
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
                    onSaved: widget._updateCVV,
                  ),
                ),
                SizedBox(width: getProportionateScreenWidth(16)),
                Expanded(
                  child: TextFormField(
                    focusNode: _focusNode4,
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
                    onSaved: widget._updateExpdate,
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
