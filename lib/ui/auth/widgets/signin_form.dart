import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';
import 'package:parkez/logic/signin/cubit/signin_cubit.dart';
import 'package:parkez/ui/auth/loading_user.dart';
class SigninForm extends StatelessWidget {
  const SigninForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SigninCubit, SigninState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Authentication Failure'),
              ),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/AppLogo.png',
                height: 120,
              ),
              const SizedBox(height: 16),
              _EmailInput(),
              const SizedBox(height: 8),
              _PasswordInput(),
              const SizedBox(height: 8),
              _SigninButton(),
              const SizedBox(height: 8),
              _GoogleSigninButton(),
              const SizedBox(height: 4),
              _SignupButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SigninCubit, SigninState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextFormField(
          key: const Key('signinForm_emailInput_textField'),
          onChanged: (email) => context.read<SigninCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              icon: const Icon(Icons.mail),
              hintText: 'Enter your email',
              labelText: 'Email *',
              errorText:
                  state.email.displayError != null ? 'invalid email' : null),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SigninCubit, SigninState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextFormField(
          key: const Key('signinForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<SigninCubit>().passwordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
              icon: const Icon(Icons.lock),
              hintText: 'Enter your password',
              labelText: 'Password *',
              errorText: state.password.displayError != null
                  ? 'invalid password'
                  : null),
        );
      },
    );
  }
}

class _SigninButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SigninCubit, SigninState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('signinForm_continue_raisedButton'),
                onPressed: state.isValid
                    ? () => context.read<SigninCubit>().signinWithCredentials()
                    : null,
                child: const Text('Sign In'),
              );
      },
    );
  }
}

class _GoogleSigninButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton.icon(
      key: const Key('signinForm_googleSignin_raisedButton'),
      onPressed: () => context.read<SigninCubit>().signinWithGoogle(),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.secondary,
      ),
      icon: const Icon(FontAwesomeIcons.google, color: Colors.white),
      label: const Text('Sign In with Google'),
    );
  }
}

class _SignupButton extends StatelessWidget {
  const _SignupButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      key: const Key('signinForm_createAccount_flatButton'),
      onPressed: () =>  Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) => LoadingUser(),
        ),
      ),
      child: Text(
        'Create Account',
        style: TextStyle(color: theme.primaryColor),
      ),
    );
  }
}
