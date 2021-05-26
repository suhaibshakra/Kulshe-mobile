abstract class Strings {
  //auth
  String appName;
  String loginTitle;
  String email;
  String emptyEmail;
  String errorEmail;
  String nickName;
  String emptyNickName;
  String errorOneNickName;
  String errorTwoNickName;
  String country;
  String selectCountry;
  String errorCountry;
  String password;
  String errorPassword;
  String emptyPassword;
  String confirmPassword;
  String errorConfirmPassword;
  String forgetPassword;
  String login;
  String loginUsing;
  String or;
  String createAccount;
  String signUp;
  String hasAccount;
  String createAccountUsing;
  String logout;
  String noAccount;
  String sendAnEmail;
  String resetPassword;
  String enterRequiredField;
  String changePassword;

  //drawer
  String myAccount;
  String myAds;
  String myPostsAds;
  String myWaitingAds;
  String myRejectedAds;
  String myFavAds;
  String categories;
  String filter;
  String newAd;
  String contactWithUs;
  String whoAreWe;
  String termsAndCon;
  String privacyPolicy;
  String followUs;

  //profile
  String userPanel;
  String profile;
  String myFav;
  String postedAds;
  String deletedAds;
  String rejectedAds;
  String waitingAds;
  String pausedAds;
  String expiredAds;
  String labelCamera;
  String labelGallery;
  String selectCity;
  String fullName;
  String mobile;
  String errorMobile;
  String emptyMobile;
  String oldPassword;
  String conPassword;
  String newPassword;
  String editProfile;
  String additionalMobile;
  String promotion;
  String news;
  String showContactInfo;

  //bottom navigation
  String addAd;
  String home;
  String more;
  String fav;

  //choices
  String delete;
  String deleteAd;
  String cancel;
  String ok;
  String done;
  String askDeleteAd;

  //search
  String search;

  //orderBy
  String orderBy;
  String oldToNew;
  String newToOld;
  String priceLessToHigh;
  String priceHighToLess;
  String withImages;

  //contact
  String callUs;
  String callAdv;
  String callAdvPrice;
  String sendEmail;
  String send;

  //Ads
  String ads;
  String adDetails;
  String warning;
  String active;
  String edit;
  String free;
  String negotiable;

  //Add Ad
  String city;
  String adTitle;
  String price;
  String currencies;
  String video;
  String adDescription;
  String postAd;
  String withDelivery;
  String chooseDate;

  //Filter
  String fPrice;
  String fFrom;
  String fTo;

  //ads validation
  String emptyTitle;
  String errorTitle;
  String errorTitleTwo;
  String emptyBody;
  String errorBody;
  String errorCity;
  String errorCurrency;

}

