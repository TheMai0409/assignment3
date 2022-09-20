import 'dart:convert';

import 'package:assignment3/model/cart_model.dart';
import 'package:assignment3/model/ordered_product_model.dart';
import 'package:assignment3/model/product_model.dart';
import 'package:assignment3/view_model/base_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:assignment3/repository/cart_repo_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartViewModel extends BaseViewModel {
  late SharedPreferences prefs;

  static late CartViewModel _instance;
  final CollectionReference reference =
      FirebaseFirestore.instance.collection('user');
  User? user = FirebaseAuth.instance.currentUser;
  CartRepoImpl cartRepoImpl = CartRepoImpl();

  CartViewModel._internal();

  factory CartViewModel() => _instance;

  static CartViewModel instance() => _instance;

  static void initial() {
    _instance = CartViewModel._internal();
  }

  CartModel? currentCart;
  bool isGetCart = false;
  int counter = 0;
  bool isCheckbox = false;
  int? valueRadio;
  bool isMonday = false,
      isTuesday = false,
      isWednesday = false,
      isThursday = false,
      isFriday = false,
      isSaturday = false,
      isSunday = false;
  int? quantity;

  void changeCheckBox(value) {
    isCheckbox = value;

    notifyListeners();
  }

  void clickMonday() {
    isMonday = !isMonday;
    notifyListeners();
  }

  void clickTuesday() {
    isTuesday = !isTuesday;
    notifyListeners();
  }

  void clickWednesday() {
    isWednesday = !isWednesday;
    notifyListeners();
  }

  void clickThursday() {
    isThursday = !isThursday;
    notifyListeners();
  }

  void clickFriday() {
    isFriday = !isFriday;
    notifyListeners();
  }

  void clickSaturday() {
    isSaturday = !isSaturday;
    notifyListeners();
  }

  void clickSunday() {
    isSunday = !isSunday;
    notifyListeners();
  }

  void getCount() {
    counter = currentCart?.orderedItems?.length ?? 0;
    _getPrefsItems();
  }

  CartModel cartModel = CartModel();

  void _setPrefsItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    notifyListeners();
  }

  void _getPrefsItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    counter = prefs.getInt('cart_items') ?? 0;
    notifyListeners();
  }

  Future<void> getCart() async {
    Future<CartModel> cartModel1 = cartRepoImpl.getCart();
    cartModel = await cartModel1;
  }
  void saveData() async {
    prefs = await SharedPreferences.getInstance();
    CartModel cartModel = currentCart!;

    String cart = jsonEncode(cartModel);
    prefs.setString('cart', cart);

    print('Lưu thành công');
  }
  void initialCart() {
    currentCart = CartModel.initial();
    currentCart!.orderedItems = [];
    currentCart!.customerAddress = '';
    currentCart!.customerName = '';
    currentCart!.customerPhone = '';
    currentCart!.note = '';
    currentCart!.dateCreated = '';
    currentCart!.totalCost = 0;
    currentCart!.orderCheckoutTime = '';
  }

  void getSaveData() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString('cart') != null) {
      Map<String, dynamic> jsonData = jsonDecode(prefs.getString('cart')!);
      if (jsonData.isNotEmpty) {
        currentCart = CartModel.fromQuerySnapshot(jsonData);
        _setPrefsItems();
      }
    }
  }

  void addToCart({
    required ProductModel productModel,
    required int quantity,
  }) {
    if (currentCart != null) {
      List<OrderedProductModel> orderProducts = currentCart!.orderedItems!;
      if (orderProducts.isEmpty) {
        orderProducts.add(OrderedProductModel.fromProductModel(
            orderedProduct: productModel, quantity: quantity));
      } else {
        for (int i = 0; i < orderProducts.length; i++) {
          if (orderProducts[i].orderedProduct!.id == productModel.id) {
            orderProducts[i].quantity = orderProducts[i].quantity! + quantity;
          }
        }
      }
      orderProducts
              .where((orderProduct) =>
                  orderProduct.orderedProduct!.id == productModel.id)
              .toList()
              .isEmpty
          ? orderProducts.add(OrderedProductModel.fromProductModel(
              orderedProduct: productModel, quantity: quantity))
          : null;
    }
    saveData();
    _setPrefsItems();
    notifyListeners();
  }

  void updateOrderProduct({
    required ProductModel productModel,
    required int quantityUpdate,
  }) {
    int index = currentCart!.orderedItems!.indexWhere(
        (orderProducts) => orderProducts.orderedProduct!.id == productModel.id);
    currentCart!.orderedItems![index].orderedProduct = productModel;
    currentCart!.orderedItems![index].quantity = quantityUpdate;
    currentCart = currentCart!;
    quantity = quantityUpdate;
    notifyListeners();
  }

  void deleteFromCart() {
    currentCart!.orderedItems!.clear();
    notifyListeners();
  }

  void deleteOrderProduct({
    required OrderedProductModel orderedProductModel,
  }) {
    currentCart!.orderedItems!.remove(orderedProductModel);
    currentCart = currentCart!;
    notifyListeners();
  }
}
