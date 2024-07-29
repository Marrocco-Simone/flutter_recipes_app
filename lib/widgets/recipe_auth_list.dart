import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_recipes_app/models/category.dart';
import 'package:flutter_recipes_app/models/recipe.dart';
import 'package:flutter_recipes_app/other/breakpoints.dart';
import 'package:flutter_recipes_app/other/capitalize.dart';
import 'package:flutter_recipes_app/providers/categories_provider.dart';
import 'package:flutter_recipes_app/providers/recipes_user_provider.dart';
import 'package:flutter_recipes_app/providers/user_provider.dart';
import 'package:flutter_recipes_app/styles/colors.dart';

class RecipeAuthList extends ConsumerWidget {
  const RecipeAuthList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final authUser = ref.watch(authUserProvider);
    final selfRecipes = ref.watch(recipesAuthorProvider(authUser));

    openForm({Recipe? startingRecipe}) {
      submitRecipe(Recipe recipe) {
        if (startingRecipe == null) {
          ref.watch(recipesAuthorProvider(authUser).notifier).addRecipe(recipe);
          ref
              .watch(categoriesProvider.notifier)
              .addRecipeCount(recipe.category);
        } else {
          ref
              .watch(recipesAuthorProvider(authUser).notifier)
              .updateRecipe(recipe, startingRecipe);
          if (recipe.category != startingRecipe.category) {
            ref
                .watch(categoriesProvider.notifier)
                .updateRecipeCount(startingRecipe.category, recipe.category);
          }
        }
      }

      showDialog(
          context: context,
          builder: (context) {
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                child: Container(
                    width: size.width < Breakpoints.tablet
                        ? size.width * 0.8
                        : size.width * 0.4,
                    height: size.height * 0.75,
                    padding: const EdgeInsets.all(20),
                    child: RecipeForm(
                        startingRecipe: startingRecipe,
                        submitRecipe: submitRecipe,
                        goBack: () {
                          Navigator.of(context).pop();
                        })));
          });
    }

    if (authUser.name == "") {
      return const Center(
          child: Text(
        "You need to be logged in to see your recipes",
        textScaler: TextScaler.linear(2),
        style: TextStyle(color: Colors.black),
      ));
    }
    if (selfRecipes.isEmpty) {
      return Center(
        child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: topBarButtonColor, iconColor: Colors.black),
            onPressed: () => openForm(),
            label: const Text(
              "Create your first recipe",
              textScaler: TextScaler.linear(2),
              style: TextStyle(color: Colors.black),
            ),
            icon: const Icon(
              Icons.add,
              color: Colors.black,
            )),
      );
    }

    return ListView(
      children: [
        ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: topBarButtonColor, iconColor: Colors.black),
            onPressed: () => openForm(),
            label: const Text(
              "Add new recipe",
              textScaler: TextScaler.linear(1.5),
              style: TextStyle(color: Colors.black),
            ),
            icon: const Icon(
              Icons.add,
              color: Colors.black,
            )),
        ...selfRecipes.map((r) => Container(
              color: buttonColor,
              margin: const EdgeInsets.all(10),
              child: ListTile(
                  title: Text(
                    r.name,
                    textScaler: const TextScaler.linear(1.5),
                    style: const TextStyle(color: Colors.black),
                  ),
                  subtitle: Text(
                    "Favourited by: ${r.nFavourites}",
                    textScaler: const TextScaler.linear(1.5),
                    style: const TextStyle(color: Colors.black),
                  ),
                  trailing: SizedBox(
                    width: size.width < Breakpoints.mobile ? 210 : 250,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: topBarButtonColor,
                                iconColor: Colors.black),
                            onPressed: () => openForm(startingRecipe: r),
                            label: const Text(
                              "Edit",
                              style: TextStyle(color: Colors.black),
                            ),
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.black,
                            )),
                        RemoveRecipeButton(
                          recipeName: r.name,
                          remove: () {
                            ref
                                .watch(recipesAuthorProvider(authUser).notifier)
                                .removeRecipe(r);
                            ref
                                .watch(categoriesProvider.notifier)
                                .removeRecipeCount(r.category);
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ),
                  )),
            ))
      ],
    );
  }
}

