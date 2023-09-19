import 'package:flutter/material.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(64.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            'Create an account',
            style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30.0),
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
          const SizedBox(height: 30.0),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Continue'),
          )
        ],
      ),
    );
  }
}
