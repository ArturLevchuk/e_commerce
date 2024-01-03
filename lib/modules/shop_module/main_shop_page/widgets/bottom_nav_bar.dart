import '/modules/shop_module/core_buisness_logic/cart/vm/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../constants.dart';
import '../../../../widgets/icon_with_counter.dart';
import '../../screens/all_products_screen/all_products_screen.dart';
import '../../screens/cart/cart_screen.dart';
import '../../screens/favorite_products_screen/favorite_products_screen.dart';
import '../../screens/home_screen/home_screen.dart';
import '../../screens/profile_screen.dart';

enum MenuState { home, catalog, favourite, cart, profile }

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({
    super.key,
  });

  int get currentIndex {
    final path = Modular.to.path;
    if (path.endsWith(HomeScreen.routeName)) {
      return MenuState.home.index;
    } else if (path.endsWith("${AllProductsScreen.routeName}/")) {
      return MenuState.catalog.index;
    } else if (path.endsWith(FavoriteListScreen.routeName)) {
      return MenuState.favourite.index;
    } else if (path.endsWith(CartScreen.routeName)) {
      return MenuState.cart.index;
    } else if (path.endsWith(ProfileScreen.routeName)) {
      return MenuState.profile.index;
    }
    return MenuState.home.index;
  }

  @override
  Widget build(BuildContext context) {
    final CartController cartController = context.read<CartController>();
    return NavigationListener(builder: (context, _) {
      final bool rounded = currentIndex != MenuState.cart.index;
      return Container(
        decoration: BoxDecoration(
          borderRadius: rounded
              ? const BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ).r
              : BorderRadius.zero,
          boxShadow: rounded
              ? [
                  themedBoxShadow(Theme.of(context).brightness),
                ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: rounded
              ? const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ).r
              : BorderRadius.zero,
          child: BottomNavigationBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedFontSize: 0,
            unselectedFontSize: 0,
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (value) {
              if (value == MenuState.home.index) {
                Modular.to.navigate('/shop${HomeScreen.routeName}');
              } else if (value == MenuState.profile.index) {
                Modular.to.navigate('/shop${ProfileScreen.routeName}');
              } else if (value == MenuState.favourite.index) {
                Modular.to.navigate('/shop${FavoriteListScreen.routeName}');
              } else if (value == MenuState.cart.index) {
                Modular.to.navigate('/shop${CartScreen.routeName}');
              } else if (value == MenuState.catalog.index) {
                Modular.to.navigate('/shop${AllProductsScreen.routeName}/');
              }
            },
            items: [
              BottomNavigationBarItem(
                label: "",
                icon: SvgPicture.asset(
                  "assets/icons/Shop Icon.svg",
                  color: Colors.grey,
                ),
                activeIcon: SvgPicture.asset(
                  "assets/icons/Shop Icon.svg",
                ),
              ),
              BottomNavigationBarItem(
                label: "",
                icon: SvgPicture.asset(
                  "assets/icons/Discover.svg",
                  color: Colors.grey,
                ),
                activeIcon: SvgPicture.asset(
                  "assets/icons/Discover.svg",
                ),
              ),
              BottomNavigationBarItem(
                label: "",
                icon: SvgPicture.asset(
                  "assets/icons/Heart Icon.svg",
                  color: Colors.grey,
                ),
                activeIcon: SvgPicture.asset(
                  "assets/icons/Heart Icon.svg",
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              BottomNavigationBarItem(
                label: "",
                icon: StreamBuilder<CartState>(
                    stream: cartController.stream,
                    builder: (context, snapshot) {
                      return IconWithCounter(
                        svgSrc: "assets/icons/Cart Icon.svg",
                        numOfItems: cartController.state.cartLoadStatus ==
                                CartLoadStatus.loaded
                            ? cartController.state.items.length
                            : null,
                      );
                    }),
                activeIcon: StreamBuilder<CartState>(
                    stream: cartController.stream,
                    builder: (context, snapshot) {
                      return IconWithCounter(
                        svgSrc: "assets/icons/Cart Icon.svg",
                        numOfItems: cartController.state.cartLoadStatus ==
                                CartLoadStatus.loaded
                            ? cartController.state.items.length
                            : null,
                        color: Theme.of(context).colorScheme.primary,
                      );
                    }),
              ),
              BottomNavigationBarItem(
                label: "",
                icon: SvgPicture.asset(
                  "assets/icons/User Icon.svg",
                  color: Colors.grey,
                ),
                activeIcon: SvgPicture.asset(
                  "assets/icons/User Icon.svg",
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
