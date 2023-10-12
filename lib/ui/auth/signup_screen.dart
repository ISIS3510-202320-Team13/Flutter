import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkez/data/repositories/authentication_repository.dart';
import 'package:parkez/logic/signup/cubit/signup_cubit.dart';
import 'package:parkez/ui/auth/widgets/signup_form.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocProvider<SignupCubit>(
          create: (_) => SignupCubit(context.read<AuthenticationRepository>()),
          child: const SignupForm(),
        ),
      ),
    );
  }
}
