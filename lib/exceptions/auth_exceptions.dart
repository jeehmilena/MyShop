class AuthException implements Exception {
  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'E-mail already registered.',
    'OPERATION_NOT_ALLOWED': 'operation not allowed!',
    'TOO_MANY_ATTEMPTS_TRY_LATER':
        'Access temporarily blocked. Please try later again!',
    'EMAIL_NOT_FOUND': 'Email not found!',
    'INVALID_PASSWORD': 'Invalid password.',
    'USER_DISABLED': 'User disabled!',
  };

  final String key;

  AuthException(this.key);

  @override
  String toString() {
    return errors[key] ??
        'Ops! An error occurred in the authentication process!';
  }
}
