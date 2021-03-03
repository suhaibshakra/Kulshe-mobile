abstract class Strings {
  String appName;
  String searchHint;
  String createAccount;
  String login;
  String firstName;
  String lastName;
  String nickName;
  String email;
  String phoneNumber;
  String password;
  String confirmPassword;
  String alreadyHaveAccount;
  String notHaveAccount;
  String validateFirstName;
  String validateLastName;
  String validatePhone;
  String validateEmail;
  String validatePassword;
  String validateConfirmPassword;
  String or;
  String emailOrPhone;
  String forgotPassword;
  String ads;
  String sell;
  String buy;
  String enterEmailOrPhoneError;
  String enterPasswordError;
  String send;
  String close;
  String cancel;

}

class EnglishString extends Strings {
  EnglishString() {
    appName = 'Kulshe';
    searchHint = 'What would you like to find?';
    createAccount = 'Create Account';
    login = 'Login';
    firstName = 'First Name';
    lastName = 'Last Name';
    nickName = 'Nick Name';
    email = 'Email';
    phoneNumber = 'Phone Number';
    password = 'Password';
    confirmPassword = 'Confirm Password';
    alreadyHaveAccount = 'Already Have Account ? ';
    notHaveAccount = 'Don\'t Have Account ? ';
    validateFirstName = 'Please Enter First Name';
    validateLastName = 'Please Enter Last Name';
    validatePhone = 'Enter Valid Number';
    validateEmail = 'Enter Valid Email';
    validatePassword = 'Min 5 char required';
    validateConfirmPassword = 'Min 5 char required';
    or = 'OR';
    emailOrPhone = 'Email or Phone number';
    forgotPassword = 'Forgot Password ';
    ads = 'Ads';
    sell = 'Sell';
    buy = 'Buy';
    enterEmailOrPhoneError = 'Enter Email Or Phone !';
    enterPasswordError = 'Enter Password!';
    send = 'Send';
    close = 'Close';
    cancel = 'Cancel';
  }
}

class ArabicString extends Strings {
  ArabicString(){
    appName = 'Kulshe';
    searchHint = 'ما الذي تريد البحث عنه ؟ ';
    createAccount = 'إنشاء حساب';
    login = 'تسجيل الدخول';
    firstName = 'الإسم الأول';
    lastName = 'الإسم الأخير';
    email = 'البريد الإلكتروني';
    phoneNumber = 'رقم الهاتف';
    password = 'كلمة السر';
    confirmPassword = 'تأكيد كلمة السر';
    alreadyHaveAccount = 'أمتلك حساب مسبقاً!';
    notHaveAccount = 'لا أمتلك حساب؟';
    validateFirstName = 'يرجى إدخال الإسم الأول';
    validateLastName = 'يرجى إدخال الإسم الأخير';
    validatePhone = 'يرجى إدخال رقم صالح';
    validateEmail = 'يرجى إدخال بريد إلكتروني صالح';
    validatePassword = 'يجب ألا تقل كلمة السر عن 5 أحرف ';
    validateConfirmPassword = 'يجب ألا تقل كلمة السر عن 5 أحرف';
    or = 'أو';
    emailOrPhone = 'البريد الإلكتروني أو رقم الهاتف';
    forgotPassword = 'نسيت كلمة السر ';
    ads = 'أعلن';
    sell = 'بيع';
    buy = 'اشتري';
    enterEmailOrPhoneError = 'أدخل البريد الإلكتروني او رقم الهاتف';
    enterPasswordError = 'ادخل كلمة السر';
    nickName = 'اسم المستخدم';
    send = 'إرسال';
    close = 'إغلاق';
    cancel = 'إلغاء';
  }
}