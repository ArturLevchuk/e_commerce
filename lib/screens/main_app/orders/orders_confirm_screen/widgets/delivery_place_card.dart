import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../repositories/models/user_information.dart';
import '../../../../../widgets/shadow_bloc.dart';

enum DeliveryPlaceType { defaultPlace, customPlace }

class DeliveryAdressCard extends StatefulWidget {
  const DeliveryAdressCard(
      {super.key,
      required this.updateAdress,
      required this.formKey,
      required this.userInformation});
  final Function(String adress) updateAdress;
  final GlobalKey<FormState> formKey;
  final UserInformation userInformation;

  @override
  State<DeliveryAdressCard> createState() => _DeliveryAdressCardState();
}

class _DeliveryAdressCardState extends State<DeliveryAdressCard> {
  DeliveryPlaceType _deliveryPlaceType = DeliveryPlaceType.defaultPlace;

  @override
  Widget build(BuildContext context) {
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
            subtitle: Text(widget.userInformation.adress),
            groupValue: _deliveryPlaceType,
            onChanged: (value) {
              setState(() {
                _deliveryPlaceType = value as DeliveryPlaceType;
              });
              widget.updateAdress(widget.userInformation.adress);
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20).r),
            activeColor: Theme.of(context).colorScheme.primary,
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
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20).r),
            activeColor: Theme.of(context).colorScheme.primary,
          ),
          if (_deliveryPlaceType == DeliveryPlaceType.customPlace)
            CustomArrivePlaceTextField(
              formKeyArrivePlace: widget.formKey,
              deliveryArrivePlaceUpdate: (newValue) {
                if (_deliveryPlaceType == DeliveryPlaceType.customPlace) {
                  widget.updateAdress(newValue!);
                } else {
                  widget.updateAdress(widget.userInformation.adress);
                }
              },
            ),
        ],
      ),
    );
  }
}

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
    return RPadding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Form(
        key: widget._formKeyArrivePlace,
        child: TextFormField(
          focusNode: _focusNode,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            enabledBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.onSurface),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.onSurface),
            ),
            errorBorder: const UnderlineInputBorder(),
            errorStyle: TextStyle(fontSize: 12.sp),
            border: const UnderlineInputBorder(),
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
