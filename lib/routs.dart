import 'package:e_commerce/constants.dart';
import 'package:e_commerce/screens/main_app/all_products_screen/all_products_screen.dart';
import 'package:e_commerce/screens/main_app/cart/cart_bloc/cart_bloc.dart';
import 'package:e_commerce/screens/sign_in_up_screens/complete_profile_screen.dart';
import 'package:e_commerce/screens/main_app/product_details_screen/details_screen.dart';
import 'package:e_commerce/screens/main_app/favorite_products_screen/favorite_products_screen.dart';
import 'package:e_commerce/screens/main_app/all_products_screen/filter_screen.dart';
import 'package:e_commerce/screens/sign_in_up_screens/forgot_password.dart';
import 'package:e_commerce/screens/main_app/home/home_screen.dart';
import 'package:e_commerce/screens/sign_in_up_screens/login_success_screen.dart';
import 'package:e_commerce/screens/main_app/orders/orders_confirm_screen.dart';
import 'package:e_commerce/screens/main_app/orders/orders_screen.dart';
import 'package:e_commerce/screens/sign_in_up_screens/otp_screen.dart';
import 'package:e_commerce/screens/main_app/profile_screen.dart';
import 'package:e_commerce/screens/sign_in_up_screens/sign_in_screen.dart';
import 'package:e_commerce/screens/sign_in_up_screens/sign_up_screen.dart';
import 'package:e_commerce/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'screens/main_app/cart/cart_screen.dart';
import 'screens/main_app/all_products_screen/sorting_screen.dart';
import 'screens/main_app/user_information_edit_screen.dart';
import 'widgets/IconBtnWithCounter.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  SignInScreen.routeName: (context) => const SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => const LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => const CompleteProfileScreen(),
  OtpScreen.routeName: (context) => const OtpScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  DetailsScreen.routeName: (context) => const DetailsScreen(),
  CartScreen.routeName: (context) => const CartScreen(),
  ProfileScreen.routeName: (context) => const ProfileScreen(),
  FavoriteListScreen.routeName: (context) => const FavoriteListScreen(),
  AllProductsScreen.routeName: (context) => const AllProductsScreen(),
  OrdersScreen.routeName: (context) => const OrdersScreen(),
  OrdersConfirmScreen.routeName: (context) => const OrdersConfirmScreen(),
  SortingScreen.routeName: (context) => const SortingScreen(),
  FiltersScreen.routeName: (context) => const FiltersScreen(),
  UserInformationEditScreen.routeName: (context) =>
      const UserInformationEditScreen(),
};

enum MenuState { home, catalog, favourite, cart, profile }

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({super.key, required this.currentIndex});
  final int currentIndex;

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  @override
  void didChangeDependencies() async {
    if (context.read<CartBloc>().state.cartLoadStatus ==
        CartLoadStatus.initial) {
      context.read<CartBloc>().add(RequestCart());
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CartBloc, CartState, int>(
      selector: (state) {
        return state.items.length;
      },
      builder: (context, state) {
        return BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          currentIndex: widget.currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (value) {
            if (value == MenuState.home.index) {
              Navigator.of(context).pushReplacement(
                customPageRouteBuilder(moveTo: const HomeScreen()),
              );
            } else if (value == MenuState.profile.index) {
              Navigator.of(context).pushReplacement(
                customPageRouteBuilder(moveTo: const ProfileScreen()),
              );
            } else if (value == MenuState.favourite.index) {
              Navigator.of(context).pushReplacement(
                customPageRouteBuilder(moveTo: const FavoriteListScreen()),
              );
            } else if (value == MenuState.cart.index) {
              Navigator.of(context).pushReplacement(
                customPageRouteBuilder(moveTo: const CartScreen()),
              );
            } else if (value == MenuState.catalog.index) {
              Navigator.of(context).pushReplacement(
                customPageRouteBuilder(moveTo: const AllProductsScreen()),
              );
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
                color: kPrimaryColor,
              ),
            ),
            BottomNavigationBarItem(
              label: "",
              icon: IconWithCounter(
                svgSrc: "assets/icons/Cart Icon.svg",
                numOfItems: state,
              ),
              activeIcon: IconWithCounter(
                svgSrc: "assets/icons/Cart Icon.svg",
                numOfItems: state,
                color: kPrimaryColor,
              ),
            ),
            BottomNavigationBarItem(
              label: "",
              icon: SvgPicture.asset(
                "assets/icons/User Icon.svg",
                color: Colors.grey,
              ),
              activeIcon: SvgPicture.asset(
                "assets/icons/User Icon.svg",
                color: kPrimaryColor,
              ),
            ),
          ],
        );
      },
    );
  }
}

PageRouteBuilder customPageRouteBuilder(
    {required Widget moveTo, dynamic arguments}) {
  return PageRouteBuilder(
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // animation =
      //     CurvedAnimation(parent: animation, curve: Curves.elasticInOut);

      // return ScaleTransition(
      //   scale: animation,
      //   alignment: Alignment.center,
      //   child: child,
      // );
      return FadeTransition(opacity: animation, child: child);
      // return SlideTransition(
      //   position: Tween<Offset>(
      //     begin: const Offset(-1.0, 0.0),
      //     end: Offset.zero,
      //   ).animate(animation),
      //   child: child,
      // );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return moveTo;
    },
    settings: RouteSettings(arguments: arguments),
  );
}