class EnglishString extends Strings {
  EnglishString() {
    //auth
    appName = 'Kulshe';
    loginTitle = "Login";
    email = "E-mail";
    emptyEmail = "Email is required";
    errorEmail = "email is not valid";
    password = "Password";
    errorPassword = "At least 8 characters";
    emptyPassword = "Password is required";
    forgetPassword = "Forget Password";
    login = "Login";
    loginUsing = "Login using";
    or = "OR";
    createAccount = "Create Account";
    signUp = "Sign Up";
    hasAccount = "Has account ";
    createAccountUsing = "Create account using";
    nickName = "Nick name";
    errorOneNickName = "at least 3 characters";
    errorTwoNickName = "Maximum length 20 characters";
    emptyNickName = "Username required";
    country = "Country";
    selectCountry = "Select country";
    errorCountry = "Choose country";
    confirmPassword = "Confirm Password";
    errorConfirmPassword = "Error confirm password";
    logout = "Logout";
    noAccount = "Don't have an account? ";
    sendAnEmail = "Send An Email";
    resetPassword = "Reset Password";
    //drawer
    myAccount = "My Account";
    myAds = "My Ads";
    myPostsAds = "Posts";
    myWaitingAds = "Waiting";
    myRejectedAds = "Rejected";
    myFavAds = "Favorite";
    categories = "Categories";
    filter = "Filter";
    newAd = "New Ad";
    contactWithUs = "Contact With Us";
    whoAreWe = "Who Are We";
    termsAndCon = "Terms&Conditions";
    privacyPolicy = "Privacy Policy";
    followUs = "Follow Us";
    enterRequiredField = "Enter Required Field";
    changePassword = "Change Password";
    //profile
    userPanel = "User Panel";
    profile = "Profile";
    myFav = "Favorite";
    postedAds = "Posted";
    deletedAds = "Deleted";
    rejectedAds = "Rejected";
    waitingAds = "Waiting Agree";
    pausedAds = "Paused";
    expiredAds = "Expired";
    labelCamera = "from camera";
    labelGallery = "from gallery";
    selectCity = "Select City";
    fullName = "Full Name";
    mobile = "Mobile";
    emptyMobile = "mobile is required field";
    errorMobile = "At least 7 characters";
    mobile = "Mobile";
    oldPassword= "Old Password";
    conPassword= "Current Password";
    newPassword= "New Password";
    editProfile= "Edit Profile";
    additionalMobile = "Additional Mobile";
    promotion = "Promotion";
    news = "News";
    showContactInfo = "Show Contact Info";

    //bottom navigation
    addAd = "Add Ad";
    home = "Home";
    more = "more";
    fav = "Favorite";


    //choices
    deleteAd = "Delete Ad!";
    delete = "Delete";
    cancel = "cancel";
    ok = "yes";
    done = "done";
    askDeleteAd = "Are You Sure to Delete this Ad ?";

    //search
    search = "Search in kulshe";

    //orderBy
    orderBy = "Order By";
    oldToNew = "Old to new";
    newToOld = "New to old";
    priceLessToHigh = "Price less-high";
    priceHighToLess = "Price high-less";
    withImages = 'with images';

    //contact
    callUs = "Call Us";
    callAdv = "Communicate with the advertiser";
    callAdvPrice = "Communicate advertiser for details";
    sendEmail = "Send Email";
    send = "Send";

    //Ads
    ads = "Ads";
    adDetails = "Ad Details";
    warning = "Warning against theft and fraud";
    active = "Active";
    edit = "Edit";
    free = "Free";
    negotiable = "Negotiable";

    //Add Ad
    city = "City";
    adTitle = "Ad Title";
    price = "Price";
    currencies = "Currencies";
    video = "Video";
    adDescription = "Ad Description";
    postAd = "Post Ad";
    withDelivery = "With Delivery";
    chooseDate = "Choose Date";

    //Filter
    fPrice = 'Price';
    fFrom = 'From';
    fTo = 'To';

    //ads validation
    emptyTitle = "Title required";
    errorTitle = "At least 15 characters";
    errorTitleTwo = "Enter valid title";
    emptyBody = "Description required field";
    errorBody = "At least 30 characters";
    errorCity = "City is required field";
    errorCurrency = "Currency is required field";
  }
}

