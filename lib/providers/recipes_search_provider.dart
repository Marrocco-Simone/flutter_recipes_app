import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_recipes_app/models/recipe.dart';
import 'package:flutter_recipes_app/other/capitalize.dart';
import 'package:flutter_recipes_app/providers/populate_recipe_doc.dart';

class RecipesSearchProvider extends StateNotifier<List<Recipe>> {
  final String search;
  RecipesSearchProvider({required this.search}) : super([]) {
    fetchRecipes();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void fetchRecipes() async {
    if (search == "") return;

    try {
      // ignore: avoid_print
      print("Fetching recipes with seatch filter $search");
      final recipesDocs = await _firestore
          .collection('recipes')
          .where('name', isEqualTo: search.trim().capitalize())
          .orderBy('nFavourites', descending: true)
          .get();

      List<Recipe> recipes = [];
      for (var doc in recipesDocs.docs) {
        final data = doc.data();
        final id = doc.id;
        final recipe = await populateRecipeDoc(_firestore, data, id);
        recipes.add(recipe);
      }
      state = recipes;
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching recipes: $e");
    }
  }
}

final recipeSearchProvider =
    StateNotifierProvider.family<RecipesSearchProvider, List<Recipe>, String>(
        (ref, search) => RecipesSearchProvider(search: search));
