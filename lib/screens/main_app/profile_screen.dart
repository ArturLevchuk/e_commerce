import 'package:e_commerce/constants.dart';
import 'package:e_commerce/repositories/auth_repository.dart';
import 'package:e_commerce/screens/main_app/orders/orders_screen.dart';
import 'package:e_commerce/screens/main_app/user_information_edit_screen.dart';
import 'package:e_commerce/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../routs.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static const routeName = '/ProfileScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: newAppBar(context),
      body: Column(
        children: [
          Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              height: SizeConfig.screenHeight * 0.2,
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
              ),
              decoration: BoxDecoration(
                color: const Color(0xff4a3298),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text.rich(
                TextSpan(
                  text: "A Summer Surprise\n",
                  style: TextStyle(color: Colors.white),
                  children: [
                    TextSpan(
                        text: "Cashback 20%",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              )),
          const SizedBox(height: 20),
          const ProfileMenuList(),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: MenuState.profile.index,
      ),
    );
  }

  AppBar newAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const Text(
        "Profile",
        style: TextStyle(color: Colors.black),
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
              Navigator.of(context)
                  .pushNamed(UserInformationEditScreen.routeName);
            },
          ),
          ProfileMenuItem(
            text: "Orders",
            icon: "assets/icons/Parcel.svg",
            press: () {
              Navigator.of(context).pushNamed(OrdersScreen.routeName);
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
            press: () {
              context.read<AuthRepositiry>().logout();
              Navigator.of(context).popAndPushNamed('/');
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
        tileColor: Color(0xfff5f6f9),
        leading: SvgPicture.asset(
          icon,
          color: kPrimaryColor,
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

