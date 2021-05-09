import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences{
  static String spToken = "token";
  static String spRefreshToken = "refresh_token";
  static String userID = "uID";
  static String spCountries = "savedCountries";
  static String spSections = "allSectionsData";
  static String spCountryId = "countryId";
  static String spIsEmailVerified = "isEmailVerified";

  static Future<bool> saveTokenSP(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(
        spToken, token);
  }

  static Future<bool> saveRefreshTokenSP(String refreshToken) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(
        spRefreshToken, refreshToken);
  }

  static Future<bool> savedCountries(bool savedCountries) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(
        spCountries, savedCountries);
  }

  static Future<bool> saveIsEmailVerified(bool emailVerified) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(
        spIsEmailVerified, emailVerified);
  }
  static Future<bool> saveIsLoginSP(bool savedSections) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(
        spSections, savedSections);
  }
  static Future<bool> saveCountryId(String savedCId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(
        spCountryId, savedCId);
  }
  static Future<bool> saveUserId(String savedUID) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(
        userID, savedUID);
  }

}