class SingupWithEmailAndPasswordFailure implements Exception {
  final String message;

  const SingupWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  factory SingupWithEmailAndPasswordFailure.fromCode(String code) {
    // Codes from https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/createUserWithEmailAndPassword.html
    switch (code) {
      case 'invalid-email':
        return const SingupWithEmailAndPasswordFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const SingupWithEmailAndPasswordFailure(
          'The user account has been disabled. Plase contact support for help',
        );
      case 'email-already-in-use':
        return const SingupWithEmailAndPasswordFailure(
          'The email address is already in use by another account.',
        );
      case 'operation-not-allowed':
        return const SingupWithEmailAndPasswordFailure(
          'The administrator has disabled sign-ups for this app.',
        );
      case 'weak-password':
        return const SingupWithEmailAndPasswordFailure(
          'The password is too weak.',
        );
      default:
        return const SingupWithEmailAndPasswordFailure();
    }
  }
}

class SigninWithEmailAndPasswordFailure implements Exception {
  final String message;

  const SigninWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  factory SigninWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const SigninWithEmailAndPasswordFailure(
          'Email is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const SigninWithEmailAndPasswordFailure(
          'The user account has been disabled. Please contact for help',
        );
      case 'user-not-found':
        return const SigninWithEmailAndPasswordFailure(
          'Email is not registered. Please create an account',
        );
      case 'wrong-password':
        return const SigninWithEmailAndPasswordFailure(
          'Incorrect password. Please try again',
        );
      default:
        return const SigninWithEmailAndPasswordFailure();
    }
  }
}

class SigninWithGoogleFailure implements Exception {
  final String message;

  const SigninWithGoogleFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  factory SigninWithGoogleFailure.fromCode(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return const SigninWithGoogleFailure(
          'Account exists with different credentials.',
        );
      case 'invalid-credential':
        return const SigninWithGoogleFailure(
          'The credential received is malformed or has expired.',
        );
      case 'operation-not-allowed':
        return const SigninWithGoogleFailure(
          'Operation is not allowed.  Please contact support.',
        );
      case 'user-disabled':
        return const SigninWithGoogleFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const SigninWithGoogleFailure(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const SigninWithGoogleFailure(
          'Incorrect password, please try again.',
        );
      case 'invalid-verification-code':
        return const SigninWithGoogleFailure(
          'The credential verification code received is invalid.',
        );
      case 'invalid-verification-id':
        return const SigninWithGoogleFailure(
          'The credential verification ID received is invalid.',
        );
      default:
        return const SigninWithGoogleFailure();
    }
  }
}

class SignOutFailure implements Exception {
  final String message;

  const SignOutFailure([
    this.message = 'An unknown exception occurred.',
  ]);
}
