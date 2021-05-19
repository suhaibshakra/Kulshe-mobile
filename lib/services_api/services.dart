import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kulshe/models/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api.dart';

class SectionServicesNew {
  static const String url = '$baseURL' + '$sections';

  static Future<List> getSections() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    try {
      final response = await http.get(
        url,headers: {'lang':_pref.getString('lang')??'ar'}
      );
      // print(response.statusCode);
      if (200 == response.statusCode) {
        // print(response.body);
        final List _sections = jsonDecode('[${response.body}]');
        SharedPreferences _p = await SharedPreferences.getInstance();
        _p.setString("allSectionsData", jsonEncode(_sections).toString());
        return _sections;
      } else {
        return List();
      }
    } catch (e) {
      return List();
    }
  }
}

class CountriesServices {
  static Future<List> getCountries({double isClassified = 0}) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    try {
      final response =
          await http.get('${baseURL}countries?classified=$isClassified',headers: {'lang':_pref.getString('lang')??'ar'});
      // print(response.statusCode);
      if (200 == response.statusCode) {
        final List _countries = jsonDecode('[${response.body}]');
        SharedPreferences _p = await SharedPreferences.getInstance();
        _p.setString("allCountriesData", jsonEncode(_countries).toString());
        return _countries;
      } else {
        return List();
      }
    } catch (e) {
      return List();
    }
  }
}

class MyAdsServicesNew {
  static Future<List> getMyAdsData({
    String status,
    String limit,
    String offset,
  }) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    try {
      final response = await http.get(
          'https://api.kulshe.nurdevops.com/api/v1/user/classifieds?status=$status&limit=$limit&offset=$offset',
          headers: {
            'lang': '${_pref.getString('lang')??'ar'}',
            'Accept': 'application/json',
            'token': '${_pref.getString('token')}',
            'Authorization': 'bearer ${_pref.getString('token')}',
          });
      print(response.statusCode);
      if (200 == response.statusCode) {
        print(response.statusCode);
        // print(response.body);
        List ads = jsonDecode('[${response.body}]');
        return ads;
      } else {
        return List();
      }
    } catch (e) {
      return List();
    }
  }
} //private

class PublicAdsServicesNew {
  static Future<List> getPublicAdsData({
    int sectionId = 1,
    int subSectionId = 1,
    int countryId,
    String cityId = "",
    String brand = "",
    String subBrand = "",
    String hasPrice = "",
    int hasImage = 0,
    String sort="",
    String limit,
    String offset,
    String txt = "",
  }) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    try {
      final response = await http.get(
          '${baseURL}classifieds?text=$txt&sectionId=$sectionId&subSectionId=$subSectionId&price=&countryId=${_pref.getString('countryId')}&cityId=&brand=&subBrand=&hasPrice=&hasImage=$hasImage&sort=$sort&limit=10&offset=$offset',
          headers: {
            'lang': '${_pref.getString('lang')??'ar'}',
            'Accept': 'application/json',
            'token': '${_pref.getString('token')}',
            'Authorization': 'bearer ${_pref.getString('token')}'
          });
      print(response.statusCode);
      if (200 == response.statusCode) {
        print(response.statusCode);
        // print(response.body);

        List ads = jsonDecode('[${response.body}]');
        // AdsResponseData adsData = ads[0].responseData ;
        // List<Ad> ad = adsData.ads;
        return ads;
      } else {
        return List();
      }
    } catch (e) {
      return List();
    }
  }
}
class LatestAdsServices {
  static Future<List> getLatestAdsData({
    int offset
  }) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    try {
      final response = await http.get('${baseURL}classifieds/latest-mobile/${_pref.getString('countryId')}?limit=10&offset=$offset',
          headers: {
            'lang': '${_pref.getString('lang')??'ar'}',
            'Accept': 'application/json',
            'token': '${_pref.getString('token')}',
            'Authorization': 'bearer ${_pref.getString('token')}',
          });
      print(response.statusCode);
      if (200 == response.statusCode) {
        print(response.statusCode);
        List ads = jsonDecode('[${response.body}]');
        // AdsResponseData adsData = ads[0].responseData ;
        // List<Ad> ad = adsData.ads;
        return ads;
      } else {
        return List();
      }
    } catch (e) {
      return List();
    }
  }
}
class FilterAdsServices {
  static Future<List> getAdsData({
    var filteredData,
    int countryId,
    String cityId,
    String brand,
    String subBrand,
    String hasPrice,
    int hasImage,
    String sort,
    String limit,
    String offset,
    String txt = "",
  }) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    try {
      final response = await http.get(
          '${baseURL}classifieds?${filteredData}',
          headers: {
            'lang': '${_pref.getString('lang')??'ar'}',
            'Accept': 'application/json',
            'token': '${_pref.getString('token')}',
            'Authorization': 'bearer ${_pref.getString('token')}'
          });
      print(response.statusCode);
      if (200 == response.statusCode) {
        print(response.statusCode);
        // print(response.body);

        List ads = jsonDecode('[${response.body}]');
        // AdsResponseData adsData = ads[0].responseData ;
        // List<Ad> ad = adsData.ads;
        return ads;
      } else {
        return List();
      }
    } catch (e) {
      return List();
    }
  }
}

