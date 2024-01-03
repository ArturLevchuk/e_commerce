import './screens/forgot_password_screen/forgot_password.dart';
import './screens/otp_screen/otp_screen.dart';
import './screens/sign_up_screen/complete_profile_screen.dart';
import './screens/sign_up_screen/sign_up_screen.dart';
import './screens/sign_in_screen/sign_in_screen.dart';
import './screens/splash_screen/splash_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthorizationModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child("/", child: (context) => const SplashScreen());
    r.child(SignInScreen.routeName, child: (context) => const SignInScreen());
    r.child(SignUpScreen.routeName, child: (context) => const SignUpScreen());
    r.child(
      CompleteProfileScreen.routeName,
      child: (context) =>  CompleteProfileScreen(args: r.args.data),
    );
    r.child(OtpScreen.routeName, child: (context) => OtpScreen(email: r.args.data));
    r.child(
      ForgotPasswordScreen.routeName,
      child: (context) => const ForgotPasswordScreen(),
    );
  }
}
