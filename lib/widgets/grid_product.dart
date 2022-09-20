import 'package:assignment3/model/product_model.dart';
import 'package:assignment3/widgets/product_item.dart';
import 'package:flutter/material.dart';

class GridProduct extends StatelessWidget {
  List<ProductModel>? listProducts;

  GridProduct({Key? key, this.listProducts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < 600) {
        return _buildPhone();
      } else {
        return _buildTablet();
      }
    });
  }

  Container _buildPhone() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: GridView.builder(
        itemCount: listProducts!.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (BuildContext context, int index) {
          return ProductItem(listProducts![index]);
        },
      ),
    );
  }

  Container _buildTablet() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: GridView.builder(
        itemCount: listProducts!.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (BuildContext context, int index) {
          return ProductItem(listProducts![index]);
        },
      ),
    );
  }
}