class GetAboutData {
  static Future<List> getData({
    int id,
  }) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    try {
      final response = await http.get(
          '${baseURL}pages/$id',
          headers: {
            'lang': '${_pref.getString('lang')??'ar'}',
            'Accept': 'application/json',
            // 'token': '${_pref.getString('token')}',
            // 'Authorization': 'bearer ${_pref.getString('token')}'
          });
      print(response.statusCode);
      if (200 == response.statusCode) {
        print(response.statusCode);
        // print(response.body);

        List ads = jsonDecode('[${response.body}]');
        // AdsResponseData adsData = ads[0].responseData ;
        // List<Ad> ad = adsData.ads;
        return ads;
      } else {
        return List();
      }
    } catch (e) {
      return List();
    }
  }
}

class SearchAdsServices {
  static Future<List> getSearchedAdsData({
    String txt,
    String hasPrice,
    int hasImage,
    String sort,
    String limit,
    String offset,
  }) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    try {
      final response = await http.get(
          '${baseURL}classifieds?text=$txt&hasImage=$hasImage&sort=$sort&offset=$offset&limit=$limit&countryId=${_pref.getString('countryId')}',
          headers: {
            'lang': '${_pref.getString('lang')??'ar'}',
            'Accept': 'application/json',
            'token': '${_pref.getString('token')}',
            'Authorization': 'bearer ${_pref.getString('token')}'
          });
      print(response.statusCode);
      if (200 == response.statusCode) {
        print(response.statusCode);
        // print(response.body);

        List ads = jsonDecode('[${response.body}]');
        // AdsResponseData adsData = ads[0].responseData ;
        // List<Ad> ad = adsData.ads;
        return ads;
      } else {
        return List();
      }
    } catch (e) {
      return List();
    }
  }
}

class AdAddForm {
  static Future getAdsForm({
    String sectionId,
    String subSectionId,
    String iso,
  }) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    try {
      final response = await http.get(
          'https://api.kulshe.nurdevops.com/api/v1/$subSectionId/classified?iso=JO',
          headers: {
            'lang': '${_pref.getString('lang')??'ar'}',
            'Accept': 'application/json',
            'token': '${_pref.getString('token')}',
            'Authorization': 'bearer ${_pref.getString('token')}'
          });
      print(response.statusCode);
      if (200 == response.statusCode) {
        // print(response.statusCode);
        List ads = jsonDecode('[${response.body}]');
        // print('ads : $ads');
        return ads;
      } else {
        return response.statusCode;
      }
    } catch (e) {
      return List();
    }
  }
}
class AdEditForm {
  static Future<List> getAdsForm({
    String adID,
  }) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    try {
      final response = await http.get(
          'https://api.kulshe.nurdevops.com/api/v1/classified/$adID',
          headers: {
            'lang': '${_pref.getString('lang')??'ar'}',
            'Accept': 'application/json',
            'token': '${_pref.getString('token')}',
            'Authorization': 'bearer ${_pref.getString('token')}'
          });
      print(response.statusCode);
      if (200 == response.statusCode) {
        // print(response.statusCode);
        List ads = jsonDecode('[${response.body}]');
        // print('ads : $ads');
        return ads;
      } else {
        return List();
      }
    } catch (e) {
      return List();
    }
  }
}