class ArabicString extends Strings {
  ArabicString() {
    //auth
    appName = 'Kulshe';
    loginTitle = "تسجيل الدخول";
    email = "البريد الإلكتروني";
    errorEmail = "البريد الالكتروني المدخل غير صحيح";
    emptyEmail = "البريد الإلكتروني حقل مطلوب";
    password = "كلمة المرور";
    emptyPassword = "كلمة المرور حقل مطلوب";
    errorPassword = "الحد الأدنى 8 أحرف";
    forgetPassword = "نسيت كلمة المرور";
    login = "دخول";
    loginUsing = "دخول باستخدام";
    or = "أو";
    createAccount = "إنشاء حساب";
    signUp = "إنشاء حساب";
    hasAccount = "لديك حساب ";
    createAccountUsing = "إنشاء حساب باستخدام";
    nickName = "اسم المستحدم";
    errorOneNickName = "الحد الأدنى 3 أحرف";
    errorTwoNickName = "الحد الأقصى المسموح به لعدد الأحرف هو 20";
    emptyNickName = "اسم المستخدم حقل مطلوب";
    country = "الدولة";
    selectCountry = "إختر الدولة";
    errorCountry = "إختر الدولة";
    confirmPassword = "تأكيد كلمة السر";
    errorConfirmPassword = "خطأ في تأكيد كلمة السر";
    logout = "خروج";
    noAccount = "ليس لديك حساب؟ ";
    sendAnEmail = "إرسال البريد الإلكتروني";
    resetPassword = "إستعادة كلمة السر";
    enterRequiredField = "أدخل الحقول المطلوبة";
    changePassword = "تغيير كلمة السر";

    //drawer
    myAccount = "حسابي";
    myAds = "اعلاناتي";
    myPostsAds = "المنشورة";
    myWaitingAds = "بانتظار الموافقة";
    myRejectedAds = "المرفوضة";
    myFavAds = "المفضلة";
    categories = "الأقسام";
    filter = "فلترة";
    newAd = "اعلان جديد";
    contactWithUs = "تواصل معنا";
    whoAreWe = "من نحن";
    termsAndCon = "الشروط والأحكام";
    privacyPolicy = "سياسة الخصوصية";
    followUs = "تابعونا";

    //profile
    userPanel = "لوحة التحكم";
    profile = "حسابي";
    myFav = "الإعلانات المفضلة";
    postedAds = "المنشورة";
    deletedAds = "المحذوفة";
    rejectedAds = "المرفوضة";
    waitingAds = "بانتظار الموافقة";
    pausedAds = "المعلقة";
    expiredAds = "منتهية الصلاحية";
    labelCamera = "من الكاميرا";
    labelGallery = "من المعرض";
    selectCity = "إختر المدينة";
    fullName = "الاسم الكامل";
    mobile = "رقم الهاتف";
    emptyMobile = "رقم الموبايل حقل مطلوب";
    errorMobile = "الحد الأدنى 7 أحرف";
    oldPassword= "كلمة السر القديمة";
    conPassword= "تأكيد كلمة السر";
    newPassword= "كلمة السر الجديدة";
    editProfile= "تحديث الملف الشخصي";
    additionalMobile= "رقم هاتف اضافي";
    promotion = "العروض";
    news = "النشرات الأخبارية";
    showContactInfo = "إظهار معلومات التواصل";

    //bottom navigation
    addAd = "إضافة إعلان";
    home = "الرئيسية";
    more = "المزيد";
    fav = "المفضلة";

    //choices
    deleteAd = "حذف الإعلان!";
    deleteAd = "حذف";
    cancel = "إلغاء";
    ok = "نعم";
    done = "تم";
    askDeleteAd = "هل أنت متأكد من حذف هذا الإعلان؟";

    //search
    search = "إبحث في كل شي";

    //orderBy
    orderBy = "ترتيب حسب";
    oldToNew = "التاريخ الأقدم للأحدث";
    newToOld = "التاريخ الأحدث للأقدم";
    priceLessToHigh = "السعر من الأقل للأعلى";
    priceHighToLess = "السعر من الأعلى للأقل";
    withImages = 'مع صور';

    //contact
    callUs = "تواصل معنا";
    callAdv = "تواصل مع المعلن";
    callAdvPrice = "تواصل مع المعلن لمعرفة السعر";
    sendEmail = "إرسال بريد الكتروني";
    send = " إرسال ";

    //Ads
    ads = "الإعلانات";
    adDetails = "تفاصيل الإعلان";
    warning = "تحذير من الإحتيال و السكام";
    active = "تنشيط";
    edit = "تعديل";
    free = "مجانا";
    negotiable = "قابل للتفاوض";

    //Add Ad
    city = "المدينة";
    adTitle = "عنوان الإعلان";
    price = "السعر";
    currencies = "العملة";
    video = "الفيديو";
    adDescription = "وصف الإعلان";
    postAd = "نشر الإعلان";
    withDelivery = "مع توصيل ؟";
    chooseDate = "إختر التاريخ";

    //Filter
    fPrice = 'السعر';
    fFrom = 'من';
    fTo = 'إلى';

    //ads validation
    emptyTitle = "العنوان حقل مطلوب";
    errorTitle = "الحد الأدنى 15 حرف";
    errorTitleTwo = "يمكن لهذا الحقل أن يقبل فقط أحرف , أرقام ,نقاط ,شرطات و أقواس";
    emptyBody = "الوصف حقل مطلوب";
    errorBody = "الحد الأدنى 30 حرف";
    errorCity = "المدينة حقل مطلوب";
    errorCurrency = "العملة حقل مطلوب";
  }
}
