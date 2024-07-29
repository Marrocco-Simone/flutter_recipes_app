import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_recipes_app/models/auth_user.dart';
import 'package:flutter_recipes_app/models/recipe.dart';
import 'package:flutter_recipes_app/providers/populate_recipe_doc.dart';

class RecipesAuthorProvider extends StateNotifier<List<Recipe>> {
  final AuthUser author;
  RecipesAuthorProvider({required this.author}) : super([]) {
    fetchRecipes();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void fetchRecipes() async {
    if (author.name == "") return;

    try {
      // ignore: avoid_print
      print("Fetching ${author.name} recipes");
      final recipesDocs = await _firestore
          .collection('recipes')
          .where('author', isEqualTo: author.id)
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

  void addRecipe(Recipe recipe) async {
    try {
      final authUdi = _auth.currentUser?.uid;
      if (authUdi != author.uuid || author.id != recipe.author.id) return;
      // ignore: avoid_print
      print("Adding recipe ${recipe.name}");
      final ref =
          await _firestore.collection('recipes').add(recipe.toFirestore());
      final doc = await ref.get();
      final data = doc.data()!;
      final id = doc.id;
      final newRecipe = await populateRecipeDoc(_firestore, data, id);
      state = [...state, newRecipe];
    } catch (e) {
      // ignore: avoid_print
      print("Error adding recipes: $e");
    }
  }

  void removeRecipe(Recipe recipe) async {
    try {
      final authUdi = _auth.currentUser?.uid;
      if (authUdi != author.uuid || author.id != recipe.author.id) return;
      // ignore: avoid_print
      print("Removing recipe ${recipe.name}");
      await _firestore.collection('recipes').doc(recipe.id).delete();
      state = state.where((element) => element.id != recipe.id).toList();
    } catch (e) {
      // ignore: avoid_print
      print("Error removing recipes: $e");
    }
  }

  void updateRecipe(Recipe newRecipe, Recipe oldRecipe) async {
    try {
      final authUdi = _auth.currentUser?.uid;
      if (authUdi != author.uuid ||
          author.id != newRecipe.author.id ||
          author.id != oldRecipe.author.id) return;
      // ignore: avoid_print
      print("Updating recipe ${newRecipe.name}");
      await _firestore
          .collection('recipes')
          .doc(oldRecipe.id)
          .update(newRecipe.toFirestore());
      state = state.map((e) => e.id == oldRecipe.id ? newRecipe : e).toList();
    } catch (e) {
      // ignore: avoid_print
      print("Error updating recipes: $e");
    }
  }
}

final recipesAuthorProvider =
    StateNotifierProvider.family<RecipesAuthorProvider, List<Recipe>, AuthUser>(
        (ref, author) => RecipesAuthorProvider(author: author));
