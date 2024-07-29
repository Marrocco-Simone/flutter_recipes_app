import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_recipes_app/models/recipe.dart';
import 'package:flutter_recipes_app/providers/recipes_search_provider.dart';
import 'package:flutter_recipes_app/widgets/recipes_list.dart';

class SearchScreen extends ConsumerWidget {
  final String search;
  const SearchScreen({super.key, required this.search});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Recipe> recipes = ref.watch(recipeSearchProvider(search));
    final size = MediaQuery.of(context).size;

    return Center(
        child: SizedBox(
            width: size.width * 2 / 3,
            height: size.height,
            child: ListView(children: [
              Text(
                "Search results for $search",
                textScaler: const TextScaler.linear(2),
                style: const TextStyle(color: Colors.black),
              ),
              const Text(
                "Be careful with the search, it is for exact matches only!",
                textScaler: TextScaler.linear(1.5),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                  height: size.height,
                  child: RecipesList(
                    recipes: recipes,
                    refresh: (recipeId, recipeIsFavourited) => ref
                        .watch(recipeSearchProvider(search).notifier)
                        .fetchRecipes(),
                  ))
            ])));
  }
}
