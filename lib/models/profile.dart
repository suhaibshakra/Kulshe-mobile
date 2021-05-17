// // To parse this JSON data, do
// //
// //     final profile = profileFromJson(jsonString);
//
// import 'dart:convert';
//
// List<Profile> profileFromJson(String str) => List<Profile>.from(json.decode(str).map((x) => Profile.fromJson(x)));
//
// String profileToJson(List<Profile> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// class Profile {
//   Profile({
//     this.customMessage,
//     this.customCode,
//     this.responseData,
//     this.tokenData,
//     this.encrypt,
//   });
//
//   String customMessage;
//   int customCode;
//   ResponseProfileData responseData;
//   TokenData tokenData;
//   bool encrypt;
//
//   factory Profile.fromJson(Map<String, dynamic> json) => Profile(
//     customMessage: json["custom_message"],
//     customCode: json["custom_code"],
//     responseData: ResponseProfileData.fromJson(json["responseData"]),
//     tokenData: TokenData.fromJson(json["token_data"]),
//     encrypt: json["encrypt"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "custom_message": customMessage,
//     "custom_code": customCode,
//     "responseData": responseData.toJson(),
//     "token_data": tokenData.toJson(),
//     "encrypt": encrypt,
//   };
// }
//
// class ResponseProfileData {
//   ResponseProfileData({
//     this.id,
//     this.email,
//     this.fullName,
//     this.mobileNumber,
//     this.countryId,
//     this.createdAt,
//     this.updatedAt,
//     this.changePasswordOnLoginDate,
//     this.changePasswordOnLogin,
//     this.userType,
//     this.active,
//     this.mobileCountryCode,
//     this.ip,
//     this.isAdmin,
//     this.isEmailVerified,
//     this.emailVerifiedAt,
//     this.nickName,
//     this.newsletter,
//     this.promotions,
//     this.additionalPhoneNumber,
//     this.additionalPhoneCountryCode,
//     this.showContactInfo,
//     this.lastLoginDate,
//     this.lastLoginIp,
//     this.banned,
//     this.bannedAt,
//     this.bannedReason,
//     this.comeFrom,
//     this.currentLang,
//     this.adsSummary,
//     this.profileImage,
//     this.mobileCountryIsoCode,
//     this.additionalPhoneCountryIsoCode,
//     this.country,
//   });
//
//   int id;
//   String email;
//   String fullName;
//   String mobileNumber;
//   int countryId;
//   DateTime createdAt;
//   DateTime updatedAt;
//   dynamic changePasswordOnLoginDate;
//   bool changePasswordOnLogin;
//   String userType;
//   bool active;
//   String mobileCountryCode;
//   String ip;
//   int isAdmin;
//   bool isEmailVerified;
//   dynamic emailVerifiedAt;
//   String nickName;
//   bool newsletter;
//   bool promotions;
//   String additionalPhoneNumber;
//   String additionalPhoneCountryCode;
//   bool showContactInfo;
//   DateTime lastLoginDate;
//   String lastLoginIp;
//   bool banned;
//   dynamic bannedAt;
//   dynamic bannedReason;
//   String comeFrom;
//   String currentLang;
//   AdsSummary adsSummary;
//   String profileImage;
//   String mobileCountryIsoCode;
//   String additionalPhoneCountryIsoCode;
//   Country country;
//
//   factory ResponseProfileData.fromJson(Map<String, dynamic> json) => ResponseProfileData(
//     id: json["id"],
//     email: json["email"],
//     fullName: json["full_name"],
//     mobileNumber: json["mobile_number"],
//     countryId: json["country_id"],
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//     changePasswordOnLoginDate: json["change_password_on_login_date"],
//     changePasswordOnLogin: json["change_password_on_login"],
//     userType: json["user_type"],
//     active: json["active"],
//     mobileCountryCode: json["mobile_country_code"],
//     ip: json["ip"],
//     isAdmin: json["is_admin"],
//     isEmailVerified: json["is_email_verified"],
//     emailVerifiedAt: json["email_verified_at"],
//     nickName: json["nick_name"],
//     newsletter: json["newsletter"],
//     promotions: json["promotions"],
//     additionalPhoneNumber: json["additional_phone_number"],
//     additionalPhoneCountryCode: json["additional_phone_country_code"],
//     showContactInfo: json["show_contact_info"],
//     lastLoginDate: DateTime.parse(json["last_login_date"]),
//     lastLoginIp: json["last_login_ip"],
//     banned: json["banned"],
//     bannedAt: json["banned_at"],
//     bannedReason: json["banned_reason"],
//     comeFrom: json["come_from"],
//     currentLang: json["current_lang"],
//     adsSummary: AdsSummary.fromJson(json["ads_summary"]),
//     profileImage: json["profile_image"],
//     mobileCountryIsoCode: json["mobile_country_iso_code"],
//     additionalPhoneCountryIsoCode: json["additional_phone_country_iso_code"],
//     country: Country.fromJson(json["country"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "email": email,
//     "full_name": fullName,
//     "mobile_number": mobileNumber,
//     "country_id": countryId,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//     "change_password_on_login_date": changePasswordOnLoginDate,
//     "change_password_on_login": changePasswordOnLogin,
//     "user_type": userType,
//     "active": active,
//     "mobile_country_code": mobileCountryCode,
//     "ip": ip,
//     "is_admin": isAdmin,
//     "is_email_verified": isEmailVerified,
//     "email_verified_at": emailVerifiedAt,
//     "nick_name": nickName,
//     "newsletter": newsletter,
//     "promotions": promotions,
//     "additional_phone_number": additionalPhoneNumber,
//     "additional_phone_country_code": additionalPhoneCountryCode,
//     "show_contact_info": showContactInfo,
//     "last_login_date": lastLoginDate.toIso8601String(),
//     "last_login_ip": lastLoginIp,
//     "banned": banned,
//     "banned_at": bannedAt,
//     "banned_reason": bannedReason,
//     "come_from": comeFrom,
//     "current_lang": currentLang,
//     "ads_summary": adsSummary.toJson(),
//     "profile_image": profileImage,
//     "mobile_country_iso_code": mobileCountryIsoCode,
//     "additional_phone_country_iso_code": additionalPhoneCountryIsoCode,
//     "country": country.toJson(),
//   };
// }
//
// class AdsSummary {
//   AdsSummary({
//     this.allAdsCount,
//     this.approvedAdsCount,
//     this.rejectedAdsCount,
//     this.deletedAdsCount,
//     this.waitingApprovalAdsCount,
//     this.favoriteAdsCount,
//     this.pausedAdsCount,
//     this.expiredAdsCount,
//   });
//
//   int allAdsCount;
//   int approvedAdsCount;
//   int rejectedAdsCount;
//   int deletedAdsCount;
//   int waitingApprovalAdsCount;
//   int favoriteAdsCount;
//   int pausedAdsCount;
//   int expiredAdsCount;
//
//   factory AdsSummary.fromJson(Map<String, dynamic> json) => AdsSummary(
//     allAdsCount: json["all_ads_count"],
//     approvedAdsCount: json["approved_ads_count"],
//     rejectedAdsCount: json["rejected_ads_count"],
//     deletedAdsCount: json["deleted_ads_count"],
//     waitingApprovalAdsCount: json["waiting_approval_ads_count"],
//     favoriteAdsCount: json["favorite_ads_count"],
//     pausedAdsCount: json["paused_ads_count"],
//     expiredAdsCount: json["expired_ads_count"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "all_ads_count": allAdsCount,
//     "approved_ads_count": approvedAdsCount,
//     "rejected_ads_count": rejectedAdsCount,
//     "deleted_ads_count": deletedAdsCount,
//     "waiting_approval_ads_count": waitingApprovalAdsCount,
//     "favorite_ads_count": favoriteAdsCount,
//     "paused_ads_count": pausedAdsCount,
//     "expired_ads_count": expiredAdsCount,
//   };
// }
//
// class Country {
//   Country({
//     this.id,
//     this.name,
//     this.isoA2,
//   });
//
//   int id;
//   String name;
//   String isoA2;
//
//   factory Country.fromJson(Map<String, dynamic> json) => Country(
//     id: json["id"],
//     name: json["name"],
//     isoA2: json["iso_a2"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "iso_a2": isoA2,
//   };
// }
//
// class TokenData {
//   TokenData({
//     this.token,
//     this.refreshToken,
//     this.tokenType,
//     this.tokenExpiry,
//     this.userId,
//     this.name,
//     this.isAdmin,
//     this.isBanned,
//     this.isEmailVerified,
//     this.profileImage,
//   });
//
//   String token;
//   String refreshToken;
//   String tokenType;
//   int tokenExpiry;
//   int userId;
//   String name;
//   int isAdmin;
//   bool isBanned;
//   bool isEmailVerified;
//   String profileImage;
//
//   factory TokenData.fromJson(Map<String, dynamic> json) => TokenData(
//     token: json["token"],
//     refreshToken: json["refresh_token"],
//     tokenType: json["token_type"],
//     tokenExpiry: json["token_expiry"],
//     userId: json["user_id"],
//     name: json["name"],
//     isAdmin: json["is_admin"],
//     isBanned: json["is_banned"],
//     isEmailVerified: json["is_email_verified"],
//     profileImage: json["profile_image"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "token": token,
//     "refresh_token": refreshToken,
//     "token_type": tokenType,
//     "token_expiry": tokenExpiry,
//     "user_id": userId,
//     "name": name,
//     "is_admin": isAdmin,
//     "is_banned": isBanned,
//     "is_email_verified": isEmailVerified,
//     "profile_image": profileImage,
//   };
// }
