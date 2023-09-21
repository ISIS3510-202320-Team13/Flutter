import 'package:flutter/material.dart';
import 'package:parkez/ui/client/home/home_screen.dart';
import 'package:parkez/ui/theme/theme_constants.dart';
import 'package:parkez/ui/utils/helper_widgets.dart';
import 'package:parkez/ui/home/home_page.dart';

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
              // TODO: Remove chambonada of pop twice
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
<<<<<<< HEAD
                  builder: (context) => HomePage(),
=======
                  builder: (context) => const ClientHomeScreen(),
>>>>>>> 5f83554 (Enhance stepper and connect with View Flow)
                ),
              );
            },
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }
}
