import 'package:flutter/material.dart';

class StringTileList extends StatelessWidget {
  final String title;
  final List<String> list;
  const StringTileList({super.key, required this.title, required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Text(
        title,
        textScaler: const TextScaler.linear(2.25),
        style: const TextStyle(color: Colors.black),
      ),
      ...list.map((step) {
        return ListTile(
          title: Text(
            "\t• $step",
            textScaler: const TextScaler.linear(1.5),
            style: const TextStyle(color: Colors.black),
          ),
        );
      })
    ]);
  }
}
