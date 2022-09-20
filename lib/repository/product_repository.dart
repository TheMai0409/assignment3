import 'package:assignment3/model/product_model.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> getAllProduct();

  Future<List<ProductModel>> getFavouriteProduct();

  Future<void> addFavouriteProduct({ProductModel productModel});

  Future<void> deleteFavouriteProduct({ProductModel productModel});
}
