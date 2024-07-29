import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_recipes_app/models/recipe.dart';
import 'package:flutter_recipes_app/providers/populate_recipe_doc.dart';

class RecipesCategoryProvider extends StateNotifier<List<Recipe>> {
  final String categoryId;
  RecipesCategoryProvider({required this.categoryId}) : super([]) {
    fetchRecipes();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> fetchRecipes({pStart = 0}) async {
    const pLimit = 20;
    final pEnd = pStart + pLimit;

    if (categoryId == "") return true;

    try {
      // ignore: avoid_print
      print("Fetching recipes of category $categoryId from $pStart to $pEnd");
      final QuerySnapshot<Map<String, dynamic>> recipesDocs;
      if (pStart == 0) {
        recipesDocs = await _firestore
            .collection('recipes')
            .where('category', isEqualTo: categoryId)
            .orderBy('nFavourites', descending: true)
            .limit(pLimit)
            .get();
      } else {
        final lastVisible =
            await _firestore.collection('recipes').doc(state.last.id).get();

        recipesDocs = await _firestore
            .collection('recipes')
            .where('category', isEqualTo: categoryId)
            .orderBy('nFavourites', descending: true)
            .startAfterDocument(lastVisible)
            .limit(pLimit)
            .get();
      }

      List<Recipe> recipes = [];
      for (var doc in recipesDocs.docs) {
        final data = doc.data();
        final id = doc.id;
        final recipe = await populateRecipeDoc(_firestore, data, id);
        recipes.add(recipe);
      }
      // ignore: avoid_print
      print("Recipes fetched: ${recipes.length}");
      state = [
        ...state,
        ...recipes,
      ];
      return true;
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching recipes: $e");
      return false;
    }
  }

  void signFavourite(String recipeId, bool recipeIsFavourited) {
    // ignore: avoid_print
    print("Signing new favourite for recipe $recipeId");
    final recipe = state.firstWhere((r) => r.id == recipeId);
    final newRecipe = Recipe(
      id: recipe.id,
      name: recipe.name,
      category: recipe.category,
      ingredients: recipe.ingredients,
      steps: recipe.steps,
      author: recipe.author,
      nFavourites:
          recipeIsFavourited ? recipe.nFavourites - 1 : recipe.nFavourites + 1,
    );
    state.remove(recipe);
    state = [newRecipe, ...state];
    state.sort((a, b) => b.nFavourites.compareTo(a.nFavourites));
  }
}

final recipeCategoryProvider =
    StateNotifierProvider.family<RecipesCategoryProvider, List<Recipe>, String>(
        (ref, categoryId) => RecipesCategoryProvider(categoryId: categoryId));
