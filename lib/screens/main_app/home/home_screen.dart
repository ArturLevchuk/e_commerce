import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:e_commerce/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../routs.dart';
import 'products_bloc/products_bloc.dart';
import 'widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/HomeScreen';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool showLoadingHomePreviewScreen = true;
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;

  Future<void> notificationsPermissonsCheck() async {
    return AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Allow Notifications"),
            content: const Text('Our app would like to send you notifications'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Remind me later',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1?.color,
                    fontSize: 18,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Don\'t Allow',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1?.color,
                    fontSize: 18,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => AwesomeNotifications()
                    .requestPermissionToSendNotifications()
                    .then((_) => Navigator.pop(context)),
                child: const Text(
                  'Allow',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.0, 0.0),
    ).animate(_controller);
    _offsetAnimation.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        setState(() {
          showLoadingHomePreviewScreen = false;
        });
        await notificationsPermissonsCheck();
      }
    });
  }

  @override
  Future<void> didChangeDependencies() async {
    if (context.read<ProductsBloc>().state.productsLoadStatus ==
        ProductsLoadStatus.initial) {
      context.read<ProductsBloc>().add(RequestProducts());
    }
    if (context.read<ProductsBloc>().state.productsLoadStatus ==
        ProductsLoadStatus.loaded) {
      _controller.value = 1;
      setState(() {
        showLoadingHomePreviewScreen = false;
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsBloc, ProductsState>(
      // listenWhen: (previous, current) =>
      //     previous.productsLoadStatus != current.productsLoadStatus,
      listener: (context, state) async {
        if (state.productsLoadStatus == ProductsLoadStatus.loaded &&
            _controller.status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            if (state.productsLoadStatus == ProductsLoadStatus.loaded)
              Scaffold(
                extendBody: true,
                body: SafeArea(
                  bottom: false,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 20.w),
                        const DiscountBanner(),
                        SizedBox(height: 20.w),
                        const Categories(),
                        SizedBox(height: 10.w),
                        const SpecialOffers(),
                        SizedBox(height: 10.w),
                        const PopularProducts(),
                        const SizedBox(
                            height: kBottomNavigationBarHeight * 1.2),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: CustomNavigationBar(
                  currentIndex: MenuState.home.index,
                ),
              ),
            if (state.productsLoadStatus == ProductsLoadStatus.error)
              Scaffold(
                body: SafeArea(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text("${state.error}\n Try to reload page!",
                          textAlign: TextAlign.center),
                    ),
                  ),
                ),
              ),
            Visibility(
              visible: showLoadingHomePreviewScreen,
              child: SlideTransition(
                position: _offsetAnimation,
                child: const LoadingHomePreviewScreen(),
              ),
            ),
          ],
        );
      },
    );
  }
}
