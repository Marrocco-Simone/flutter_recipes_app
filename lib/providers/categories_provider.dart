import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_recipes_app/models/category.dart';

class CategoriesProvider extends StateNotifier<List<Category>> {
  CategoriesProvider() : super([]) {
    _fetchCategories();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _fetchCategories() async {
    try {
      // ignore: avoid_print
      print("Fetching categories");
      final categoriesDocs = await _firestore
          .collection('categories')
          .orderBy('nRecipes', descending: true)
          .get();
      final categories = categoriesDocs.docs
          .map((doc) => Category.fromFirestore(doc.data(), doc.id))
          .toList();
      state = categories;
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching categories: $e");
    }
  }

  void addRecipeCount(Category c) async {
    try {
      // ignore: avoid_print
      print("Adding recipe count to ${c.name}");
      await _firestore
          .collection('categories')
          .doc(c.id)
          .update({'nRecipes': FieldValue.increment(1)});
      _fetchCategories();
    } catch (e) {
      // ignore: avoid_print
      print("Error adding recipe count to ${c.name}: $e");
    }
  }

  void removeRecipeCount(Category c) async {
    try {
      // ignore: avoid_print
      print("Removing recipe count to ${c.name}");
      await _firestore
          .collection('categories')
          .doc(c.id)
          .update({'nRecipes': FieldValue.increment(-1)});
      _fetchCategories();
    } catch (e) {
      // ignore: avoid_print
      print("Error removing recipe count to ${c.name}: $e");
    }
  }

  void updateRecipeCount(Category old, Category newC) async {
    try {
      // ignore: avoid_print
      print("Updating recipe count from ${old.name} to ${newC.name}");
      await _firestore
          .collection('categories')
          .doc(old.id)
          .update({'nRecipes': FieldValue.increment(-1)});
      await _firestore
          .collection('categories')
          .doc(newC.id)
          .update({'nRecipes': FieldValue.increment(1)});
      _fetchCategories();
    } catch (e) {
      // ignore: avoid_print
      print("Error updating recipe count from ${old.name} to ${newC.name}: $e");
    }
  }
}

final categoriesProvider =
    StateNotifierProvider<CategoriesProvider, List<Category>>(
        (ref) => CategoriesProvider());
