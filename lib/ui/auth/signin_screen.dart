import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkez/data/repositories/authentication_repository.dart';
import 'package:parkez/logic/signin/cubit/signin_cubit.dart';
import 'package:parkez/ui/auth/widgets/signin_form.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocProvider(
          create: (_) => SigninCubit(context.read<AuthenticationRepository>()),
          child: const SigninForm(),
        ),
      ),
    );
  }
}
