/// Form validators for visitor registration.
class Validators {
  Validators._();

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email address';
    }
    final email = value.trim();
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(email) || email.contains('..')) {
      return 'Please enter a valid email address (e.g. name@company.com)';
    }
    final parts = email.split('@');
    if (parts.length != 2 || parts[0].isEmpty || parts[1].isEmpty) {
      return 'Please enter a valid email address';
    }
    final domainParts = parts[1].split('.');
    if (domainParts.any((p) => p.isEmpty) || domainParts.last.length < 2) {
      return 'Please enter a valid domain extension (e.g. .com, .org)';
    }
    return null;
  }

  static String? validatePhone(String? value, {bool isRequired = true}) {
    if (value == null || value.trim().isEmpty) {
      if (isRequired) {
        return 'Please enter your phone number for ticket SMS';
      }
      return null;
    }
    final cleaned = value.replaceAll(RegExp(r'[\s\-()]'), '');
    if (!cleaned.startsWith('+') && !cleaned.startsWith('0')) {
      return 'Please include country code (e.g. +880...)';
    }
    if (cleaned.length < 8 || cleaned.length > 17) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? validateCompany(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your company / organization name';
    }
    return null;
  }
}

