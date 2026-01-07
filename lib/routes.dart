import 'package:flutter/material.dart';
import 'package:shop/register/register.dart';
import 'package:shop/screens/home/home_screen.dart';
import 'package:shop/login/login_screen.dart';
import 'package:shop/screens/home/model.dart';
import 'package:shop/splash/splash_screen.dart';

import 'create note/view.dart';
import 'edit notes/view.dart';

class Routes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String register = '/register';
  static const String notesDetails = '/notesDetails';
  static const String createNote = '/createNote';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    var args = settings.arguments;
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case Routes.home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
        case Routes.register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case Routes.notesDetails:
        if (args is Notes) {
          return MaterialPageRoute(
            builder: (_) => NoteDetailScreen(note: args),
          );
        }
        return _errorRoute();
      case Routes.createNote:
        return MaterialPageRoute(builder: (_) => CreateNoteScreen());

      default:
        return _undefinedRoute();
    }
  }

  static Route<dynamic> _undefinedRoute() {
    return MaterialPageRoute(
      builder: (_) =>
          const Scaffold(body: Center(child: Text("Page Not Found"))),
    );
  }

}
MaterialPageRoute _errorRoute() {
  return MaterialPageRoute(
    builder: (_) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: const Center(child: Text('Route Error')),
    ),
  );
}