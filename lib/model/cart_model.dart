import 'package:assignment3/model/ordered_product_model.dart';

class CartModel {
  List<OrderedProductModel>? orderedItems;
  String? note;
  String? customerName;
  String? customerPhone;
  String? customerAddress;
  String? orderCheckoutTime;
  String? dateCreated;
  double? totalCost;

  static final CartModel _instance = CartModel._internal();

  CartModel._internal();

  factory CartModel.initial() {
    return _instance;
  }

  CartModel(
      {this.orderedItems,
      this.note,
      this.customerName,
      this.customerPhone,
      this.customerAddress,
      this.orderCheckoutTime,
      this.dateCreated,
      this.totalCost});

  Map<String, dynamic> toJson() {
    return {
      'customerName': customerName,
      'customerAddress': customerAddress,
      'customerPhone': customerPhone,
      'note': note,
      'orderedItems': orderedItems,
      'orderCheckoutTime': orderCheckoutTime,
      'totalCost': totalCost,
      'dateCreated': dateCreated,
    };
  }

  factory CartModel.fromQuerySnapshot(Map<String, dynamic> snapshot) {
    return CartModel(
      customerName: snapshot['customerName'],
      customerPhone: snapshot['customerPhone'],
      customerAddress: snapshot['customerAddress'],
      note: snapshot['note'],
      orderedItems: (snapshot['orderedItems'].length > 0 &&
              snapshot['orderedItems'] != null)
          ? List<OrderedProductModel>.generate(
              snapshot['orderedItems'].length,
              (index) => OrderedProductModel.fromQuerySnapshot(
                  snapshot['orderedItems'][index])).toList()
          : [],
      orderCheckoutTime: snapshot['orderCheckoutTime'],
      totalCost: snapshot['totalCost'] ?? 0.0,
      dateCreated: snapshot['dateCreated'],
    );
  }
}
