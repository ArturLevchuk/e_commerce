import '/apis/abstract/cart_api.dart';
import '/apis/abstract/orders_api.dart';
import '/apis/abstract/products_api.dart';
import '/apis/firebase_cart_api.dart';
import '/apis/firebase_orders_api.dart';
import '/apis/firebase_products_api.dart';
import '/modules/shop_module/core_buisness_logic/cart/vm/cart_controller.dart';
import '/modules/shop_module/core_buisness_logic/orders/vm/orders_controller.dart';
import '/modules/shop_module/core_buisness_logic/products/vm/products_controller.dart';
import '/modules/shop_module/screens/all_products_screen/all_products_screen.dart';
import '/modules/shop_module/screens/cart/cart_screen.dart';
import '/modules/shop_module/screens/favorite_products_screen/favorite_products_screen.dart';
import '/modules/shop_module/screens/home_screen/home_screen.dart';
import '/modules/shop_module/screens/orders/orders_confirm_screen/orders_confirm_screen.dart';
import '/modules/shop_module/screens/orders/orders_screen.dart';
import '/modules/shop_module/screens/product_details_screen/details_screen.dart';
import '/modules/shop_module/screens/user_information_edit_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../services/abstracts/notification_service.dart';
import '../../services/aw_notification_service.dart';
import 'main_shop_page/main_shop_page.dart';
import 'screens/all_products_screen/all_products_screen_module.dart';
import 'screens/profile_screen.dart';

class ShopModule extends Module {
  @override
  void binds(Injector i) {
    i.add<ProductsApi>(FirebaseProductsApi.new);
    i.addSingleton(ProductsController.new);

    i.add<CartApi>(FirebaseCartApi.new);
    i.add<NotificationService>(AWNotificationService.new);
    i.addSingleton(CartController.new);

    i.add<OrdersApi>(FirebaseOrdersApi.new);
    i.addLazySingleton(OrdersController.new);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      "/",
      child: (context) => const MainShopPage(),
      transition: TransitionType.fadeIn,
      guards: [],
      children: [
        ChildRoute(
          HomeScreen.routeName,
          child: (context) => const HomeScreen(),
        ),
        ModuleRoute(
          AllProductsScreen.routeName,
          module: AllProductsScreenModule(),
        ),
        ChildRoute(
          FavoriteListScreen.routeName,
          child: (context) => const FavoriteListScreen(),
        ),
        ChildRoute(
          CartScreen.routeName,
          child: (context) => const CartScreen(),
        ),
        ChildRoute(
          ProfileScreen.routeName,
          child: (context) => const ProfileScreen(),
        )
      ],
    );
    r.child(
      DetailsScreen.routeName,
      transition: TransitionType.downToUp,
      child: (context) => DetailsScreen(productId: r.args.data),
    );
    r.child(
      OrderPreparationScreen.routeName,
      child: (context) => OrderPreparationScreen(cartItemInf: r.args.data),
    );
    r.child(
      OrdersScreen.routeName,
      child: (context) => const OrdersScreen(),
    );
    r.child(
      UserInformationEditScreen.routeName,
      child: (context) => const UserInformationEditScreen(),
    );
  }
}
