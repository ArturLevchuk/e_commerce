import '/modules/core_modules/auth_module/vm/auth_controller.dart';
import '/modules/shop_module/screens/orders/orders_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'home_screen/widgets/discount_banner.dart';
import 'user_information_edit_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static const String routeName = '/ProfileScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: appBar(context),
      body: Column(
        children: [
          const DiscountBanner(),
          SizedBox(height: 20.w),
          const ProfileMenuList(),
        ],
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        "Profile",
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}

class ProfileMenuList extends StatelessWidget {
  const ProfileMenuList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          ProfileMenuItem(
            text: "My Account",
            icon: "assets/icons/User Icon.svg",
            press: () {
              Modular.to.pushNamed(".${UserInformationEditScreen.routeName}");
            },
          ),
          ProfileMenuItem(
            text: "Orders",
            icon: "assets/icons/Parcel.svg",
            press: () {
              Modular.to.pushNamed(".${OrdersScreen.routeName}");
            },
          ),
          ProfileMenuItem(
            text: "Settings",
            icon: "assets/icons/Settings.svg",
            press: () {},
          ),
          ProfileMenuItem(
            text: "Help Center",
            icon: "assets/icons/Question mark.svg",
            press: () {},
          ),
          ProfileMenuItem(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: () async {
              // context.read<AuthRepositiry>().logout();
              // Navigator.of(context).popAndPushNamed('/');
              await context.read<AuthController>().logout();
            },
          ),
        ],
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  const ProfileMenuItem({
    Key? key,
    required this.text,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String text, icon;
  final Function() press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListTile(
        // tileColor: Color(0xfff5f6f9),
        tileColor: Theme.of(context).colorScheme.surface,
        leading: SvgPicture.asset(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(text),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onTap: press,
      ),
    );
  }
}
