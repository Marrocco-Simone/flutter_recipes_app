import 'package:flutter/material.dart';
import 'package:flutter_recipes_app/models/recipe.dart';
import 'package:flutter_recipes_app/other/breakpoints.dart';
import 'package:flutter_recipes_app/widgets/recipe_tile.dart';

class RecipeInfo extends StatelessWidget {
  final Recipe recipe;
  final void Function(bool recipeIsFavourited) refresh;

  const RecipeInfo({super.key, required this.recipe, required this.refresh});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Flex(
      direction:
          size.width < Breakpoints.tablet ? Axis.vertical : Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Flexible(
            flex: 2,
            child: SizedBox(
                height: 400,
                child: AspectRatio(aspectRatio: 1 / 1, child: Placeholder()))),
        Flexible(
            flex: 1,
            child: SizedBox(
              width: 400,
              child: RecipeTile(
                r: recipe,
                refresh: refresh,
              ),
            ))
      ],
    );
  }
}