class FavoriteAdsServices {
  static Future<List> getFavData({
     String offset,
  }) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    try {
      final response = await http.get(
          '${baseURL}user/classifieds/favorite?limit=10&offset=$offset',
          headers: {
            'lang': '${_pref.getString('lang')??'ar'}',
            'Accept': 'application/json',
            'token': '${_pref.getString('token')}',
            'Authorization': 'bearer ${_pref.getString('token')}',
          });
      print(response.statusCode);
      if (200 == response.statusCode) {
        print(response.statusCode);
        List ads = jsonDecode('[${response.body}]');
        return ads;
      } else {
        return List();
      }
    } catch (e) {
      return List();
    }
  }
}

class ProfileServicesNew {
  static Future<List> getProfileData() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    try {
      final response = await http.get('${baseURL}profile', headers: {
        'accept': 'application/json',
        'token': "${_pref.getString('token')}",
        'Authorization': 'bearer ${_pref.getString('token')}',
        'lang': '${_pref.getString('lang')??'ar'}',
      });
      print(response.statusCode);
      if (200 == response.statusCode) {
        final List profile = jsonDecode('[${response.body}]');
        return profile;
      } else {
        return List();
      }
    } catch (e) {
      return List();
    }
  }
}
class AdvertiserProfileServices {
  static Future<List> advertiserProfile({
    String limit,
    String offset,
    String idHash,
  }) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    try {
      final response = await http.get('${baseURL}user-profile/$idHash?limit=$limit&offset=$offset', headers: {
        'accept': 'application/json',
        'lang': 'ar',
      });
      print(response.statusCode);
      if (200 == response.statusCode) {
        final List profile = jsonDecode('[${response.body}]');
        return profile;
      } else {
        return List();
      }
    } catch (e) {
      return List();
    }
  }
}

// class ProfileServices {
//   static const String url = '${baseURL}profile';
//
//   static Future<List<Profile>> getProfileData() async {
//     SharedPreferences _pref = await SharedPreferences.getInstance();
//
//     try {
//       final response = await http.get(url, headers: {
//         'accept': 'application/json',
//         'token': "${_pref.getString('token')}",
//         'Authorization': 'bearer ${_pref.getString('token')}'
//       });
//       print(response.statusCode);
//       if (200 == response.statusCode) {
//         print(response.statusCode);
//         print(response.body);
//         List<Profile> profile = jsonDecode('[${response.body}]');
//         print('profileLLL: $profile');
//         return profile;
//       } else {
//         return List<Profile>();
//       }
//     } catch (e) {
//       return List<Profile>();
//     }
//   }
// }


class AdDetailsServicesNew {
  static Future getAdData({
    int adId,
    String slug,
    int countryId,
  }) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    try {
      final response = await http.get(
          'https://api.kulshe.nurdevops.com/api/v1/classified/$adId/view?slug=$slug',
          headers: {
            'lang': '${_pref.getString('lang')??'ar'}',
            'Accept': 'application/json',
            'Country-id': countryId == null?'${_pref.getString('countryId')}':countryId,
            // 'Country-id': '$countryId',
            'token': '${_pref.getString('token')}',
            'Authorization': 'bearer ${_pref.getString('token')}',
          });
      // print(response.statusCode);
      if (200 == response.statusCode) {
        // print(response.statusCode);
        // print(response.body);

        List ads = jsonDecode('[${response.body}]');
        return ads;
      } else {
        return response.statusCode;
      }
    } catch (e) {
      return List();
    }
  }
}
