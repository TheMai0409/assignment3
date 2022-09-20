import 'package:assignment3/model/product_model.dart';

class OrderedProductModel {
  ProductModel? orderedProduct;
  int? quantity;

  OrderedProductModel({this.orderedProduct, this.quantity});

  OrderedProductModel.fromProductModel({this.orderedProduct, this.quantity});

  factory OrderedProductModel.fromQuerySnapshot(Map<String, dynamic> snapshot) {
    return OrderedProductModel(
      orderedProduct: snapshot['orderedProduct'] != null
          ? ProductModel.fromQuerySnapshot(snapshot['orderedProduct'])
          : null,
      quantity: snapshot['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'orderedProduct': {
          'id': orderedProduct!.id,
          'cost': orderedProduct!.cost,
          'category': orderedProduct!.category,
          'description': orderedProduct!.description,
          'imageUrl': orderedProduct!.imageUrl,
          'isLiked': orderedProduct!.isLiked,
          'name': orderedProduct!.name,
        },
        'quantity': quantity
      };
}
