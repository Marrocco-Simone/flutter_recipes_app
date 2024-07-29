import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_recipes_app/models/category.dart';
import 'package:flutter_recipes_app/models/recipe.dart';
import 'package:flutter_recipes_app/other/breakpoints.dart';
import 'package:flutter_recipes_app/providers/categories_provider.dart';
import 'package:flutter_recipes_app/providers/recipes_category_provider.dart';
import 'package:flutter_recipes_app/screens/flexible_screen_wrapper.dart';
import 'package:flutter_recipes_app/styles/colors.dart';
import 'package:flutter_recipes_app/widgets/recipes_list.dart';

class CategoriesScreen extends StatelessWidget {
  final String categoryId;

  const CategoriesScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (size.width < Breakpoints.mobile) {
      return CategoriesList(categoryId: categoryId);
    }

    return FlexibleScreenWrapper(
        right: CategoriesList(categoryId: categoryId),
        left: RecipesCategoryList(categoryId: categoryId));
  }
}

class CategoryCard extends StatelessWidget {
  final Category c;
  final String categoryId;

  const CategoryCard({required this.c, required this.categoryId, super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(children: [
      Container(
          margin: const EdgeInsets.all(10),
          color: categoryId == c.id ? topBarButtonColor : topBarColor,
          child: ListTile(
              title: Text(
                c.name,
                textScaler: const TextScaler.linear(1.5),
                style: const TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                "Recipes: ${c.nRecipes}",
                textScaler: const TextScaler.linear(1.5),
                style: const TextStyle(color: Colors.black),
              ),
              // selected: categoryId == c.id,
              onTap: () => categoryId == c.id
                  ? context.go('/categories')
                  : context.go('/categories/${c.id}'),
              leading: const AspectRatio(
                aspectRatio: 1 / 1,
                child: Placeholder(),
              ))),
      size.width < Breakpoints.mobile && categoryId == c.id
          ? Container(
              margin: const EdgeInsets.fromLTRB(40, 0, 10, 0),
              height: size.height * 0.5,
              child: RecipesCategoryList(
                categoryId: categoryId,
              ))
          : const SizedBox()
    ]);
  }
}

class CategoriesList extends ConsumerWidget {
  final String categoryId;

  const CategoriesList({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);

    return ListView(
      children: categories
          .map((c) => CategoryCard(
                c: c,
                categoryId: categoryId,
              ))
          .toList(),
    );
  }
}

class RecipesCategoryList extends ConsumerWidget {
  final String categoryId;

  const RecipesCategoryList({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    if (categoryId == "") {
      return SizedBox(
          width: size.width,
          // height: size.height,
          child: const Center(
              child: Text(
            'Press a category to see recipes...',
            textScaler: TextScaler.linear(3),
            style: TextStyle(color: Colors.black),
          )));
    }

    final List<Recipe> recipes = ref.watch(recipeCategoryProvider(categoryId));
    return RecipesList(
        recipes: recipes,
        refresh: (recipeId, recipeIsFavourited) => ref
            .watch(recipeCategoryProvider(categoryId).notifier)
            .signFavourite(recipeId, recipeIsFavourited),
        getNewRecipes: () => ref
            .watch(recipeCategoryProvider(categoryId).notifier)
            .fetchRecipes(pStart: recipes.length));
  }
}
