/*
  Author: Glen Andrew C. Bulaong
  Purpose of this file: Fetch from Edamam API to Firebase
*/

import 'dart:convert';

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

  Future<http.Response> queryRequest(String query) {
    query = query.replaceAll(' ', '%20');
    return http.get(
      Uri.parse('''
        https://api.edamam.com/api/recipes/v2
        ?type=public
        &q=$query
        &app_id=${getAppId()}
        &app_key=${getAppKey()}
      '''
          .replaceAll('\n', '')
          .replaceAll(' ', '')),
    );
  }

  Future<Map<String, dynamic>> fetchRecipes(String recipeName) async {
    final apiClient = FetchFromApi();
    final response = await apiClient.queryRequest(recipeName);
    List<Map<String, dynamic>> recipeList = [];
    Map<String, dynamic> dataToBeReturned = {};

    // Connection was successful
    if (response.statusCode == 200) {
      // Process the data
      var jsonData = jsonDecode(response.body);
      // print(jsonData['hits'].isEmpty);

      if (jsonData['hits'].isEmpty) {
        dataToBeReturned = {
          "status": "no_results",
        };
        return dataToBeReturned;
      }

      for (var recipe in jsonData["hits"]) {
        recipeList.add({
          "label": recipe["recipe"]["label"],
          "image": recipe["recipe"]["image"],
          "dietLabels": recipe["recipe"]["dietLabels"],
          "healthLabels": recipe["recipe"]["healthLabels"],
          "cautions": recipe["recipe"]["cautions"],
          "ingredients": recipe["recipe"]["ingredients"],
          "calories": recipe["recipe"]["calories"],
          "totalTime": recipe["recipe"]["totalTime"],
          "cuisineType": recipe["recipe"]["cuisineType"],
          "mealType": recipe["recipe"]["mealType"],
          "totalNutrients": recipe["recipe"]["totalNutrients"],
          "tags": recipe["recipe"]["tags"],
        });
        dataToBeReturned = {
          "recipeList": recipeList,
          "status": "success",
        };
      }
    } else {
      // Connection failed
      dataToBeReturned = {
        "status": "error",
      };
    }
    return dataToBeReturned;
  }
}

// Example usage
void main() async {
  final apiClient = FetchFromApi();
  final response = await apiClient.fetchRecipes("Margarita");
  print(response);
}
