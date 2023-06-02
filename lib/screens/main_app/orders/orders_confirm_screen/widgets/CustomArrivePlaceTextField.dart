import 'package:flutter/material.dart';

class CustomArrivePlaceTextField extends StatefulWidget {
  const CustomArrivePlaceTextField({
    super.key,
    required GlobalKey<FormState> formKeyArrivePlace,
    required Function(String? newValue) deliveryArrivePlaceUpdate,
  })  : _formKeyArrivePlace = formKeyArrivePlace,
        _deliveryArrivePlaceUpdate = deliveryArrivePlaceUpdate;

  final GlobalKey<FormState> _formKeyArrivePlace;
  final Function(String? newValue) _deliveryArrivePlaceUpdate;

  @override
  State<CustomArrivePlaceTextField> createState() =>
      _CustomArrivePlaceTextFieldState();
}

class _CustomArrivePlaceTextFieldState
    extends State<CustomArrivePlaceTextField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Form(
        key: widget._formKeyArrivePlace,
        child: TextFormField(
          focusNode: _focusNode,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.zero,
            enabledBorder: UnderlineInputBorder(),
            focusedBorder: UnderlineInputBorder(),
            errorBorder: UnderlineInputBorder(),
            border: UnderlineInputBorder(),
            hintText: "Where do you want delivery?",
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
          onSaved: widget._deliveryArrivePlaceUpdate,
        ),
      ),
    );
  }
}
