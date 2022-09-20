
import 'package:assignment3/view_model/cart_viewmodel.dart';
import 'package:assignment3/view_model/product_viewmodel.dart';

Future<bool> initDependencies() async {
  // ServiceManagerImpl().init();
  ProductViewModel.initial();
  CartViewModel.initial();
  await Future.delayed(const Duration(seconds: 1));
  return true;
}
