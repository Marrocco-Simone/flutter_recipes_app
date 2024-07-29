import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_recipes_app/models/auth_user.dart';
import 'package:flutter_recipes_app/models/category.dart';
import 'package:flutter_recipes_app/models/recipe.dart';

/// ! higly inefficient, but firebase does not have populate or join
Future<Recipe> populateRecipeDoc(
    FirebaseFirestore firestore, Map<String, dynamic> data, String id) async {
  final authorDoc =
      await firestore.collection('users').doc(data['author']).get();
  data['author'] = AuthUser.fromFirestore(authorDoc.data()!, authorDoc.id);
  final categoryDoc =
      await firestore.collection('categories').doc(data['category']).get();
  data['category'] =
      Category.fromFirestore(categoryDoc.data()!, categoryDoc.id);

  final recipe = Recipe.fromFirestore(data, id);
  return recipe;
}
