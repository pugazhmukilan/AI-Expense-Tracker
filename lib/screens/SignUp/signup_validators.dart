

 String? nameValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Name required';
    return null;
  }

  String? emailValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email required';
    final emailRegex = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$");
    if (!emailRegex.hasMatch(v)) return 'Enter a valid email';
    return null;
  }

  String? passValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Password required';
    if (v.length < 6) return 'Minimum 6 characters';
    return null;
  }