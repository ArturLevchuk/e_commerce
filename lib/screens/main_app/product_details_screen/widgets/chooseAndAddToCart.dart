import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants.dart';
import '../../../../repositories/models/product.dart';
import '../../../../size_config.dart';
import '../../../../widgets/AlertDialogTextWithPic.dart';
import '../../../../widgets/DefaultButton.dart';
import '../../../../widgets/RoundedIconBtn.dart';
import '../../cart/cart_bloc/cart_bloc.dart';
import 'topRoundedContainer.dart';

class ChooseAndAddToCart extends StatefulWidget {
  const ChooseAndAddToCart({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  State<ChooseAndAddToCart> createState() => _ChooseAndAddToCartState();
}

class _ChooseAndAddToCartState extends State<ChooseAndAddToCart> {
  int selectedColor = 0;
  int numOfItem = 1;

  @override
  Widget build(BuildContext context) {
    return TopRoundedContainer(
      color: const Color(0xfff6f7f9),
      child: Column(
        children: [
          colorDots(),
          SizedBox(height: getProportionateScreenWidth(10)),
          TopRoundedContainer(
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenWidth * .15),
              margin: EdgeInsets.only(bottom: getProportionateScreenWidth(20)),
              child: DefaultButton(
                isActive: widget.product.inStockCount > 0,
                text: widget.product.inStockCount > 0
                    ? "Add to cart"
                    : "Out of Stock",
                press: () async {
                  final bloc = context.read<CartBloc>().stream.first;
                  context.read<CartBloc>().add(AddToCart(
                        productId: widget.product.id,
                        numOfItem: numOfItem,
                        color: widget.product.colors.elementAt(selectedColor),
                      ));
                  await bloc.then((state) {
                    if (state.error != null) {
                      showDialog(
                        context: context,
                        builder: (_) => const AlertDialogTextWithPic(
                          text: "Something went wrong!",
                          svgSrc: "assets/icons/Close.svg",
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) => const AlertDialogTextWithPic(
                          text: "Product added to cart!",
                          svgSrc: "assets/icons/Check mark rounde.svg",
                        ),
                      );
                    }
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget colorDots() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
      ),
      child: Row(
        children: [
          ...List.generate(widget.product.colors.length,
              (index) => colorDot(widget.product.colors[index], index)),
          const Spacer(),
          RoundedIconBtn(
            icon: const Icon(Icons.add),
            press: () {
              if (numOfItem >= widget.product.inStockCount) {
                return;
              }
              setState(() {
                numOfItem++;
              });
            },
          ),
          SizedBox(
            width: getProportionateScreenWidth(40),
            child: Text(
              "$numOfItem",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: getProportionateScreenWidth(16),
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          RoundedIconBtn(
            icon: const Icon(Icons.remove),
            press: () {
              if (numOfItem > 1) {
                setState(() {
                  numOfItem--;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget colorDot(Color color, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: getProportionateScreenWidth(40),
        width: getProportionateScreenWidth(40),
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(right: 2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color:
                  selectedColor == index ? kPrimaryColor : Colors.transparent),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
