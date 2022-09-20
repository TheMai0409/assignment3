import 'package:assignment3/model/cart_model.dart';

import '../model/ordered_product_model.dart';

abstract class CartRepository {
  Future<void> updateOrderCheckTime({String? time});

  Future<CartModel> getCart();

  Future<void> addCart(CartModel? cartModel);

  Future<void> updateCart(String? name, String? address,String? phone);

  Future<void> addOrderedProduct(
      List<OrderedProductModel>? orderedProductModel);
}
