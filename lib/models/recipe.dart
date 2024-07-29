import 'package:flutter_recipes_app/models/auth_user.dart';
import 'package:flutter_recipes_app/models/category.dart';

class Recipe implements Comparable {
  final String id;
  final String name;
  final Category category;
  final AuthUser author;
  final int nFavourites;
  final List<String> ingredients;
  final List<String> steps;

  Recipe(
      {required this.id,
      required this.name,
      required this.category,
      required this.ingredients,
      required this.steps,
      required this.author,
      required this.nFavourites});

  factory Recipe.fromFirestore(Map<String, dynamic> data, String id) {
    final ingredientsData = data['ingredients'] as List<dynamic>;
    final stepsData = data['steps'] as List<dynamic>;

    final List<String> ingredients =
        ingredientsData.map((e) => e.toString()).toList();
    final List<String> steps = stepsData.map((e) => e.toString()).toList();

    return Recipe(
        id: id,
        name: data['name'],
        category: data['category'],
        ingredients: ingredients,
        steps: steps,
        author: data['author'],
        nFavourites: data['nFavourites']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'category': category.id,
      'ingredients': ingredients,
      'steps': steps,
      'author': author.id,
      'nFavourites': nFavourites
    };
  }

  @override
  int compareTo(other) {
    return other.nFavourites.compareTo(nFavourites);
  }
}
