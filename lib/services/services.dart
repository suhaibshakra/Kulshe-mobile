import 'package:http/http.dart' as http;
import 'package:kulshe/model/sections.dart';
class SectionServices {
  static const String url = 'https://api.kulshe.nurdevops.com/api/v1/sections';
  // static String url = "${baseURL + sections}";

  static Future<List<Sections>> getSections() async {
    try {
      final response = await http.get(url);
      print(response.statusCode);
      if (200 == response.statusCode) {
        // print(response.body);
        final List<Sections> sections =
        sectionsFromJson('[${response.body}]');


        return sections;
      } else {
        return List<Sections>();
      }
    } catch (e) {
      return List<Sections>();
    }
  }
}