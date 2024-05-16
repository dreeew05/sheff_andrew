/*
  Author: Glen Andrew C. Bulaong
  Purpose of this file: Fetch from Edamam API to Firebase
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class FetchFromApi {
  final String _appID = '9aa911ef';
  final String _appKey = '73fab8b9341849a9541bd719b39b3ecb';

  String getAppId() {
    return _appID;
  }

  String getAppKey() {
    return _appKey;
  }

  Future<http.Response> fetchRecipes(String query) {
    return http.get(
      Uri.parse('''
        https://api.edamam.com/api/recipes/v2
        ?type=public
        &q=Chicken%20Margarita
        &app_id=${getAppId()}
        &app_key=${getAppKey()}
      '''
          .replaceAll('\n', '')
          .replaceAll(' ', '')),
    );
  }

  Future<QuerySnapshot<Object?>> getRecipes() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference recipesCollection = firestore.collection('recipes');
    return await recipesCollection.get();
  }
}

void main() async {
  final apiClient = FetchFromApi();
  // final response = await apiClient.fetchRecipes("Pasta");

  print(apiClient.getRecipes());

  // Handle the response here
  // if (response.statusCode == 200) {
  //   // Process the data (e.g., parse JSON)
  //   print(response.body);
  // } else {
  //   // Handle error
  //   print('Error: ${response.statusCode}');
  // }
}
