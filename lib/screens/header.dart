import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_recipes_app/other/breakpoints.dart';
import 'package:flutter_recipes_app/other/capitalize.dart';
import 'package:flutter_recipes_app/styles/colors.dart';
import 'package:flutter_recipes_app/widgets/login_button.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(120);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    preferredSize;

    if (size.width < Breakpoints.mobile) {
      return Container(
          color: topBarColor,
          width: preferredSize.width,
          height: preferredSize.height,
          child: const Row(
            children: [
              Column(children: [
                MainTitle(),
                SearchBar(),
              ]),
              LoginButton(),
            ],
          ));
    }

    return Container(
        color: topBarColor,
        width: preferredSize.width,
        height: preferredSize.height,
        padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
        child: const Row(
          children: [MainTitle(), SearchBar(), LoginButton()],
        ));
  }
}

class MainTitle extends StatelessWidget {
  const MainTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
                onTap: () => context.go("/"),
                child: const Text(
                  'Yummy Recipes!',
                  textScaler: TextScaler.linear(2),
                  style: TextStyle(color: Colors.black),
                ))));
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return SizedBox(
        width: 250,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Search for a recipe",
            border: const OutlineInputBorder(),
            icon: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                    onTap: () => context
                        .go("/search/${controller.text.trim().capitalize()}"),
                    child: const Icon(
                      Icons.search,
                      color: Colors.black,
                    ))),
          ),
          inputFormatters: [CapitalizeTextFormatter()],
          onSubmitted: (value) =>
              context.go("/search/${value.trim().capitalize()}"),
        ));
  }
}
