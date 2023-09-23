import 'package:flutter/material.dart';
import 'package:parkez/ui/theme/theme_constants.dart';
import 'package:parkez/ui/utils/helper_widgets.dart';
import 'package:parkez/ui/widgets/signin_form.dart';
import 'package:parkez/ui/widgets/signup_form.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            verticalSpace(100.0),
            Image.asset('assets/AppLogo.png'),
            verticalSpace(100.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                );
              },
              child: const Text('Sign In'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                );
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SignUpForm(),
    );
  }
}

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SignInForm(),
    );
    ;
  }
}
