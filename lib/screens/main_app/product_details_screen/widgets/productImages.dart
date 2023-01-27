import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../../repositories/models/product.dart';
import '../../../../size_config.dart';

class ProductImages extends StatefulWidget {
  const ProductImages({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  State<ProductImages> createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  int selectedImage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: getProportionateScreenWidth(238),
          child: AspectRatio(
            aspectRatio: 1,
            child: FadeInImage.assetNetwork(
              alignment: Alignment.center,
              placeholder: "assets/images/box.png",
              image: widget.product.images[selectedImage],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.product.images.length,
              (index) => buildSmallPreview(index)),
        ),
      ],
    );
  }

  Widget buildSmallPreview(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: getProportionateScreenWidth(48),
        width: getProportionateScreenWidth(48),
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border:
              selectedImage == index ? Border.all(color: kPrimaryColor) : null,
        ),
        padding: EdgeInsets.all(getProportionateScreenWidth(8)),
        child: FadeInImage.assetNetwork(
          alignment: Alignment.center,
          placeholder: "assets/images/box.png",
          image: widget.product.images[index],
        ),
      ),
    );
  }
}
