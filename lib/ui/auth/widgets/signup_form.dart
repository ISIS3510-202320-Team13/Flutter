import 'package:flutter/material.dart';
import 'package:parkez/ui/theme/theme_constants.dart';
import 'package:parkez/ui/utils/helper_widgets.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: screenPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Create an account',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          verticalSpace(100.0),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              hintText: 'What do people call you?',
              labelText: 'Name *',
            ),
            // validator: (String? value) {},
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.mail),
              hintText: 'What\'s your email address?',
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
          TextFormField(
            decoration: const InputDecoration(
                icon: Icon(Icons.lock),
                hintText: 'Confirm your password',
                labelText: 'Password confirmation *'),
            obscureText: true,
            // validator: (String? value) {},
          ),
          verticalSpace(100.0),
          ElevatedButton(
            onPressed: () {
              print('Creating account...');
            },
            child: const Text('Create Account'),
          ),
        ],
      ),
    );
  }
}
