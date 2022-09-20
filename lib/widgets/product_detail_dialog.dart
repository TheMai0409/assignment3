import 'package:assignment3/model/product_model.dart';
import 'package:assignment3/utlis/currency_formatter.dart';
import 'package:assignment3/view_model/cart_viewmodel.dart';
import 'package:assignment3/view_model/product_detail_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailDialog extends StatefulWidget {
  ProductModel product;
  int quantity;
  String action;

  ProductDetailDialog(
      {Key? key,
      required this.product,
      required this.quantity,
      required this.action})
      : super(key: key);

  @override
  State<ProductDetailDialog> createState() => _ProductDetailDialogState();
}

class _ProductDetailDialogState extends State<ProductDetailDialog> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProductDetailViewModel>(context, listen: false).quantity =
        widget.quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 0,
      backgroundColor: Colors.grey.shade300,
      child: buildDialog(context),
    );
  }

  Widget buildDialog(BuildContext context) {
    int quantity = context.watch<ProductDetailViewModel>().quantity!;

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height > width ? height / 2.5 : height / 1.5,
      width: width / 2,
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Image(
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      image: NetworkImage(widget.product.imageUrl!),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(right: 20)),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          widget.product.name!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 8)),
                      Flexible(
                        child: Text(
                          '${formatter.format(widget.product.cost)}đ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          const Expanded(
              flex: 1,
              child: Text(
                'Chi tiết',
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black26, width: 2)),
              child: SingleChildScrollView(
                child: Text(widget.product.description!),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: quantity == 1
                        ? null
                        : context.read<ProductDetailViewModel>().removeQuantity,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Text(
                    quantity.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed:
                        context.read<ProductDetailViewModel>().addQuantity,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green.shade500)),
                    onPressed: () {
                      if (widget.action == 'ADD') {
                        _addToCart(context, widget.product, quantity);
                      } else if (widget.action == 'EDIT') {
                        Provider.of<CartViewModel>(context, listen: false)
                            .updateOrderProduct(
                                productModel: widget.product,
                                quantityUpdate: quantity);
                        Navigator.of(context).pop(quantity);
                      }
                    },
                    child: Text(
                      formatter.format(context
                          .read<ProductDetailViewModel>()
                          .getTotalCost(widget.product.cost!)),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _addToCart(
      BuildContext context, ProductModel productModel, int quantity) {
    Provider.of<CartViewModel>(context, listen: false)
        .addToCart(productModel: productModel, quantity: quantity);
  }
}
