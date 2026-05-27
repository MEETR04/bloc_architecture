extension StringExtensions on String {
  String? get validateEmail {
    if (trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegExp.hasMatch(trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? get validatePassword {
    if (isEmpty) {
      return 'Password is required';
    }
    if (length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }
}
