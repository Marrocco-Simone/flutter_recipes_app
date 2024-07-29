import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_recipes_app/models/recipe.dart';
import 'package:flutter_recipes_app/providers/user_provider.dart';
import 'package:flutter_recipes_app/styles/colors.dart';

class RecipeTile extends ConsumerWidget {
  final Recipe r;
  final void Function(bool recipeIsFavourited) refresh;
  const RecipeTile({super.key, required this.r, required this.refresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final authUser = ref.watch(authUserProvider);
    final recipeIsFavourited = authUser.favouritesRecipes.contains(r.id);

    saveToFavourite() {
      if (authUser.name == "") return;
      ref.watch(authUserProvider.notifier).changeFavouriteRecipe(r.id);

      try {
        firestore.collection('recipes').doc(r.id).update({
          'nFavourites': FieldValue.increment(recipeIsFavourited ? -1 : 1)
        }).then((_) {
          refresh(recipeIsFavourited);
        });
      } catch (e) {
        // ignore: avoid_print
        print("Error updating recipe: $e");
      }
    }

    return Container(
        color: buttonColor,
        margin: const EdgeInsets.all(10),
        child: ListTile(
          title: Text(
            r.name,
            textScaler: const TextScaler.linear(1.5),
            style: const TextStyle(color: Colors.black),
          ),
          subtitle: Text(
            "Author: ${r.author.name}\nFavourited by: ${r.nFavourites}",
            textScaler: const TextScaler.linear(1.5),
            style: const TextStyle(color: Colors.black),
          ),
          isThreeLine: true,
          onTap: () => context.go('/recipe/${r.id}'),
          trailing: GestureDetector(
              onTap: saveToFavourite,
              child: recipeIsFavourited
                  ? const Icon(
                      Icons.star,
                      color: Colors.black,
                    )
                  : const Icon(
                      Icons.star_border,
                      color: Colors.black,
                    )),
        ));
  }
}
