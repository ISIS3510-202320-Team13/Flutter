import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkez/data/repositories/authentication_repository.dart';
import 'package:parkez/logic/auth/bloc/authentication_bloc.dart';
import 'package:parkez/ui/auth/loading_user.dart';
import 'package:parkez/ui/auth/signin_screen.dart';
import 'package:parkez/ui/home/home_page.dart';
import 'package:parkez/ui/router/app_router.dart';
import 'package:parkez/ui/theme/theme_constants.dart';

class App extends StatelessWidget {
  final AuthenticationRepository _authRepository;

  const App({required AuthenticationRepository authRepository, super.key})
      : _authRepository = authRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(authRepository: _authRepository),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    final authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _appRouter = AppRouter(authenticationBloc);
  }

  @override
  void dispose() {
    _appRouter.dispose();
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     theme: lightTheme,
  //     builder: (context, child) {
  //       // warning: this is a chambonada
  //       return BlocBuilder<AuthenticationBloc, AuthenticationState>(
  //         builder: (context, state) {
  //           switch (state.status) {
  //             case AuthenticationStatus.authenticated:
  //               return HomePage();
  //             case AuthenticationStatus.unauthenticated:
  //               return const SigninScreen();
  //             default:
  //               return const Scaffold(
  //                 body: Center(
  //                   child: CircularProgressIndicator(),
  //                 ),
  //               );
  //           }
  //         },
  //       );
  //     },
  //     onGenerateRoute: _appRouter.onGeneratedRoute,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          switch (state.status) {
            case AuthenticationStatus.authenticated:
              return LoadingUser();
            case AuthenticationStatus.unauthenticated:
              return const SigninScreen();
            default:
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
          }
        },
      ),
      onGenerateRoute: _appRouter.onGeneratedRoute,
    );
  }
}
