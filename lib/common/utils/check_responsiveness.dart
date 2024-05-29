import 'package:http/http.dart' as http;

class CheckResponsiveness {
  Future<bool> checkIfLinkIsResponsive(String link) async {
    final response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
