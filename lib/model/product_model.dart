class ProductModel {
  String? imageUrl;
  String? name;
  String? description;
  bool? isLiked;
  double? cost;
  String? id;
  String? category;

  ProductModel(
      {this.imageUrl,
      this.name,
      this.description,
      this.isLiked,
      this.cost,
      this.id,
      this.category});

  factory ProductModel.fromQuerySnapshot(Map<String, dynamic> snapshot) {
    return ProductModel(
      id: snapshot['id'],
      cost: double.parse(snapshot['cost'].toString()),
      category: snapshot['category'] ?? '',
      description: snapshot['description'] != null
          ? snapshot['description'] as String
          : '',
      imageUrl:
          snapshot['imageUrl'] != null ? snapshot['imageUrl'] as String : '',
      isLiked:
          snapshot['isLiked'] != null ? snapshot['isLiked'] as bool : false,
      name: snapshot['name'] != null ? snapshot['name'] as String : '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'id': id,
      'cost': cost,
      'category': category,
      'description': description,
      'isLiked': isLiked,
      'name': name,
    };
  }
}
