import '/modules/shop_module/screens/all_products_screen/vm/products_order_setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../widgets/default_button.dart';

class SortingDrawer extends StatefulWidget {
  const SortingDrawer({
    super.key,
    required this.scaffoldKey,
  });
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<SortingDrawer> createState() => _SortingDrawerState();
}

class _SortingDrawerState extends State<SortingDrawer> {
  late final ProductsOrderSettingController productsOrderSettingController;
  late SortType sortType;

  @override
  void initState() {
    productsOrderSettingController =
        context.read<ProductsOrderSettingController>();
    sortType = productsOrderSettingController.state.sortFilter;
    super.initState();
  }

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
                          "Sort by ${SortType.values[index].name}",
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
                        activeColor: Theme.of(context).colorScheme.primary,
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
                  productsOrderSettingController.changeSorting(sortType);
                  widget.scaffoldKey.currentState?.closeEndDrawer();
                  // Modular.to.pop();
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
