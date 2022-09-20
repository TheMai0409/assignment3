import 'package:assignment3/model/ordered_product_model.dart';
import 'package:assignment3/repository/cart_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/cart_model.dart';

class CartRepoImpl implements CartRepository {


  @override
  Future<void> updateOrderCheckTime({String? time}) async {
    User? user = FirebaseAuth.instance.currentUser;
    final CollectionReference cartReference =
    FirebaseFirestore.instance.collection('user');
    DocumentReference documentReference =
        cartReference.doc(user!.uid).collection('cart').doc(user.uid);

    Map<String, dynamic> timeOrdered = {
      'orderCheckoutTime': time,
    };

    await documentReference.update(timeOrdered);
  }

  @override
  Future<CartModel> getCart() async {
    User? user = FirebaseAuth.instance.currentUser;
    final CollectionReference cartReference =
    FirebaseFirestore.instance.collection('user');
    CartModel cartModel = CartModel();
    DocumentReference documentReference =
        cartReference.doc(user!.uid).collection('cart').doc(user.uid);
    await documentReference.get().then((cart) => cartModel =
        CartModel.fromQuerySnapshot(cart.data() as Map<String, dynamic>));
    return cartModel;
  }

  @override
  Future<void> addCart(CartModel? cartModel) async {
    User? user = FirebaseAuth.instance.currentUser;
    final CollectionReference cartReference =
    FirebaseFirestore.instance.collection('user');
    DocumentReference documentReference = cartReference.doc(user!.uid);

    Map<String, dynamic> data = <String, dynamic>{
      'customerName': cartModel!.customerName,
      'customerPhone': cartModel.customerPhone,
      'customerAddress': cartModel.customerAddress,
      'note': cartModel.note,
      'orderedItems': [
        for (int i = 0; i < cartModel.orderedItems!.length; i++)
          {
            'orderedProduct': {
              'id': 'i',
              'cost': cartModel.orderedItems![i].orderedProduct!.cost,
              'category': cartModel.orderedItems![i].orderedProduct!.category,
              'description':
                  cartModel.orderedItems![i].orderedProduct!.description,
              'imageUrl': cartModel.orderedItems![i].orderedProduct!.imageUrl,
              'isLiked': cartModel.orderedItems![i].orderedProduct!.isLiked,
              'name': cartModel.orderedItems![i].orderedProduct!.name,
            },
            'quantity': cartModel.orderedItems![i].quantity
          }
      ],
      'totalCost': cartModel.totalCost,
      'orderCheckoutTime': cartModel.orderCheckoutTime,
      'dateCreated': cartModel.dateCreated,
    };
    Map<String, dynamic> orderedCart = {
      'orderHistory': FieldValue.arrayUnion([data])
    };
    await documentReference.update(orderedCart);
  }

  @override
  Future<void> addOrderedProduct(
      List<OrderedProductModel>? orderedProductModel) async {
    User? user = FirebaseAuth.instance.currentUser;
    final CollectionReference cartReference =
    FirebaseFirestore.instance.collection('user');
    DocumentReference documentReference =
        cartReference.doc(user!.uid).collection('cart').doc(user.uid);
    for (int i = 0; i < orderedProductModel!.length; i++) {
      Map<String, dynamic> orderProduct = <String, dynamic>{
        'orderedProduct': {
          'id': 'i',
          'cost': orderedProductModel[i].orderedProduct!.cost,
          'category': orderedProductModel[i].orderedProduct!.category,
          'description': orderedProductModel[i].orderedProduct!.description,
          'imageUrl': orderedProductModel[i].orderedProduct!.imageUrl,
          'isLiked': orderedProductModel[i].orderedProduct!.isLiked,
          'name': orderedProductModel[i].orderedProduct!.name,
        },
        'quantity': orderedProductModel[i].quantity
      };
      Map<String, dynamic> orderProducts = {
        'orderedItems': FieldValue.arrayUnion([orderProduct])
      };
      await documentReference.update(orderProducts);
    }
  }

  @override
  Future<void> updateCart(String? name, String? address, String? phone) async {
    User? user = FirebaseAuth.instance.currentUser;
    final CollectionReference cartReference =
    FirebaseFirestore.instance.collection('user');
    DocumentReference documentReference =
        cartReference.doc(user!.uid).collection('cart').doc(user.uid);

    Map<String, dynamic> update = {
      'customerName': name,
      'customerPhone': phone,
      'customerAddress': address,
    };

    await documentReference.update(update);
  }
}
