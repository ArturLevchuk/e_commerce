import 'package:e_commerce/constants.dart';
import 'package:e_commerce/screens/main_app/all_products_screen/filter_screen.dart';
import 'package:e_commerce/screens/main_app/all_products_screen/sorting_screen.dart';
import 'package:e_commerce/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../routs.dart';
import '../home/products_bloc/products_bloc.dart';
import 'utils/sorting_fun.dart';
import 'widgets/widgets.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});
  static const routeName = '/AllProductsScreen';

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  late TextEditingController textEditingController;
  late FocusNode textFieldFocusNode;
  bool clearField = false;
  SortType sortFilter = SortType.popular;
  String sortFilterName = 'popular';
  List<Color> filterColors = [];

  @override
  void initState() {
    super.initState();
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
  }

  @override
  void dispose() {
    textEditingController.dispose();
    textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allProducts = context.read<ProductsBloc>().state.items;
    final productsListBySearch = productsBySearch(allProducts, textEditingController.text, sortFilter);
    return Scaffold(
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
                  subtitle: "by $sortFilterName",
                  icon: const Icon(Icons.swap_vert),
                  press: () async {
                    final value = await Navigator.of(context).pushNamed(
                        SortingScreen.routeName,
                        arguments: sortFilter) as SortType?;
                    if (value != null) {
                      setState(
                        () {
                          sortFilter = value;
                          switch (sortFilter) {
                            case SortType.popular:
                              setState(() {
                                sortFilterName = 'popular';
                              });
                              break;
                            case SortType.newProduct:
                              setState(() {
                                sortFilterName = 'new';
                              });
                              break;
                            case SortType.priceHigh:
                              setState(() {
                                sortFilterName = 'high price';
                              });
                              break;
                            case SortType.priceLow:
                              setState(() {
                                sortFilterName = 'low price';
                              });
                              break;
                          }

                        },
                      );
                    }
                  },
                ),
                SortingButton(
                  title: "Filter",
                  subtitle: filterColors.isEmpty
                      ? "not selected"
                      : "${filteredProducts(productsListBySearch, filterColors).length} items found",
                  icon: const Icon(Icons.filter_alt_sharp),
                  press: () async {
                    final value = await Navigator.of(context).pushNamed(
                        FiltersScreen.routeName,
                        arguments: filterColors) as List<Color>?;
                    if (value != null) {
                      setState(() {
                        filterColors = value;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: getProportionateScreenWidth(5)),
          Expanded(
            child: ProductsGrid(
              products: filterColors.isNotEmpty
                  ? filteredProducts(
                      productsListBySearch,
                      filterColors)
                  : productsListBySearch,
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          CustomNavigationBar(currentIndex: MenuState.catalog.index),
    );
  }

  AppBar newAppBar() {
    return AppBar(
      elevation: 1,
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


