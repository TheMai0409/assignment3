import 'package:assignment3/view_model/product_viewmodel.dart';
import 'package:assignment3/widgets/back_app_bar.dart';
import 'package:assignment3/widgets/grid_product.dart';
import 'package:assignment3/widgets/my_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        title: 'Sản phẩm yêu thích',
      ),
      drawer: const MyDrawer(),
      body: Consumer<ProductViewModel>(
        builder:
            (BuildContext context, ProductViewModel productVM, Widget? child) {
          // if (FirebaseAuth.instance.currentUser != null) {
          //   productVM.getFavouriteProducts();
          // }

          return productVM.isLoadingProduct
              ? const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.green,
                  ),
                )
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: GridProduct(
                    listProducts: productVM.favouriteProducts,
                  ),
                );
        },
      ),
    );
  }
}
