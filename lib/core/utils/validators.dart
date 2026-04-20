class AppValidators {
  // Required field
  static String? validateRequired(String? value, {required String fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Indian Phone: Required + 10 digits + starts with 6-9
  static String? validateIndianPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Contact Number is required';
    }
    final trimmed = value.trim();
    if (trimmed.length != 10) {
      return 'Enter a valid 10-digit number';
    }
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(trimmed)) {
      return 'Invalid Indian mobile number';
    }
    return null;
  }

  // Website: Optional, but must be a valid URL if provided
  static String? validateWebsiteOptional(String? value) {
    if (value == null || value.trim().isEmpty) return null;

    final url = value.trim().toLowerCase();

    // Must start with http:// or https:// (or allow without, but add it later)
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return 'Website must start with http:// or https://';
    }

    try {
      final uri = Uri.parse(url);

      // Must have a host (domain)
      if (uri.host.isEmpty) {
        return 'Enter a valid website URL';
      }

      // Must have at least one dot in host and a valid TLD (2+ letters)
      if (!uri.host.contains('.') || uri.host.endsWith('.')) {
        return 'Invalid domain name';
      }

      // Reject common fake domains
      final tld = uri.host.split('.').last;
      if (tld.length < 2 || !RegExp(r'^[a-z]+$').hasMatch(tld)) {
        return 'Invalid top-level domain';
      }

      // Optional: reject localhost or internal IPs in production
      if (uri.host == 'localhost' ||
          RegExp(r'^(10|172\.16|192\.168)\.').hasMatch(uri.host)) {
        return 'Local addresses are not allowed';
      }

      return null;
    } catch (e) {
      return 'Enter a valid website URL';
    }
  }

  // PAN: Optional, but valid if provided
  static String? validatePanOptional(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final pan = value.trim().toUpperCase();
    if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(pan)) {
      return 'Enter a valid PAN (e.g., ABCDE1234F)';
    }
    return null;
  }

  // GST: Optional, but valid if provided
  static String? validateGstOptional(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final gst = value.trim().toUpperCase();
    if (!RegExp(r'^\d{2}[A-Z]{5}\d{4}[A-Z]{1}[A-Z\d]{1}[Z]{1}[A-Z\d]{1}$').hasMatch(gst)) {
      return 'Enter a valid GST Number';
    }
    return null;
  }

  // Pin Code: Required + 6 digits
  static String? validatePinCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Pin Code is required';
    }
    if (!RegExp(r'^\d{6}$').hasMatch(value.trim())) {
      return 'Enter a valid 6-digit Pin Code';
    }
    return null;
  }

  // Email: Required + valid format
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  // Password Complexity: Char, Number, Special Char
  // static String? validatePasswordComplexity(String? value) {
  //   if (value == null || value.trim().isEmpty) return 'Password is required';
  //   final v = value.trim();
  //   if (v.length < 8) return 'Minimum 8 characters required';
  //   // if (!RegExp(r'[a-zA-Z]').hasMatch(v)) return 'Must contain at least one letter';
  //   if (!RegExp(r'[0-9]').hasMatch(v)) return 'Must contain at least one number';
  //   // if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(v))
  //     return 'Must contain a special character';
  //   return null;
  // }


}