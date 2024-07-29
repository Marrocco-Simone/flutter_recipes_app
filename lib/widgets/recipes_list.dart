import 'package:flutter/material.dart';
import 'package:flutter_recipes_app/models/recipe.dart';
import 'package:flutter_recipes_app/widgets/recipe_tile.dart';

class RecipesList extends StatefulWidget {
  final List<Recipe> recipes;
  final String? title;
  final void Function(String recipeId, bool recipeIsFavourited) refresh;
  final Future<bool> Function()? getNewRecipes;

  const RecipesList(
      {super.key,
      this.title,
      required this.recipes,
      required this.refresh,
      this.getNewRecipes});

  @override
  RecipeListState createState() => RecipeListState();
}

class RecipeListState extends State<RecipesList> {
  final _controller = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // Setup the listener.
    _controller.addListener(() {
      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        final getNewRecipes = widget.getNewRecipes;
        if (!isTop && getNewRecipes != null && !isLoading) {
          setState(() {
            isLoading = true;
          });
          getNewRecipes().then((ok) {
            setState(() {
              isLoading = false;
            });
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final recipes = widget.recipes;
    final title = widget.title;
    final refresh = widget.refresh;

    if (recipes.isEmpty) {
      return const Center(
          child: Text(
        'There are no recipes in this category...',
        textScaler: TextScaler.linear(2),
        style: TextStyle(color: Colors.black),
      ));
    }

    return ListView(
      controller: _controller,
      children: [
        title == null
            ? const SizedBox()
            : Text(
                title,
                textScaler: const TextScaler.linear(2),
                style: const TextStyle(color: Colors.black),
              ),
        ...recipes.map((r) => RecipeTile(
              r: r,
              refresh: (recipeIsFavourited) =>
                  refresh(r.id, recipeIsFavourited),
            )),
        isLoading
            ? const Center(
                child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ))
            : const SizedBox(),
      ],
    );
  }
}
