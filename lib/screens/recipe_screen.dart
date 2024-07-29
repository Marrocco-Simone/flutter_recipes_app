import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_recipes_app/providers/recipe_provider.dart';
import 'package:flutter_recipes_app/screens/flexible_screen_wrapper.dart';
import 'package:flutter_recipes_app/widgets/recipe_info.dart';
import 'package:flutter_recipes_app/widgets/string_tile_list.dart';

class RecipeScreen extends ConsumerWidget {
  final String recipeId;
  const RecipeScreen({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipe = ref.watch(recipeProvider(recipeId));
    if (recipe == null) {
      return const Center(
          child: Text(
        "Recipe not found",
        textScaler: TextScaler.linear(3),
        style: TextStyle(color: Colors.black),
      ));
    }

    return FlexibleScreenWrapper(
      left: RecipeInfo(
        recipe: recipe,
        refresh: (recipeIsFavourited) =>
            ref.watch(recipeProvider(recipeId).notifier).fetchRecipes(),
      ),
      right: StringTileList(title: "Ingredients", list: recipe.ingredients),
      bottom: StringTileList(title: "Steps", list: recipe.steps),
    );
  }
}
