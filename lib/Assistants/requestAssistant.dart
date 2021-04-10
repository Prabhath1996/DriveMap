import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestAssistant {
  static Future<dynamic> getRequest(String url) async {
    http.Response response = await http.get(Uri.parse(url));

    try {
      if (response.statusCode == 200) {
        String jsonData = response.body;
        var decodData = jsonDecode(jsonData);
        //print("location request sucsessfull............");
        return decodData;
      } else {
        return "failed";
      }
    } catch (exp) {
      return "failed";
    }
  }
}
