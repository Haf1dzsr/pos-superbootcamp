class Validator {
  static const emailRegexPattern =
      r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';

  static const passwordRegexPattern = r'.{6,}';
  static String? emailValidator(String? value) {
    final regex = RegExp(emailRegexPattern);
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    } else if (!regex.hasMatch(value)) {
      return 'Email tidak valid';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    } else if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    // else if (!value.contains(RegExp(r'[0-9]'))) {
    //   return 'Password harus mengandung angka';
    // } else if (!value.contains(RegExp(r'[A-Z]'))) {
    //   return 'Password harus mengandung huruf kapital';
    // } else if (!value.contains(RegExp(r'[a-z]'))) {
    //   return 'Password harus mengandung huruf kecil';
    // } else if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    //   return 'Password harus mengandung karakter khusus';
    // }
    return null;
  }

  static String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    return null;
  }

  static String? phoneNumberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor Handphone tidak boleh kosong';
    }
    return null;
  }

  static String? requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field tidak boleh kosong';
    }
    return null;
  }

  static String? numberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor tidak boleh kosong';
    } else if (value.contains(RegExp(r'[a-zA-Z]'))) {
      return 'Nomor tidak boleh mengandung huruf';
    }
    return null;
  }
}
