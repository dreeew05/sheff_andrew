import 'package:http/http.dart' as http;

class NetworkImageCheck {
  Future<String> checkImageURL(String url, String defaultImage) async {
    final response = await http.get(Uri.parse(url));
    return response.statusCode == 200 ? url : defaultImage;
  }
}
