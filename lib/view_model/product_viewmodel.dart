import 'package:assignment3/model/product_model.dart';
import 'package:assignment3/repository/product_repo_impl.dart';
import 'package:assignment3/view_model/base_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductViewModel extends BaseViewModel {
  static late ProductViewModel _instance;

  ProductViewModel._internal();

  factory ProductViewModel() {
    return _instance;
  }

  static ProductViewModel instance() => _instance;

  static void initial() {
    _instance = ProductViewModel._internal();
  }

  ProductRepoImpl productRepoImpl = ProductRepoImpl();
  List<ProductModel> products = [];
  List<ProductModel> vegetableProducts = [];
  List<ProductModel> meatProducts = [];
  List<ProductModel> houseWareProducts = [];
  List<ProductModel> favouriteProducts = [];
  bool isLoadingProduct = true;

  Future<void> getProduct() async {
    Future<List<ProductModel>> lists = productRepoImpl.getAllProduct();
    products = await lists;

    isLoadingProduct = false;
    notifyListeners();
  }

  void updateProducts() {
    if (favouriteProducts.isNotEmpty) {
      for (int i = 0; i < favouriteProducts.length; i++) {
        products[products.indexWhere(
                (element) => element.id == favouriteProducts[i].id)] =
            favouriteProducts[i];

      }
    }
  }

  void getMeatProducts() async {
    updateProducts();
    meatProducts = products
        .where((product) => product.category!.contains('meat'))
        .toList();
  }

  void getVegetableProducts() async {
    updateProducts();
    vegetableProducts = products
        .where((product) => product.category!.contains('vegetable'))
        .toList();
  }

  void getHouseWareProducts() async {
    updateProducts();
    houseWareProducts = products
        .where((product) => product.category!.contains('houseware'))
        .toList();
  }

  Future<void> getFavouriteProducts() async {
    if (FirebaseAuth.instance.currentUser != null) {
      Future<List<ProductModel>> lists = productRepoImpl.getFavouriteProduct();
      favouriteProducts = await lists;
    }
  }
}
