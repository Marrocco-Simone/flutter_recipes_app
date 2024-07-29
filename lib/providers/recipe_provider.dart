import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_recipes_app/models/recipe.dart';
import 'package:flutter_recipes_app/providers/populate_recipe_doc.dart';

class RecipeProvider extends StateNotifier<Recipe?> {
  final String recipeId;
  RecipeProvider({required this.recipeId}) : super(null) {
    fetchRecipes();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void fetchRecipes() async {
    if (recipeId == "") return;

    try {
      // ignore: avoid_print
      print("Fetching recipe $recipeId");
      final recipesDoc =
          await _firestore.collection('recipes').doc(recipeId).get();

      final recipe =
          await populateRecipeDoc(_firestore, recipesDoc.data()!, recipeId);

      state = recipe;
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching recipes: $e");
    }
  }
}

final recipeProvider =
    StateNotifierProvider.family<RecipeProvider, Recipe?, String>(
        (ref, recipeId) => RecipeProvider(recipeId: recipeId));
