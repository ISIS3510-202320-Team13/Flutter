import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkez/logic/auth/bloc/authentication_bloc.dart';
import 'package:parkez/ui/auth/signin_screen.dart';
import 'package:parkez/ui/auth/signup_screen.dart';
import 'package:parkez/ui/home/home_page.dart';

class AppRouter {
  final AuthenticationBloc _authenticationBloc;

  AppRouter(this._authenticationBloc);

  Route onGeneratedRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: _authenticationBloc,
                  child: HomePage(),
                ));
      case '/signin':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: _authenticationBloc,
                  child: const SigninScreen(),
                ));
      case '/signup':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: _authenticationBloc,
                  child: const SignupScreen(),
                ));
      default:
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: _authenticationBloc,
                  child: HomePage(),
                ));
    }
  }

  void dispose() {
    _authenticationBloc.close();
  }
}
