import 'package:assignment3/model/product_model.dart';
import 'package:assignment3/model/user_model.dart';
import 'package:assignment3/repository/product_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductRepoImpl implements ProductRepository {
  @override
  Future<List<ProductModel>> getAllProduct() async {
    final CollectionReference userReference =
        FirebaseFirestore.instance.collection('product');

    List<ProductModel> listProducts = [];
    QuerySnapshot querySnapshot = await userReference.get();
    listProducts = querySnapshot.docs
        .map((doc) =>
            ProductModel.fromQuerySnapshot(doc.data() as Map<String, dynamic>))
        .toList();
    return listProducts;
  }

  @override
  Future<List<ProductModel>> getFavouriteProduct() async {

    final CollectionReference productReference =
        FirebaseFirestore.instance.collection('user');
    User? user = FirebaseAuth.instance.currentUser;
    List<ProductModel> listProducts = [];

    if (FirebaseAuth.instance.currentUser != null) {
      DocumentReference documentReference = productReference.doc(user!.uid);
      UserModel userModel = UserModel();
      var userData = await documentReference.get();
      userModel =
          UserModel.fromQuerySnapshot(userData.data() as Map<String, dynamic>);
      listProducts = userModel.favoriteProducts!;
    }

    return listProducts;
  }

  @override
  Future<void> addFavouriteProduct({ProductModel? productModel}) async {

    final CollectionReference productReference =
        FirebaseFirestore.instance.collection('user');
    User? user = FirebaseAuth.instance.currentUser;
    Map<String, dynamic> product = {
      'imageUrl': productModel!.imageUrl,
      'id': productModel.id,
      'cost': productModel.cost,
      'category': productModel.category,
      'description': productModel.description,
      'isLiked': true,
      'name': productModel.name,
    };
    Map<String, dynamic> favouriteProduct = <String, dynamic>{
      'favoriteProducts': FieldValue.arrayUnion([product]),
    };
    if (FirebaseAuth.instance.currentUser != null) {
      DocumentReference documentReference = productReference.doc(user!.uid);
      await documentReference.update(favouriteProduct);
    }
  }

  @override
  Future<void> deleteFavouriteProduct({ProductModel? productModel}) async {
    final CollectionReference productReference =
        FirebaseFirestore.instance.collection('user');
    User? user = FirebaseAuth.instance.currentUser;
    Map<String, dynamic> product = {
      'imageUrl': productModel!.imageUrl,
      'id': productModel.id,
      'cost': productModel.cost,
      'category': productModel.category,
      'description': productModel.description,
      'isLiked': true,
      'name': productModel.name,
    };
    Map<String, dynamic> favouriteProduct = <String, dynamic>{
      'favoriteProducts': FieldValue.arrayRemove([product]),
    };

    if (FirebaseAuth.instance.currentUser != null) {
      DocumentReference documentReference = productReference.doc(user!.uid);
      await documentReference.update(favouriteProduct);
    }
  }
}
