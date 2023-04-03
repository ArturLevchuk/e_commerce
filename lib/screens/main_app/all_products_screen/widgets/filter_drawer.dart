import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants.dart';
import '../../../../size_config.dart';
import '../../../../widgets/DefaultButton.dart';
import '../../../../widgets/SectionTitle.dart';
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
  List<Color> filterColors = [];
  late Set<Color> avaliableColors;

  @override
  void initState() {
    final listOfListOfColors = context
        .read<ProductsBloc>()
        .state
        .items
        .map((product) => product.colors)
        .toList();
    avaliableColors = listOfListOfColors.expand((list) => list).toSet();
    // filterColors = context.read<ProductsOrderSettingsBloc>().state.filterColors;
    filterColors
        .addAll(context.read<ProductsOrderSettingsBloc>().state.filterColors);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: const Color(0xfff5f6f9),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: getProportionateScreenWidth(20)),
              child: Text(
                'Filter products by...',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: getProportionateScreenWidth(18),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SectionTitle(
                    text: "Colors",
                    button_text: "Clear selected",
                    press: () {
                      setState(() {
                        filterColors.clear();
                      });
                    },
                  ),
                  Container(
                    width: SizeConfig.screenWidth,
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(20)),
                    child: Wrap(
                      spacing: getProportionateScreenWidth(10),
                      runSpacing: getProportionateScreenWidth(10),
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
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(30),
                vertical: getProportionateScreenWidth(15),
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
        duration: defaultDuration,
        width: getProportionateScreenWidth(47),
        height: getProportionateScreenWidth(47),
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
          duration: defaultDuration,
          padding: widget.checked ? const EdgeInsets.all(2.0) : EdgeInsets.zero,
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
