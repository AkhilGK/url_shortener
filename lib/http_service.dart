import 'dart:convert';

import 'package:http/http.dart' as http;

class Services {
  Future<String> shortUrl(String url) async {
    try {
      final result = await http.post(
          Uri.parse('https://cleanuri.com/api/v1/shorten'),
          body: {'url': url});

      if (result.statusCode == 200) {
        final jsonResult = jsonDecode(result.body);
        return jsonResult['result_url'];
      }
    } catch (e) {
      print(e.toString());
    }
    return 'No result';
  }
}
