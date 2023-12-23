import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants.dart';
import '../../../../size_config.dart';
import '../../../../widgets/default_button.dart';
import '../../../../widgets/section_title.dart';
import '../../home/products_bloc/products_bloc.dart';
import '../products_order_settings_bloc/products_order_settings_bloc.dart';

class FilterDrawer extends StatefulWidget {
  const FilterDrawer({
    super.key,
  });

  @override
  State<FilterDrawer> createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  late final List<Color> filterColors;
  late final Set<Color> avaliableColors;

  @override
  void initState() {
    final listOfListOfColors = context
        .read<ProductsBloc>()
        .state
        .items
        .map((product) => product.colors)
        .toList();
    avaliableColors = listOfListOfColors.expand((list) => list).toSet();
    filterColors =
        List.of(context.read<ProductsOrderSettingsBloc>().state.filterColors);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        // backgroundColor: const Color(0xfff5f6f9),
        backgroundColor: Theme.of(context).colorScheme.background,
        child: Column(
          children: [
            RPadding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Filter products by...',
                style: TextStyle(
                  fontSize: 17.sp,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SectionTitle(
                    text: "Colors",
                    buttonText: "Clear selected",
                    press: () {
                      setState(() {
                        filterColors.clear();
                      });
                    },
                  ),
                  RPadding(
                    // width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Wrap(
                      spacing: 10.w,
                      runSpacing: 10.w,
                      children: [
                        ...avaliableColors.map(
                          (color) => ColorChooseBlock(
                            color: color,
                            checked: filterColors.contains(color),
                            press: () {
                              if (!filterColors.contains(color)) {
                                setState(() {
                                  filterColors.add(color);
                                });
                              } else {
                                setState(() {
                                  filterColors.remove(color);
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            RPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 15,
              ),
              child: DefaultButton(
                text: "Apply",
                press: () {
                  context.read<ProductsOrderSettingsBloc>().add(
                        UpdateFiltering(filterColors: filterColors),
                      );
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ColorChooseBlock extends StatefulWidget {
  const ColorChooseBlock({
    Key? key,
    required this.color,
    required this.checked,
    required this.press,
  }) : super(key: key);
  final Color color;
  final bool checked;
  final Function() press;

  @override
  State<ColorChooseBlock> createState() => _ColorChooseBlockState();
}

class _ColorChooseBlockState extends State<ColorChooseBlock> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.press,
      child: AnimatedContainer(
        duration: kAnimationDuration,
        width: 47.w,
        height: 47.w,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 1,
            ),
          ],
          border:
              widget.checked ? Border.all(width: 1, color: Colors.black) : null,
        ),
        child: AnimatedPadding(
          duration: kAnimationDuration,
          padding:
              widget.checked ? const EdgeInsets.all(2.0).r : EdgeInsets.zero,
          child: Container(
            decoration: BoxDecoration(
              color: widget.color,
              border: widget.checked
                  ? Border.all(width: 1, color: Colors.black)
                  : null,
            ),
            child: widget.checked ? const Icon(Icons.check) : null,
          ),
        ),
      ),
    );
  }
}
