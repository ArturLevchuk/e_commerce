
import 'package:flutter/material.dart';

import '../size_config.dart';

class ProductColorCircleAvatar extends StatelessWidget {
  const ProductColorCircleAvatar({
    Key? key,
    required this.color,
  }) : super(key: key);
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getProportionateScreenWidth(12),
      height: getProportionateScreenWidth(12),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
    );
  }
}
