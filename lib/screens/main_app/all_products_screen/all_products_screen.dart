import 'package:e_commerce/constants.dart';
import 'package:e_commerce/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  late TextEditingController textEditingController;
  late FocusNode textFieldFocusNode;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool clearField = false;
  DrawerScreen drawerScreen = DrawerScreen.sorting;

  late final List<Product> allProducts;

  @override
  void initState() {
    allProducts = context.read<ProductsBloc>().state.items;
    textEditingController = TextEditingController();
    textEditingController.addListener(() {
      if (textEditingController.text.length > 2) {
        setState(() {
          clearField = true;
        });
      } else {
        setState(() {
          clearField = false;
        });
      }
    });
    textFieldFocusNode = FocusNode();
    textFieldFocusNode.addListener(() {
      setState(() {});
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
    return BlocProvider(
      create: (context) => ProductsOrderSettingsBloc(),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child:
            BlocBuilder<ProductsOrderSettingsBloc, ProductsOrderSettingsState>(
          builder: (context, state) {
            final productsListBySearch = productsBySearch(
                allProducts, textEditingController.text, state.sortFilter);
            return Scaffold(
              key: _scaffoldKey,
              extendBody: true,
              appBar: newAppBar(),
              body: Column(
                children: [
                  DecoratedBox(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black12),
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
                  SizedBox(height: getProportionateScreenWidth(5)),
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
      ),
    );
  }

  AppBar newAppBar() {
    return AppBar(
      elevation: 1,
      actions: const [SizedBox.shrink()],
      title: TextField(
        focusNode: textFieldFocusNode,
        controller: textEditingController,
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: "Search Product....",
          prefixIcon: Icon(
            Icons.search,
            color: textFieldFocusNode.hasFocus ? kPrimaryColor : Colors.grey,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(5),
            vertical: getProportionateScreenWidth(12),
          ),
          suffixIcon: clearField
              ? IconButton(
                  splashRadius: 20,
                  padding: const EdgeInsets.only(top: 2),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    textEditingController.text = '';
                    textFieldFocusNode.unfocus();
                  },
                )
              : null,
        ),
      ),
    );
  }
}
