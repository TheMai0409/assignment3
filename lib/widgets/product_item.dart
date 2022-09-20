import 'package:assignment3/model/product_model.dart';
import 'package:assignment3/repository/product_repo_impl.dart';
import 'package:assignment3/utlis/currency_formatter.dart';
import 'package:assignment3/view_model/product_viewmodel.dart';
import 'package:assignment3/widgets/product_detail_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

// ignore: must_be_immutable
class ProductItem extends StatefulWidget {
  ProductModel product;

  ProductItem(this.product, {Key? key}) : super(key: key);

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool? isLiked;
  ProductRepoImpl productRepoImpl = ProductRepoImpl();
  User? user = FirebaseAuth.instance.currentUser;

  // void _clickLike() => setState(() {
  //       for (int i = 0; i < listProducts.length; i++) {
  //         if (widget.product.isLiked == true &&
  //             listProducts[i].name == widget.product.name) {
  //           listProducts[i].isLiked = false;
  //         } else if (widget.product.isLiked == false &&
  //             listProducts[i].name == widget.product.name) {
  //           listProducts[i].isLiked = true;
  //         }
  //       }
  //     });

  @override
  void initState() {
    isLiked = widget.product.isLiked!;
    super.initState();
  }

  void _showProductDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return ProductDetailDialog(
          product: widget.product,
          quantity: 1,
          action: 'ADD',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _showProductDialog,
      child: Container(
        padding: const EdgeInsets.all(5),
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Image(
                    image: NetworkImage(widget.product.imageUrl!),
                    fit: BoxFit.fill,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: ZoomTapAnimation(
                      enableLongTapRepeatEvent: false,
                      longTapRepeatDuration: const Duration(milliseconds: 100),
                      begin: 1.0,
                      end: 0.5,
                      beginDuration: const Duration(milliseconds: 20),
                      endDuration: const Duration(milliseconds: 120),
                      beginCurve: Curves.decelerate,
                      endCurve: Curves.fastOutSlowIn,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            isLiked = !isLiked!;
                          });
                          if (FirebaseAuth.instance.currentUser != null) {
                            if (isLiked == true) {
                              productRepoImpl.addFavouriteProduct(
                                  productModel: widget.product);
                            } else {
                              productRepoImpl.deleteFavouriteProduct(
                                  productModel: widget.product);
                            }

                          }
                        },
                        icon: isLiked!
                            ? const Icon(
                                Icons.favorite,
                                size: 30,
                                color: Color.fromRGBO(116, 249, 76, 1),
                              )
                            : const Icon(
                                Icons.favorite_border,
                                size: 30,
                                color: Color.fromRGBO(116, 249, 76, 1),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.name!,
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 5)),
                        Text('${formatter.format(widget.product.cost)}đ',
                            style: const TextStyle(color: Colors.black))
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.add_shopping_cart,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
