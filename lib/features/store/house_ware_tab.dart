import 'package:assignment3/widgets/grid_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/product_viewmodel.dart';

class HouseWareTab extends StatelessWidget {
  const HouseWareTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder:
          (BuildContext context, ProductViewModel productVM, Widget? child) {
        productVM.getHouseWareProducts();
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: GridProduct(
            listProducts: productVM.houseWareProducts,
          ),
        );
      },
    );
  }
}
