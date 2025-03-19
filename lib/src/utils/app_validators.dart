class AppValidators {
  AppValidators._();

  static bool isMobileNumber(String mobileNumber) =>
      RegExp(r"^[0-9]{10}$").hasMatch(mobileNumber);

  static bool isEmail(String email) => RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9-]+\.[a-zA-Z]+",
      ).hasMatch(email);
}
