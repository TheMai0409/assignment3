import 'dart:math' as math;

import 'package:assignment3/widgets/back_app_bar.dart';
import 'package:assignment3/widgets/my_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_widget/expansion_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/cart_model.dart';
import '../model/ordered_product_model.dart';
import '../model/user_model.dart';
import '../utlis/currency_formatter.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<CartModel> carts = [];
  List<Widget> cartWidgets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    CollectionReference orderHistoryRef =
        FirebaseFirestore.instance.collection('user');
    UserModel userModel = UserModel();

    if (FirebaseAuth.instance.currentUser != null) {
      User user = FirebaseAuth.instance.currentUser!;

      await orderHistoryRef.doc(user.uid).get().then((user) => userModel =
          UserModel.fromQuerySnapshot(user.data() as Map<String, dynamic>));
      if (userModel.orderHistory != null) {
        carts = userModel.orderHistory!;
        int counter = 0;
        for (int i = 0; i < carts.length; i++) {
          counter++;
          cartWidgets.add(_buildCart(counter, carts[i]));
        }
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        title: 'Lịch sử đơn hàng',
      ),
      drawer: const MyDrawer(),
      body: isLoading == false
          ? SingleChildScrollView(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Spacer(
                        flex: 4,
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Thời gian',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Số tiền',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: cartWidgets,
                  )
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.green,
              ),
            ),
    );
  }

  void getOrderedProduct(
      List<OrderedProductModel> listOrders, List<Widget> listWidgetOrders) {
    int counter = 0;
    for (int i = 0; i < listOrders.length; i++) {
      counter++;
      listWidgetOrders.add(
        _buildRowOrderedProduct(
            counter: counter, orderedProductModel: listOrders[i]),
      );
    }
  }

  Widget _buildCart(int i, CartModel? cart) {
    List<OrderedProductModel> listOrders = cart!.orderedItems!;
    List<Widget> listWidgetOrders = [];
    listOrders.isNotEmpty
        ? getOrderedProduct(listOrders, listWidgetOrders)
        : null;
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Colors.grey.shade200,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        child: ExpansionWidget(
          initiallyExpanded: false,
          titleBuilder:
              (double animationValue, _, bool isExpaned, toogleFunction) {
            return InkWell(
              onTap: () => toogleFunction(animated: true),
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 0),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                            shape: BoxShape.circle,
                            color: const Color.fromRGBO(240, 240, 240, 1),
                          ),
                          child: Center(child: Text(i.toString())),
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 2,
                      child: Text(
                        'Chi tiết',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Transform.rotate(
                        angle: math.pi * animationValue / 1,
                        alignment: Alignment.center,
                        child: const Icon(Icons.keyboard_arrow_down_rounded),
                      ),
                    ),
                    Expanded(
                        flex: 2, child: Text(cart.dateCreated!.toString())),
                    Expanded(
                        flex: 2,
                        child: Text('${formatter.format(cart.totalCost!)}đ'))
                  ],
                ),
              ),
            );
          },
          content: Container(
            width: double.infinity,
            color: Colors.grey.shade200,
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  color: Colors.black,
                  thickness: 2,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    'Chi tiết đơn hàng',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Spacer(
                        flex: 5,
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Số lượng',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Đơn giá',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: listWidgetOrders,
                ),
                Container(
                  color: Colors.grey.shade200,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, top: 30),
                        child: Row(
                          children: const [
                            Expanded(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Khuyến mãi:',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                  '0 ',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Phí giao hàng:',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                  '${formatter.format(5000)}đ',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 10,
                        thickness: 1,
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 30),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'TỔNG CỘNG',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                  '${formatter.format(cart.totalCost)}đ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildRowOrderedProduct(
      {int? counter, OrderedProductModel? orderedProductModel}) {
    int quantity = orderedProductModel!.quantity!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
                shape: BoxShape.circle,
                color: const Color.fromRGBO(240, 240, 240, 1),
              ),
              child: Center(child: Text(counter.toString())),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Image(
              image:
                  NetworkImage(orderedProductModel.orderedProduct!.imageUrl!),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              orderedProductModel.orderedProduct!.name!,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            quantity.toString(),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            '${formatter.format(orderedProductModel.orderedProduct!.cost!)}đ',
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
