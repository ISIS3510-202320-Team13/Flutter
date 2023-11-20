import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkez/data/repositories/authentication_repository.dart';
import 'package:parkez/logic/auth/bloc/authentication_bloc.dart';
import 'package:parkez/logic/connectivity_check/bloc/connectivity_check_bloc.dart';
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
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthenticationBloc(authRepository: _authRepository),
          ),
          BlocProvider(
            create: (context) => ConnectivityCheckBloc(),
          ),
        ],
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      home: BlocBuilder<ConnectivityCheckBloc, ConnectivityCheckState>(
        builder: (context, state) {
          if (state.status == ConnectivityStatus.disconnected) {
            return Scaffold(
              appBar: AppBar(title: const Text('ParkEz')),
              body: const NoInternetView(),
            );
          }
          return BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              switch (state.status) {
                case AuthenticationStatus.authenticated:
                  return const HomePage();
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
          );
        },
      ),
      onGenerateRoute: _appRouter.onGeneratedRoute,
    );
  }
}

class NoInternetView extends StatelessWidget {
  const NoInternetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/AppLogo.png',
            height: 120,
          ),
          const SizedBox(height: 20),
          const Text('No Internet Connection'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<ConnectivityCheckBloc>(context)
                  .add(const ConnectivityCheckStarted());
            },
            child: const Text('Retry'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: const Text('Exit'),
          )
        ],
      ),
    );
  }
}
