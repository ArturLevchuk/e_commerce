import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants.dart';
import '../../../../size_config.dart';
import '../../../../widgets/DefaultButton.dart';
import '../products_order_settings_bloc/products_order_settings_bloc.dart';

class SortingDrawer extends StatefulWidget {
  const SortingDrawer({
    super.key,
  });

  @override
  State<SortingDrawer> createState() => _SortingDrawerState();
}

class _SortingDrawerState extends State<SortingDrawer> {
  late SortType sortType;
  final List<String> sortNames = [
    "Sort by low price!",
    "Sort by high price!",
    "Sort by popular!",
    "Sort by new!",
  ];

  @override
  void initState() {
    sortType = context.read<ProductsOrderSettingsBloc>().state.sortFilter;
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
                'Sort products by...',
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
                  ...List.generate(
                    SortType.values.length,
                    (index) => paddingContainer(
                      child: RadioListTile(
                        value: SortType.values[index],
                        title: Text(
                          sortNames[index],
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16),
                        ),
                        groupValue: sortType,
                        onChanged: (value) {
                          setState(() {
                            sortType = value!;
                          });
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        activeColor: kPrimaryColor,
                      ),
                    ),
                  ),
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
                        UpdateSorting(sortType: sortType),
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

Container paddingContainer({required Widget child}) {
  return Container(
    margin: EdgeInsets.only(
      left: getProportionateScreenWidth(20),
      right: getProportionateScreenWidth(20),
      bottom: getProportionateScreenWidth(20),
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: child,
  );
}
