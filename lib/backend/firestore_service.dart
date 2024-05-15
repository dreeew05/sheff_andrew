import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // Get Recipe Collection
  final CollectionReference _recipes =
      FirebaseFirestore.instance.collection('recipes');

  // Read Data
  Stream<QuerySnapshot> getRecipeStream() {
    final recipeStream = _recipes.snapshots();
    return recipeStream;
  }
}
