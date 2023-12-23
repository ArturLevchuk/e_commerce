import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants.dart';
import '../../../../repositories/models/product.dart';
import '../../../../widgets/alert_dialog_with_pic.dart';
import '../../../../widgets/default_button.dart';
import '../../../../widgets/rounded_icon_button.dart';
import '../../cart/cart_bloc/cart_bloc.dart';
import 'rounded_card.dart';

class ProductOptions extends StatefulWidget {
  const ProductOptions({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  State<ProductOptions> createState() => _ProductOptionsState();
}

class _ProductOptionsState extends State<ProductOptions> {
  int selectedColor = 0;
  int numOfItem = 1;

  @override
  Widget build(BuildContext context) {
    return TopRoundedContainer(
      // color: const Color(0xfff6f7f9),
      color: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          colorDots(),
          SizedBox(height: 10.w),
          TopRoundedContainer(
            color: Theme.of(context).colorScheme.surface,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: .15.sw),
              margin: const EdgeInsets.only(bottom: 20).r,
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
    return RPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
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
            width: 40.w,
            child: Text(
              "$numOfItem",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                // color: Colors.black,
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
        height: 40.w,
        width: 40.w,
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
