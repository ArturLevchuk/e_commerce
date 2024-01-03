import '/widgets/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../apis/models/product.dart';
import '../../core_buisness_logic/products/vm/products_controller.dart';
import 'utils/sorting_fun.dart';
import 'vm/products_order_setting_controller.dart';
import 'widgets/filter_drawer.dart';
import 'widgets/sorting_drawer.dart';
import 'widgets/widgets.dart';

enum DrawerScreen { filters, sorting }

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});
  static const routeName = '/AllProductsScreen';

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode textFieldFocusNode = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DrawerScreen drawerScreen = DrawerScreen.sorting;
  bool clearField = false;
  bool textFieldFocused = false;

  @override
  void initState() {
    textEditingController.addListener(
      () {
        setState(() {
          clearField = textEditingController.text.isNotEmpty;
        });
      },
    );
    textFieldFocusNode.addListener(() {
      setState(() {
        textFieldFocused = textFieldFocusNode.hasFocus;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    textFieldFocusNode.dispose();
    super.dispose();
  }

  Widget showDrawer(DrawerScreen drawerScreen) {
    switch (drawerScreen) {
      case DrawerScreen.filters:
        return FilterDrawer(scaffoldKey: _scaffoldKey);
      case DrawerScreen.sorting:
        return SortingDrawer(scaffoldKey: _scaffoldKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final List<Product> allProducts = context.read<ProductsBloc>().state.items;
    final productsController = context.read<ProductsController>();
    final productsOrderSettingController =
        context.read<ProductsOrderSettingController>();
    return StreamBuilder(
      stream: MergeStream(
          [productsOrderSettingController.stream, productsController.stream]),
      builder: (context, snap) {
        if (productsController.state.productsLoadStatus ==
            ProductsLoadStatus.loaded) {
          final List<Product> allProducts = productsController.state.items;
          final List<Product> productsListBySearch =
              ProductsShowOrder.productsBySearch(
            allProducts,
            textEditingController.text,
            productsOrderSettingController.state.sortFilter,
          );
          return Scaffold(
            key: _scaffoldKey,
            extendBody: true,
            appBar: appBar(),
            body: Column(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: const Border(
                      bottom: BorderSide(),
                    ),
                  ),
                  child: Row(
                    children: [
                      SortingButton(
                        title: "Sorting",
                        subtitle:
                            "by ${productsOrderSettingController.state.sortFilter.name}",
                        icon: const Icon(Icons.swap_vert),
                        press: () async {
                          setState(() {
                            drawerScreen = DrawerScreen.sorting;
                          });
                          _scaffoldKey.currentState?.openEndDrawer();
                        },
                      ),
                      SortingButton(
                        title: "Filter",
                        subtitle: productsOrderSettingController
                                .state.filterColors.isEmpty
                            ? "not selected"
                            : "${ProductsShowOrder.filteredProducts(productsListBySearch, productsOrderSettingController.state.filterColors).length} items found",
                        icon: const Icon(Icons.filter_alt_sharp),
                        press: () async {
                          setState(() {
                            drawerScreen = DrawerScreen.filters;
                          });
                          _scaffoldKey.currentState?.openEndDrawer();
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.w),
                Expanded(
                  child: ProductsGrid(
                    products: productsOrderSettingController
                            .state.filterColors.isNotEmpty
                        ? ProductsShowOrder.filteredProducts(
                            productsListBySearch,
                            productsOrderSettingController.state.filterColors)
                        : productsListBySearch,
                  ),
                ),
              ],
            ),
            endDrawer: showDrawer(drawerScreen),
          );
        } else {
          return const LoadingScreen();
        }
      },
    );
  }

  AppBar appBar() {
    return AppBar(
      elevation: 1,
      actions: const [SizedBox.shrink()],
      title: TextField(
        focusNode: textFieldFocusNode,
        controller: textEditingController,
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: "Search product..",
          prefixIcon: Icon(
            Icons.search,
            color: textFieldFocused
                ? Theme.of(context).colorScheme.primary
                : Colors.grey,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 12,
          ).r,
          suffixIcon: clearField
              ? IconButton(
                  splashRadius: 20,
                  icon: const Icon(
                    Icons.close,
                  ),
                  onPressed: () {
                    textEditingController.text = '';
                    textFieldFocusNode.unfocus();
                  },
                )
              : const SizedBox.shrink(),
        ),
        onTapOutside: (_) {
          textFieldFocusNode.unfocus();
        },
      ),
    );
  }
}
