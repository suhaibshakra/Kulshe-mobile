import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences{
  static String spToken = "token";
  static String spRefreshToken = "refresh_token";

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
}