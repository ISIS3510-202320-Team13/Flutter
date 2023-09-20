import 'package:flutter/material.dart';
import 'package:parkez/ui/theme/theme_constants.dart';
import 'package:parkez/ui/utils/helper_widgets.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: screenPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'SignIn to your account',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          verticalSpace(100.0),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.mail),
              hintText: 'Enter your email',
              labelText: 'Email *',
            ),
            // validator: (String? value) {},
          ),
          TextFormField(
            decoration: const InputDecoration(
                icon: Icon(Icons.lock),
                hintText: 'Enter your password',
                labelText: 'Password *'),
            obscureText: true,
            // validator: (String? value) {},
          ),
          verticalSpace(100.0),
          ElevatedButton(
            onPressed: () {
              print('Sign In');
            },
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }
}
