import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_recipes_app/providers/recipes_favourite_provider.dart';
import 'package:flutter_recipes_app/providers/user_provider.dart';
import 'package:flutter_recipes_app/screens/flexible_screen_wrapper.dart';
import 'package:flutter_recipes_app/styles/colors.dart';
import 'package:flutter_recipes_app/widgets/recipe_auth_list.dart';
import 'package:flutter_recipes_app/widgets/recipes_list.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUser = ref.watch(authUserProvider);
    if (authUser.name == "") {
      return const Center(
        child: Text(
          "You are not logged in",
          textScaler: TextScaler.linear(1.5),
          style: TextStyle(color: Colors.black),
        ),
      );
    }

    final favRecipes =
        ref.watch(recipesFavouriteProvider(authUser.favouritesRecipes));

    return FlexibleScreenWrapper(
      left: RecipesList(
        title: 'Favourited',
        recipes: favRecipes,
        refresh: (recipeId, recipeIsFavourited) => ref
            .watch(
                recipesFavouriteProvider(authUser.favouritesRecipes).notifier)
            .fetchRecipes(),
      ),
      right: const UserSettings(),
      bottom: const RecipeAuthList(),
    );
  }
}

class UserSettings extends StatelessWidget {
  const UserSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            width: 400,
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                    child: Container(
                        margin: const EdgeInsets.all(15),
                        child: const Text(
                          "User settings",
                          textScaler: TextScaler.linear(2),
                          style: TextStyle(color: Colors.black),
                        ))),
                Container(
                    margin: const EdgeInsets.all(15),
                    child: const LogOutButton()),
                Container(
                    margin: const EdgeInsets.all(15),
                    child: const ChangeUsername())
              ],
            )));
  }
}

class LogOutButton extends ConsumerWidget {
  const LogOutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: topBarButtonColor),
        onPressed: () async {
          // ignore: avoid_print
          print("Loggin out");
          FirebaseAuth.instance.signOut().then((_) {
            context.go("/");
            ref.watch(authUserProvider.notifier).resetUser();
          });
        },
        child: const Text(
          "Log out",
          textScaler: TextScaler.linear(1.5),
          style: TextStyle(color: Colors.black),
        ));
  }
}

class ChangeUsername extends ConsumerWidget {
  const ChangeUsername({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    changeName(String name) {
      ref.watch(authUserProvider.notifier).changeName(name);
      controller.clear();
    }

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: "Change your username",
        border: const OutlineInputBorder(),
        icon: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
                onTap: () => changeName(controller.text),
                child: const Icon(
                  Icons.manage_accounts,
                  color: Colors.black,
                ))),
      ),
      onSubmitted: (value) => changeName(value),
    );
  }
}
