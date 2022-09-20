import 'package:assignment3/view_model/base_viewmodel.dart';

class ProductDetailViewModel extends BaseViewModel {
  int? quantity;

  void addQuantity() {
    quantity = quantity! + 1;
    notifyListeners();
  }

  void removeQuantity() {
    if (quantity! > 1) {
      quantity = quantity! - 1;
    }
   notifyListeners();
  }

  double getTotalCost(double cost) {
    return cost * quantity!;
  }
}
