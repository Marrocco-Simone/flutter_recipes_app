import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_recipes_app/screens/account_screen.dart';
import 'package:flutter_recipes_app/screens/category_screen.dart';
import 'package:flutter_recipes_app/screens/footer.dart';
import 'package:flutter_recipes_app/screens/header.dart';
import 'package:flutter_recipes_app/screens/main_screen.dart';
import 'package:flutter_recipes_app/screens/recipe_screen.dart';
import 'package:flutter_recipes_app/screens/search_screen.dart';
import 'package:flutter_recipes_app/styles/colors.dart';

class RouteWrapper extends StatelessWidget {
  final Widget child;

  const RouteWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      appBar: const Header(),
      bottomNavigationBar: const Footer(),
      backgroundColor: homePageColor,
    );
  }
}

getRouter() {
  final router = GoRouter(
    routes: [
      GoRoute(
          path: '/',
          builder: (context, state) => const RouteWrapper(
                child: MainScreen(),
              )),
      GoRoute(
          path: '/categories',
          builder: (context, state) => const RouteWrapper(
                child: CategoriesScreen(categoryId: ""),
              )),
      GoRoute(
          path: '/categories/:categoryId',
          builder: (context, state) => RouteWrapper(
                child: CategoriesScreen(
                    categoryId: state.pathParameters['categoryId']!),
              )),
      GoRoute(
          path: '/recipe/:recipeId',
          builder: (context, state) => RouteWrapper(
                child:
                    RecipeScreen(recipeId: state.pathParameters['recipeId']!),
              )),
      GoRoute(
          path: '/search/:search',
          builder: (context, state) => RouteWrapper(
                child: SearchScreen(search: state.pathParameters['search']!),
              )),
      GoRoute(
          path: '/account',
          builder: (context, state) => const RouteWrapper(
                child: AccountScreen(),
              )),
    ],
  );

  return router;
}
