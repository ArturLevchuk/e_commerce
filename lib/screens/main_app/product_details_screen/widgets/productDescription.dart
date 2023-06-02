import 'package:flutter/material.dart';
import '../../../../constants.dart';
import '../../../../repositories/models/product.dart';
import '../../../../size_config.dart';

class ProductDescription extends StatefulWidget {
  const ProductDescription({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  int _textMaxLines = 5;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          alignment: Alignment.topCenter,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(20),
            ),
            child: Text(
              widget.product.description,
              maxLines: _textMaxLines,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: 10,
          ),
          child: GestureDetector(
            onTap: () {
              if (_textMaxLines == 5) {
                setState(() {
                  _textMaxLines = 1000;
                });
              } else {
                setState(() {
                  _textMaxLines = 5;
                });
              }
            },
            child: Row(
              children: [
                Text(
                  _textMaxLines == 5 ? "See More Details" : "See Less Details",
                  style: const TextStyle(
                      color: kPrimaryColor, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 5),
                Icon(
                  _textMaxLines == 5
                      ? Icons.arrow_forward_ios
                      : Icons.arrow_back_ios,
                  size: 12,
                  color: kPrimaryColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
