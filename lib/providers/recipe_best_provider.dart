import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_recipes_app/models/recipe.dart';
import 'package:flutter_recipes_app/providers/populate_recipe_doc.dart';

class RecipeBestProvider extends StateNotifier<Recipe?> {
  RecipeBestProvider() : super(null) {
    fetchRecipes();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void fetchRecipes() async {
    try {
      // ignore: avoid_print
      print("Fetching best recipe");
      final recipesDocs = await _firestore
          .collection('recipes')
          .orderBy('nFavourites', descending: true)
          .limit(1)
          .get();

      final doc = recipesDocs.docs[0];
      final data = doc.data();
      final id = doc.id;
      final recipe = await populateRecipeDoc(_firestore, data, id);

      state = recipe;
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching recipes: $e");
    }
  }
}

final recipeBestProvider = StateNotifierProvider<RecipeBestProvider, Recipe?>(
    (ref) => RecipeBestProvider());
