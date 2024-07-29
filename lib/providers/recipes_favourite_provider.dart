import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_recipes_app/models/recipe.dart';
import 'package:flutter_recipes_app/providers/populate_recipe_doc.dart';

class RecipesFavouriteProvider extends StateNotifier<List<Recipe>> {
  final List<String> favourites;
  RecipesFavouriteProvider({required this.favourites}) : super([]) {
    fetchRecipes();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void fetchRecipes() async {
    if (favourites.isEmpty) return;

    try {
      // ignore: avoid_print
      print("Fetching favourite recipes");
      final recipesDocs = await _firestore
          .collection('recipes')
          .where('__name__', whereIn: favourites)
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

final recipesFavouriteProvider = StateNotifierProvider.family<
        RecipesFavouriteProvider, List<Recipe>, List<String>>(
    (ref, favourites) => RecipesFavouriteProvider(favourites: favourites));
