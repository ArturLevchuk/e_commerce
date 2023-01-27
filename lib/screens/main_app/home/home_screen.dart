import 'package:flutter/material.dart';
import 'package:e_commerce/size_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  bool _isLoading = false;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(-1.0, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  ));

  @override
  Future<void> didChangeDependencies() async {
    if (context.read<ProductsBloc>().state.productsLoadStatus ==
        ProductsLoadStatus.initial) {
      context.read<ProductsBloc>().add(RequestProducts());
    }
    if (context.read<ProductsBloc>().state.productsLoadStatus ==
        ProductsLoadStatus.loaded) {
      _controller.value = 1;
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
      listenWhen: (previous, current) =>
          previous.productsLoadStatus != current.productsLoadStatus,
      listener: (context, state) {
        if (state.productsLoadStatus == ProductsLoadStatus.loaded &&
            _isLoading == false) {
          _controller.value = 1;
        } else if (state.productsLoadStatus == ProductsLoadStatus.loaded &&
            _isLoading == true) {
          _controller.forward();
        }
        if (state.productsLoadStatus == ProductsLoadStatus.loading) {
          setState(() {
            _isLoading = true;
          });
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            if (state.productsLoadStatus == ProductsLoadStatus.loaded)
              Scaffold(
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: getProportionateScreenHeight(25)),
                        const DiscountBanner(),
                        SizedBox(height: getProportionateScreenHeight(25)),
                        const Categories(),
                        SizedBox(height: getProportionateScreenHeight(15)),
                        const SpecialOffers(),
                        SizedBox(height: getProportionateScreenHeight(15)),
                        const PopularProducts(),
                        SizedBox(height: getProportionateScreenHeight(15)),
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
            if (!_offsetAnimation.isCompleted)
              SlideTransition(
                position: _offsetAnimation,
                child: const LoadingHomeScreenSplash(),
              ),
          ],
        );
      },
    );
  }
}
