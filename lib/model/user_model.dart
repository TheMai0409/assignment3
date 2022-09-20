import 'cart_model.dart';
import 'product_model.dart';

class UserModel {
  String? name;
  String? phone;
  String? address;
  List<ProductModel>? favoriteProducts;
  List<CartModel>? orderHistory;
  String? uid;
  String? email;

  UserModel(
      {this.name,
      this.phone,
      this.address,
      this.favoriteProducts,
      this.orderHistory,
      this.uid,
      this.email});

  factory UserModel.fromQuerySnapshot(Map<String, dynamic> snapshot) {
    return UserModel(
      uid: snapshot['uid'] ?? '',
      name:  snapshot['name'] ?? '',
      email: snapshot['email'] ?? '',
      address: snapshot['address'] ?? '',
      phone: snapshot['phone'] ?? '',
      favoriteProducts: (snapshot['favoriteProducts'].length > 0 &&
              snapshot['favoriteProducts'] != null)
          ? List<ProductModel>.generate(
              snapshot['favoriteProducts'].length,
              (index) => ProductModel.fromQuerySnapshot(
                  snapshot['favoriteProducts'][index])).toList()
          : [],
      orderHistory: (snapshot['orderHistory'].length > 0 &&
              snapshot['orderHistory'] != null)
          ? List<CartModel>.generate(
              snapshot['orderHistory'].length,
              (index) => CartModel.fromQuerySnapshot(
                  snapshot['orderHistory'][index])).toList()
          : [],
    );
  }
}
