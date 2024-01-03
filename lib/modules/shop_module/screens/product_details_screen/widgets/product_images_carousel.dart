import '/apis/models/product.dart';
import '/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  int _selectedImage = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: .40.sh,
      child: LayoutBuilder(builder: (context, constraints) {
        return Column(
          children: [
            SizedBox(
              height: constraints.maxHeight * .70,
              child: PageView.builder(
                // scrollBehavior: CustomScrollBehavior(),
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                itemBuilder: (context, index) => FadeInImage.assetNetwork(
                  filterQuality: FilterQuality.high,
                  alignment: Alignment.center,
                  placeholder: "assets/images/box.png",
                  image: widget.product.images[index],
                ),
                itemCount: widget.product.images.length,
                onPageChanged: (value) {
                  setState(() {
                    _selectedImage = value;
                  });
                },
              ),
            ),
            const Spacer(),
            SizedBox(
              height: constraints.maxHeight * .20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.product.images.length,
                  (index) => buildSmallPreview(index),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget buildSmallPreview(int index) {
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: kAnimationDuration,
          curve: Curves.fastOutSlowIn,
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 46.w,
        width: 46.w,
        margin: const EdgeInsets.only(right: 10).r,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10).r,
          border: _selectedImage == index
              ? Border.all(color: Theme.of(context).colorScheme.primary)
              : null,
        ),
        padding: const EdgeInsets.all(8).r,
        child: FadeInImage.assetNetwork(
          alignment: Alignment.center,
          placeholder: "assets/images/box.png",
          image: widget.product.images[index],
        ),
      ),
    );
  }
}
