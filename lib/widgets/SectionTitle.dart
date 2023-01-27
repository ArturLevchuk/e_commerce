import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key? key,
    required this.text,
    required this.press,
    this.button_text = "See More",
  }) : super(key: key);

  final String text, button_text;
  final Function() press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
                fontSize: getProportionateScreenWidth(18), color: Colors.black),
          ),
          TextButton(
            onPressed: press,
            child: Text(
              button_text,
              style: const TextStyle(color: kTextColor),
            ),
          ),
        ],
      ),
    );
  }
}
