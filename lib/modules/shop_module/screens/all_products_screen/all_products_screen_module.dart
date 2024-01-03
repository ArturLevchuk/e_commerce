import '/modules/shop_module/screens/all_products_screen/vm/products_order_setting_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'all_products_screen.dart';

class AllProductsScreenModule extends Module {
  @override
  void binds(Injector i) {
    i.addSingleton(ProductsOrderSettingController.new);
  }

  @override
  void routes(RouteManager r) {
    r.child("/", child: (context) => const AllProductsScreen());
  }
}
