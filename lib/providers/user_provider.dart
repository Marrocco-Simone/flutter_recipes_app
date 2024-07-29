import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_recipes_app/models/auth_user.dart';

class AuthUserProvider extends StateNotifier<AuthUser> {
  AuthUserProvider()
      : super(AuthUser(id: '', name: '', uuid: "", favouritesRecipes: [])) {
    fetchUser();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  resetUser() {
    // ignore: avoid_print
    print("Reset user");
    state = AuthUser(id: '', name: '', uuid: "", favouritesRecipes: []);
  }

  fetchUser() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return;
      // ignore: avoid_print
      print("Fetching user");
      final userUuidd = currentUser.uid;
      final snapshot = await _firestore
          .collection('users')
          .where('uuid', isEqualTo: userUuidd)
          .get();
      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs[0].data();
        final id = snapshot.docs[0].id;
        state = AuthUser.fromFirestore(data, id);
      } else {
        final newUser = AuthUser(
            id: '',
            name: "Anonymous#$userUuidd",
            uuid: userUuidd,
            favouritesRecipes: []);
        await _firestore.collection('users').add(newUser.toFirestore());
        fetchUser();
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching user: $e");
    }
  }

  changeName(String newName) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return;
      // ignore: avoid_print
      print("Changing user name to $newName");

      final newData = AuthUser(
          id: state.id,
          name: newName,
          uuid: state.uuid,
          favouritesRecipes: state.favouritesRecipes);
      await _firestore
          .collection('users')
          .doc(state.id)
          .update(newData.toFirestore());
      state = newData;
    } catch (e) {
      // ignore: avoid_print
      print("Error changing user: $e");
    }
  }

  changeFavouriteRecipe(String recipeId) async {
    try {
      final AuthUser newUser;
      final recipeIsFavourited = state.favouritesRecipes.contains(recipeId);

      if (recipeIsFavourited) {
        // ignore: avoid_print
        print("Removing $recipeId from favourites");

        newUser = AuthUser(
            id: state.id,
            name: state.name,
            uuid: state.uuid,
            favouritesRecipes:
                state.favouritesRecipes.where((e) => e != recipeId).toList());
      } else {
        // ignore: avoid_print
        print("Adding $recipeId to favourites");

        newUser = AuthUser(
            id: state.id,
            name: state.name,
            uuid: state.uuid,
            favouritesRecipes: [...state.favouritesRecipes, recipeId]);
      }

      await _firestore
          .collection('users')
          .doc(state.id)
          .update(newUser.toFirestore());
      state = newUser;
    } catch (e) {
      // ignore: avoid_print
      print("Error changing user: $e");
    }
  }
}

final authUserProvider = StateNotifierProvider<AuthUserProvider, AuthUser>(
    (ref) => AuthUserProvider());

final firebaseUserProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});
