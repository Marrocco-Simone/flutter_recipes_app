import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_recipes_app/firebase_options.dart';
import 'package:flutter_recipes_app/router/router.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ProviderScope(
      child: MaterialApp.router(
          title: 'Marrocco Simone - Project 2', routerConfig: getRouter())));
}
