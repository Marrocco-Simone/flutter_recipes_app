import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_recipes_app/models/category.dart';
import 'package:flutter_recipes_app/providers/categories_provider.dart';
import 'package:flutter_recipes_app/providers/recipe_best_provider.dart';
import 'package:flutter_recipes_app/screens/flexible_screen_wrapper.dart';
import 'package:flutter_recipes_app/styles/colors.dart';
import 'package:flutter_recipes_app/widgets/recipe_info.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FlexibleScreenWrapper(
        left: ShowBestRecipe(), right: ShowCategories());
  }
}

class ShowBestRecipe extends ConsumerWidget {
  const ShowBestRecipe({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipe = ref.watch(recipeBestProvider);
    if (recipe == null) {
      return const Center(
          child: Text(
        'No recipe found...',
        textScaler: TextScaler.linear(3),
        style: TextStyle(color: Colors.black),
      ));
    }
    return RecipeInfo(
      recipe: recipe,
      refresh: (recipeIsFavourited) =>
          ref.watch(recipeBestProvider.notifier).fetchRecipes(),
    );
  }
}

class ShowCategories extends ConsumerWidget {
  const ShowCategories({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);

    if (categories.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(
        child: SizedBox(
            width: 400,
            child: ListView(
              children: [
                ...categories.sublist(0, 3).map((c) => CategoryButton(c: c)),
                Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: TextButton.icon(
                        style: TextButton.styleFrom(
                          backgroundColor: topBarButtonColor,
                          padding: const EdgeInsets.all(15),
                        ),
                        onPressed: () => context.go('/categories'),
                        label: const Text(
                          'See all categories',
                          textScaler: TextScaler.linear(1.5),
                          style: TextStyle(color: Colors.black),
                        ),
                        icon: const Icon(
                          Icons.menu_open,
                          color: Colors.black,
                        )))
              ],
            )));
  }
}

class CategoryButton extends StatelessWidget {
  final Category c;
  const CategoryButton({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: TextButton.icon(
            style: TextButton.styleFrom(
              backgroundColor: topBarButtonColor,
              padding: const EdgeInsets.all(15),
            ),
            onPressed: () => context.go('/categories/${c.id}'),
            label: Text(
              "${c.name} (${c.nRecipes})",
              textScaler: const TextScaler.linear(1.5),
              style: const TextStyle(color: Colors.black),
            ),
            icon: const Icon(
              Icons.arrow_circle_right,
              color: Colors.black,
            )));
  }
}
