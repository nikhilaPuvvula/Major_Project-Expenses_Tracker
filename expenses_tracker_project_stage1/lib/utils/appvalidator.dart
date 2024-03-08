class AppValidator{
   String? validateUsername(value) {
    if (value!.isEmpty) {
      return 'Please enter username';
    }
    return null;
  }

  String? validateEmail(value) {
    if (value!.isEmpty) {
      return 'Please enter an email';
    }
    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter an email';
    }
    return null;
  }

  String? validatePhoneNumber(value) {
    if (value!.isEmpty) {
      return 'Please enter a phone Number';
    }
    if (value.length != 10) {
      return 'Please Enter a 10-digit phone Number';
    }
    return null;
  }

  String? validatePassword(value) { if (value!.isEmpty) {
      return 'Please enter a Password';
    }
    return null;
  }

  String? isEmptyCheck(value) {
    if (value!.isEmpty) {
      return 'Please fill details';
    }
    return null;
  }
}