class RemoveRecipeButton extends StatelessWidget {
  final String recipeName;
  final void Function() remove;
  const RemoveRecipeButton(
      {super.key, required this.recipeName, required this.remove});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            backgroundColor: topBarButtonColor, iconColor: Colors.black),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text(
                      'Are you sure you want to delete the recipe $recipeName?',
                      style: const TextStyle(color: Colors.black),
                    ),
                    actions: [
                      ElevatedButton(
                          onPressed: remove,
                          child: const Text(
                            "Yes, delete",
                            textScaler: TextScaler.linear(1.5),
                            style: TextStyle(color: Colors.black),
                          )),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "No, cancel",
                            textScaler: TextScaler.linear(1.5),
                            style: TextStyle(color: Colors.black),
                          )),
                    ],
                  ));
        },
        label: const Text(
          "Delete",
          style: TextStyle(color: Colors.black),
        ),
        icon: const Icon(
          Icons.delete,
          color: Colors.black,
        ));
  }
}

class RecipeForm extends ConsumerStatefulWidget {
  final Recipe? startingRecipe;
  final void Function(Recipe recipe) submitRecipe;
  final void Function() goBack;
  const RecipeForm(
      {super.key,
      this.startingRecipe,
      required this.submitRecipe,
      required this.goBack});

  @override
  RecipeFormState createState() {
    return RecipeFormState();
  }
}

class RecipeFormState extends ConsumerState<RecipeForm> {
  final _formKey = GlobalKey<FormState>();
  Category? _selectedCategory;
  final nameController = TextEditingController();
  final ingredientsController = TextEditingController();
  final stepsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedCategory = widget.startingRecipe?.category;
      nameController.text = widget.startingRecipe?.name ?? "";
      ingredientsController.text =
          widget.startingRecipe?.ingredients.join(";") ?? "";
      stepsController.text = widget.startingRecipe?.steps.join(";") ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final authUser = ref.watch(authUserProvider);
    final categories = ref.watch(categoriesProvider);
    final categoriesDropDownList = categories
        .map((c) => DropdownMenuItem(
              value: c,
              child: Text(
                c.name,
                style: const TextStyle(color: Colors.black),
              ),
            ))
        .toList();

    validator(String? value) {
      if (value == null || value.trim().isEmpty) {
        return 'This field is required';
      }
      return null;
    }

    transformToList(String s) {
      return s
          .split(";")
          .map((ss) => ss.trim().capitalize())
          .where((ss) => ss != "")
          .toList();
    }

    submit() {
      if (_formKey.currentState!.validate()) {
        final name = nameController.text.trim().capitalize();
        final ingredients = transformToList(ingredientsController.text);
        final steps = transformToList(stepsController.text);
        final newRecipe = Recipe(
            id: widget.startingRecipe?.id ?? "",
            name: name,
            category: _selectedCategory!,
            ingredients: ingredients,
            steps: steps,
            author: authUser,
            nFavourites: widget.startingRecipe?.nFavourites ?? 0);
        widget.submitRecipe(newRecipe);
        widget.goBack();
      }
    }

    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                  labelText: 'Name', hintText: 'Name of the recipe'),
              validator: validator,
              inputFormatters: [CapitalizeTextFormatter()],
            ),
            TextFormField(
              controller: ingredientsController,
              decoration: const InputDecoration(
                  labelText: 'ingredients', hintText: 'Separate them with ";"'),
              validator: validator,
              inputFormatters: [CapitalizeTextFormatter()],
            ),
            TextFormField(
              controller: stepsController,
              decoration: const InputDecoration(
                  labelText: 'Steps', hintText: 'Separate them with ";"'),
              validator: validator,
              inputFormatters: [CapitalizeTextFormatter()],
            ),
            DropdownButtonFormField<Category>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  hintText: 'Select a category',
                ),
                onChanged: (Category? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Choose a category';
                  }
                  return null;
                },
                items: categoriesDropDownList),
            ElevatedButton(
                onPressed: submit,
                child: const Text(
                  'Submit',
                  textScaler: TextScaler.linear(1.5),
                  style: TextStyle(color: Colors.black),
                )),
            ElevatedButton(
                onPressed: widget.goBack,
                child: const Text(
                  'Cancel',
                  textScaler: TextScaler.linear(1.5),
                  style: TextStyle(color: Colors.black),
                ))
          ],
        ));
  }
}
