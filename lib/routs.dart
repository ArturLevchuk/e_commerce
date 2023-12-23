import 'package:e_commerce/constants.dart';
import 'package:e_commerce/screens/main_app/all_products_screen/all_products_screen.dart';
import 'package:e_commerce/screens/main_app/cart/cart_bloc/cart_bloc.dart';
import 'package:e_commerce/screens/auth_module/sign_up_screen/complete_profile_screen.dart';
import 'package:e_commerce/screens/main_app/product_details_screen/details_screen.dart';
import 'package:e_commerce/screens/main_app/favorite_products_screen/favorite_products_screen.dart';
import 'package:e_commerce/screens/auth_module/forgot_password_screen/forgot_password.dart';
import 'package:e_commerce/screens/main_app/home/home_screen.dart';
import 'package:e_commerce/screens/auth_module/login_success_screen.dart';
import 'package:e_commerce/screens/main_app/orders/orders_confirm_screen/orders_confirm_screen.dart';
import 'package:e_commerce/screens/main_app/orders/orders_screen.dart';
import 'package:e_commerce/screens/auth_module/otp_screen/otp_screen.dart';
import 'package:e_commerce/screens/main_app/profile_screen.dart';
import 'package:e_commerce/screens/auth_module/sign_in_screen/sign_in_screen.dart';
import 'package:e_commerce/screens/auth_module/sign_up_screen/sign_up_screen.dart';
import 'package:e_commerce/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'screens/main_app/cart/cart_screen.dart';
import 'screens/main_app/user_information_edit_screen.dart';
import 'utils/customPageRouteBuilder.dart';
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
  UserInformationEditScreen.routeName: (context) =>
      const UserInformationEditScreen(),
};

enum MenuState { home, catalog, favourite, cart, profile }

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({
    super.key,
    required this.currentIndex,
    this.rounded = true,
  });
  final int currentIndex;
  final bool rounded;

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
        return Container(
          decoration: BoxDecoration(
            borderRadius: widget.rounded
                ? const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ).r
                : BorderRadius.zero,
            boxShadow: widget.rounded
                ? [
                    themedBoxShadow(Theme.of(context).brightness),
                  ]
                : [],
          ),
          child: ClipRRect(
            borderRadius: widget.rounded
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
              currentIndex: widget.currentIndex,
              type: BottomNavigationBarType.fixed,
              onTap: (value) {
                if (value == MenuState.home.index) {
                  Navigator.of(context).pushReplacement(
                    customFadePageRouteBuilder(moveTo: const HomeScreen()),
                  );
                } else if (value == MenuState.profile.index) {
                  Navigator.of(context).pushReplacement(
                    customFadePageRouteBuilder(moveTo: const ProfileScreen()),
                  );
                } else if (value == MenuState.favourite.index) {
                  Navigator.of(context).pushReplacement(
                    customFadePageRouteBuilder(
                        moveTo: const FavoriteListScreen()),
                  );
                } else if (value == MenuState.cart.index) {
                  Navigator.of(context).pushReplacement(
                    customFadePageRouteBuilder(moveTo: const CartScreen()),
                  );
                } else if (value == MenuState.catalog.index) {
                  Navigator.of(context).pushReplacement(
                    customFadePageRouteBuilder(
                        moveTo: const AllProductsScreen()),
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
            ),
          ),
        );
      },
    );
  }
}
