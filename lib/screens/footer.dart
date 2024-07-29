import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_recipes_app/styles/colors.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: topBarColor,
        height: 70,
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            const Expanded(
                child: Text(
              "Made by Marrocco Simone",
              textScaler: TextScaler.linear(1.5),
              style: TextStyle(color: Colors.black),
            )),
            TextButton(
                onPressed: () => context.go('/'),
                child: const Text(
                  "Main page",
                  textScaler: TextScaler.linear(1.5),
                  style: TextStyle(color: Colors.black),
                )),
            TextButton(
                onPressed: () => context.go('/categories'),
                child: const Text(
                  "All categories",
                  textScaler: TextScaler.linear(1.5),
                  style: TextStyle(color: Colors.black),
                )),
          ],
        ));
  }
}
