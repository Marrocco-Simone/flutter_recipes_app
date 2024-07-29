import 'package:flutter/material.dart';
import 'package:flutter_recipes_app/other/breakpoints.dart';
import 'package:flutter_recipes_app/styles/colors.dart';

class FlexibleScreenWrapper extends StatelessWidget {
  final Widget left;
  final Widget right;
  final Widget? bottom;
  const FlexibleScreenWrapper(
      {super.key, required this.left, required this.right, this.bottom});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (size.width < Breakpoints.mobile) {
      return Container(
          width: size.width,
          color: homePageColor,
          child: ListView(
            children: [
              Container(
                  margin: const EdgeInsets.all(10),
                  height: size.height * 2 / 3,
                  child: left),
              Container(
                  margin: const EdgeInsets.all(10),
                  height: size.height * 2 / 3,
                  child: right),
              Container(
                  margin: const EdgeInsets.all(10),
                  height: size.height * 2 / 3,
                  child: bottom == null ? const SizedBox() : bottom!)
            ],
          ));
    }

    return Container(
        width: size.width,
        color: homePageColor,
        child: Column(
          children: [
            Flexible(
                flex: 3,
                child: TopRowWrapper(
                  left: left,
                  right: right,
                )),
            Flexible(
                flex: bottom == null ? 0 : 2,
                child: Container(
                    padding: const EdgeInsets.all(20),
                    width: size.width < Breakpoints.tablet
                        ? size.width
                        : size.width / 2,
                    child: bottom))
          ],
        ));
  }
}

class TopRowWrapper extends StatelessWidget {
  final Widget left;
  final Widget right;
  const TopRowWrapper({super.key, required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
        width: size.width,
        child: Row(
          children: [
            Flexible(
                flex: size.width < Breakpoints.tablet ? 1 : 2,
                child: Container(
                    padding: const EdgeInsets.all(20),
                    width: size.width,
                    child: left)),
            Flexible(
                flex: 1,
                child: Container(
                    padding: const EdgeInsets.all(20),
                    width: size.width,
                    child: right))
          ],
        ));
  }
}
