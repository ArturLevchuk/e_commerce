import 'redirect_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class InitModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child("/",
        child: (context) => RedirectScreen(redirectRoute: r.args.data));
  }
}
