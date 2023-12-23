import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../repositories/models/product.dart';
import '../../../routs.dart';
import '../home/products_bloc/products_bloc.dart';
import 'products_order_settings_bloc/products_order_settings_bloc.dart';
import 'utils/sorting_fun.dart';
import 'widgets/filter_drawer.dart';
import 'widgets/sorting_drawer.dart';
import 'widgets/widgets.dart';

enum DrawerScreen { filters, sorting }

Widget? showDrawer(DrawerScreen drawerScreen) {
  switch (drawerScreen) {
    case DrawerScreen.filters:
      return const FilterDrawer();
    case DrawerScreen.sorting:
      return const SortingDrawer();
    default:
      return null;
  }
}

String getSortType(SortType sortType) {
  switch (sortType) {
    case SortType.popular:
      return 'popular';
    case SortType.newProduct:
      return 'new';
    case SortType.priceHigh:
      return 'high price';
    case SortType.priceLow:
      return 'low price';
    default:
      return 'unknown';
  }
}

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

  @override
  Widget build(BuildContext context) {
    final List<Product> allProducts = context.read<ProductsBloc>().state.items;
    return BlocProvider(
      create: (context) => ProductsOrderSettingsBloc(),
      child: BlocBuilder<ProductsOrderSettingsBloc, ProductsOrderSettingsState>(
        builder: (context, state) {
          final List<Product> productsListBySearch = productsBySearch(
            allProducts,
            textEditingController.text,
            state.sortFilter,
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
                        subtitle: "by ${getSortType(state.sortFilter)}",
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
                        subtitle: state.filterColors.isEmpty
                            ? "not selected"
                            : "${filteredProducts(productsListBySearch, state.filterColors).length} items found",
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
                    products: state.filterColors.isNotEmpty
                        ? filteredProducts(
                            productsListBySearch, state.filterColors)
                        : productsListBySearch,
                  ),
                ),
              ],
            ),
            bottomNavigationBar:
                CustomNavigationBar(currentIndex: MenuState.catalog.index),
            endDrawer: showDrawer(drawerScreen),
          );
        },
      ),
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
