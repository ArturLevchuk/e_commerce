import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants.dart';
import '../../../../widgets/default_button.dart';
import '../products_order_settings_bloc/products_order_settings_bloc.dart';

class SortingDrawer extends StatefulWidget {
  const SortingDrawer({
    super.key,
  });

  @override
  State<SortingDrawer> createState() => _SortingDrawerState();
}

class _SortingDrawerState extends State<SortingDrawer> {
  late SortType sortType =
      context.read<ProductsOrderSettingsBloc>().state.sortFilter;
  final List<String> sortNames = [
    "Sort by low price!",
    "Sort by high price!",
    "Sort by popular!",
    "Sort by new!",
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: Theme.of(context).colorScheme.background,
        child: Column(
          children: [
            RPadding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Sort products by..',
                style: TextStyle(
                  fontSize: 17.sp,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ...List.generate(
                    SortType.values.length,
                    (index) => choiceCard(
                      child: RadioListTile(
                        value: SortType.values[index],
                        title: Text(
                          sortNames[index],
                          style: TextStyle(fontSize: 15.sp),
                        ),
                        groupValue: sortType,
                        onChanged: (value) {
                          setState(() {
                            sortType = value!;
                          });
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20).r),
                        activeColor: kPrimaryColor,
                      ),
                    ),
                  ),
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

  Container choiceCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 20,
      ).r,
      decoration: BoxDecoration(
        // color: Colors.white,
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20).r,
      ),
      child: child,
    );
  }
}
