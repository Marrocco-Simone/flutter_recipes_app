class Category implements Comparable {
  final String id;
  final String name;
  final int nRecipes;

  Category({required this.id, required this.name, required this.nRecipes});

  factory Category.fromFirestore(Map<String, dynamic> data, String id) {
    return Category(id: id, name: data['name'], nRecipes: data['nRecipes']);
  }

  Map<String, dynamic> toFirestore() {
    return {'name': name, 'nRecipes': nRecipes};
  }

  @override
  int compareTo(other) {
    return other.nRecipes.compareTo(nRecipes);
  }

  @override
  bool operator ==(Object other) {
    return other is Category && other.id == id;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
