class FirebaseError {
  static String getErrorSignUp(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Email is not valid or badly formatted.';
      case 'user-disabled':
        return 'This user has been disabled. Please contact support for help.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'operation-not-allowed':
        return 'Operation is not allowed.  Please contact support.';
      case 'weak-password':
        return 'Please enter a stronger password.';
      default:
        return '';
    }
  }

  static getSignInFailure(String code) {
    switch (code) {
      case 'invalid-credential':
        return 'The supplied auth credential is incorrect, malformed or has expired.';
      case 'invalid-email':
        return 'Email is not valid or badly formatted.';
      case 'user-disabled':
        return 'This user has been disabled. Please contact support for help.';
      case 'user-not-found':
        return 'Email is not found, please create an account.';
      case 'wrong-password':
        return 'Incorrect password, please try again.';
      case 'too-many-requests':
        return 'We have blocked all requests from this device due to unusual activity. Try again later.';
      default:
        return '';
    }
  }
}
