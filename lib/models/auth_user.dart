class AuthUser {
  final String id;
  final String uuid;
  final String name;

  /// * reference to multiple Recipe
  final List<String> favouritesRecipes;

  AuthUser(
      {required this.id,
      required this.name,
      required this.uuid,
      required this.favouritesRecipes});

  factory AuthUser.fromFirestore(Map<String, dynamic> data, String id) {
    final List<dynamic> favouritesRecipesData = data['favouritesRecipes'];
    final List<String> favouritesRecipes =
        favouritesRecipesData.map((e) => e.toString()).toList();
    return AuthUser(
        id: id,
        name: data['name'],
        uuid: data['uuid'],
        favouritesRecipes: favouritesRecipes);
  }

  Map<String, dynamic> toFirestore() {
    return {'name': name, 'uuid': uuid, 'favouritesRecipes': favouritesRecipes};
  }
}
