import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// class NetworkImageCheck extends StatefulWidget {
//   final String url;
//   final String defaultImageURL;

//   const NetworkImageCheck(
//       {super.key, required this.url, required this.defaultImageURL});

//   @override
//   _NetworkImageCheckState createState() => _NetworkImageCheckState();
// }

// class _NetworkImageCheckState extends State<NetworkImageCheck> {
//   String _finalImageLink = '';
//   @override
//   void initState() {
//     super.initState();
//     _checkImageURL();
//   }

//   Future<void> _checkImageURL() async {
//     final response = await http.head(Uri.parse(widget.url));
//     String finalImageLink =
//         response.statusCode == 200 ? widget.url : widget.defaultImageURL;
//     setState(() {
//       _finalImageLink = finalImageLink;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CircleAvatar(
//       radius: 100,
//       backgroundImage: NetworkImage(_finalImageLink),
//     );
//   }
// }

class NetworkImageCheck {
  Future<String> checkImageURL(String url, String defaultImage) async {
    final response = await http.head(Uri.parse(url));
    return response.statusCode == 200 ? url : defaultImage;
  }
}
