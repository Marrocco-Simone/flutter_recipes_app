import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_recipes_app/providers/user_provider.dart';
import 'package:flutter_recipes_app/styles/colors.dart';

class LoginButton extends ConsumerWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseUser = ref.watch(firebaseUserProvider);
    final authUser = ref.watch(authUserProvider);

    goToAccountPage() {
      context.go("/account");
    }

    logIn() {
      // ignore: avoid_print
      print("Loggin in");
      FirebaseAuth.instance.signInAnonymously().then((_) {
        // GoRouter.of(context).refresh();
        ref.watch(authUserProvider.notifier).fetchUser();
        goToAccountPage();
      });
    }

    final isLoggedIn = firebaseUser.value?.uid != null;
    final icon = isLoggedIn ? Icons.account_circle : Icons.login;
    final label = isLoggedIn ? "Hi, ${authUser.name}" : "Login";
    final onPressed = isLoggedIn ? goToAccountPage : logIn;

    return Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: TextButton.icon(
            icon: Icon(
              icon,
              color: Colors.black,
            ),
            onPressed: onPressed,
            label: Text(
              label,
              textScaler: const TextScaler.linear(1.25),
              style: const TextStyle(color: Colors.black),
            ),
            style: TextButton.styleFrom(
                padding: const EdgeInsets.all(15),
                backgroundColor: topBarButtonColor,
                alignment: Alignment.center)));
  }
}
