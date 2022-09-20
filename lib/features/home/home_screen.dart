import 'package:assignment3/view_model/product_viewmodel.dart';
import 'package:assignment3/widgets/my_bannner.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/product_viewmodel.dart';
import '../../widgets/product_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductViewModel>(
      builder:
          (BuildContext context, ProductViewModel productVM, Widget? child) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            productVM.getProduct();

            if (FirebaseAuth.instance.currentUser != null) {
              productVM.getFavouriteProducts();
              productVM.updateProducts();
            }

            if (constraints.maxWidth < 600) {
              return productVM.isLoadingProduct
                  ? const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.green,
                      ),
                    )
                  : _buildCustomScrollViewPhone(productVM);
            } else {
              return productVM.isLoadingProduct
                  ? const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.green,
                      ),
                    )
                  : _buildCustomScrollViewTablet(productVM);
            }
          },
        );
      },
    );
  }

  CustomScrollView _buildCustomScrollViewPhone(ProductViewModel productVM) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                child: const MyBanner(),
              );
            },
            childCount: 1,
          ),
        ),
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return ProductItem(productVM.products[index]);
            },
            childCount: productVM.products.length,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
        )
      ],
    );
  }

  CustomScrollView _buildCustomScrollViewTablet(ProductViewModel productVM) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: const MyBanner(),
              );
            },
            childCount: 1,
          ),
        ),
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return ProductItem(productVM.products[index]);
            },
            childCount: productVM.products.length,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
        )
      ],
    );
  }
}
