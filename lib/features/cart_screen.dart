import 'dart:convert';

import 'package:assignment3/features/user/login_screen.dart';
import 'package:assignment3/fresh_car_home_screen.dart';
import 'package:assignment3/main.dart';
import 'package:assignment3/model/cart_model.dart';
import 'package:assignment3/model/ordered_product_model.dart';
import 'package:assignment3/repository/cart_repo_impl.dart';
import 'package:assignment3/utlis/currency_formatter.dart';
import 'package:assignment3/view_model/cart_viewmodel.dart';
import 'package:assignment3/widgets/back_app_bar.dart';
import 'package:assignment3/widgets/my_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/product_model.dart';
import '../widgets/product_detail_dialog.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late SharedPreferences prefs;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _numberPhone = TextEditingController();
  final TextEditingController _customerAddress = TextEditingController();
  final TextEditingController _note = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Widget> listWidgetOrders = [];
  List<OrderedProductModel> listOrders = [];
  double? _cost, _sale, _costShipper, _totalCost;
  bool? _isMonday,
      _isTuesday,
      _isWednesday,
      _isThursday,
      _isFriday,
      _isSaturday,
      _isSunday;
  bool isCheck = false;
  late int _groupValue;
  CartModel? cartModel;
  final CollectionReference reference =
      FirebaseFirestore.instance.collection('user');
  String timeOrdered = '';
  CartModel? model;
  CartRepoImpl cartRepoImpl = CartRepoImpl();
  CartModel cartSave = CartModel();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      getCart();
      print(FirebaseAuth.instance.currentUser!.uid);
    } else {
      setState(() {
        isLoading = false;
      });
    }

    listWidgetOrders = [];
    _sale = 0;
    _costShipper = 5000;
    _cost = 0;
    _totalCost = _cost! + _costShipper! - _sale!;
    cartSave = Provider.of<CartViewModel>(context, listen: false).currentCart!;

    listOrders = cartSave.orderedItems!;
    listOrders.isNotEmpty ? getOrderedProduct() : null;
    Provider.of<CartViewModel>(context, listen: false).isGetCart = true;
    if (cartSave.orderedItems!.isEmpty) {
      getSaveData();
      listOrders = cartSave.orderedItems!;
      listOrders.isNotEmpty ? getOrderedProduct() : null;
      if (cartSave.note != null) {
        _note.text = cartSave.note!;
      }
      if (cartSave.customerPhone != null) {
        _numberPhone.text = cartSave.customerPhone!;
      }
      if (cartSave.customerName != null) {
        _name.text = cartSave.customerName!;
      }
      if (cartSave.note != null) {
        _customerAddress.text = cartSave.customerAddress!;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _numberPhone.dispose();
    _customerAddress.dispose();
    _note.dispose();
    saveData();
  }

  Future<void> getCart() async {
    isCheck = false;
    _isMonday = false;
    _isTuesday = false;
    _isWednesday = false;
    _isThursday = false;
    _isFriday = false;
    _isSaturday = false;
    _isSunday = false;
    _groupValue = 0;
    CartModel cartModel = CartModel();

    await context.read<CartViewModel>().getCart();
    cartModel = Provider.of<CartViewModel>(context, listen: false).cartModel;

    if (cartModel.customerName != null) {
      _name.text = cartModel.customerName!;
    }
    if (cartModel.customerPhone != null) {
      _numberPhone.text = cartModel.customerPhone!;
    }
    if (cartModel.customerAddress != null) {
      _customerAddress.text = cartModel.customerAddress!;
    }
    if (cartModel.note != null) {
      _note.text = cartModel.note!;
    }
    if (cartModel.orderCheckoutTime != null) {
      timeOrdered = cartModel.orderCheckoutTime!;

      List<String> day = timeOrdered.split(',');
      if (day.length > 2) {
        String value = day[day.length - 1];
        _groupValue = int.parse(value);
      }

      for (int i = 0; i < day.length; i++) {
        if (day[i].contains('Thứ hai')) {
          _isMonday = true;
        }
        if (day[i].contains('true')) {
          isCheck = true;
        }
        if (day[i].contains('Thứ ba')) {
          _isTuesday = true;
        }
        if (day[i].contains('Thứ tư')) {
          _isWednesday = true;
        }
        if (day[i].contains('Thứ năm')) {
          _isThursday = true;
        }

        if (day[i].contains('Thứ sáu')) {
          _isFriday = true;
        }

        if (day[i].contains('Thứ bảy')) {
          _isSaturday = true;
        }

        if (day[i].contains('Chủ Nhật')) {
          _isSunday = true;
        }
      }
    }
    setState(() {
      isLoading = false;
    });
    Provider.of<CartViewModel>(context, listen: false).isCheckbox = isCheck;
    Provider.of<CartViewModel>(context, listen: false).isMonday = _isMonday!;
    Provider.of<CartViewModel>(context, listen: false).isTuesday = _isTuesday!;
    Provider.of<CartViewModel>(context, listen: false).isWednesday =
        _isWednesday!;
    Provider.of<CartViewModel>(context, listen: false).isThursday =
        _isThursday!;
    Provider.of<CartViewModel>(context, listen: false).isFriday = _isFriday!;
    Provider.of<CartViewModel>(context, listen: false).isSaturday =
        _isSaturday!;
    Provider.of<CartViewModel>(context, listen: false).isSunday = _isSunday!;
  }

  void saveData() async {
    prefs = await SharedPreferences.getInstance();
    CartModel cartModel = cartSave;
    cartModel.customerName = _name.text;
    cartModel.customerAddress == _customerAddress.text;
    cartModel.customerPhone = _numberPhone.text;
    cartModel.note = _note.text;
    print(cartModel.note);
    print(cartModel.customerAddress);
    print(cartModel.customerName);
    print(cartModel.customerPhone);
    String cart = jsonEncode(cartModel);
    prefs.setString('cart', cart);

    print('Lưu thành công');
  }

  void deleteData() async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove('cart');
  }

  void getSaveData() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString('cart') != null) {
      Map<String, dynamic> jsonData = jsonDecode(prefs.getString('cart')!);
      if (jsonData.isNotEmpty) {
        cartSave = CartModel.fromQuerySnapshot(jsonData);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        title: 'GIỎ HÀNG',
      ),
      drawer: const MyDrawer(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.green,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.only(left: 20, top: 50, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nhập tên và địa chỉ của người nhận',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Form(
                          key: _formKey,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _name,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return ("Tên không được để trống");
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2, color: Colors.black),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2, color: Colors.black),
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2, color: Colors.red),
                                    ),
                                    hintText:
                                        'Tên người nhận (bắt buộc không được để trống)',
                                  ),
                                ),
                                TextFormField(
                                  controller: _numberPhone,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return ("Số điện thoại không được để trống");
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2, color: Colors.black),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2, color: Colors.black),
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2, color: Colors.red),
                                    ),
                                    hintText:
                                        'Số điện thoại (bắt buộc không để trống)',
                                  ),
                                ),
                                TextFormField(
                                  controller: _customerAddress,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return ("Địa chỉ không được để trống");
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2, color: Colors.black),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2, color: Colors.black),
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 2, color: Colors.red),
                                    ),
                                    hintText:
                                        'Địa chỉ (bắt buộc không để trống)',
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 30),
                                  child: TextFormField(
                                    controller: _note,
                                    minLines: 5,
                                    maxLines: 7,
                                    keyboardType: TextInputType.multiline,
                                    decoration: const InputDecoration(
                                      hintText: 'Ghi chú',
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                        borderSide: BorderSide(
                                            width: 2, color: Colors.black),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                        borderSide: BorderSide(
                                            width: 2, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Text(
                          'Chi tiết đơn hàng',
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Chỉnh sửa',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                        Column(
                          children: listWidgetOrders,
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: const Padding(
                              padding: EdgeInsets.all(20),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Nhập mã giảm giá',
                                  contentPadding: EdgeInsets.all(5),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.black),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.black),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(width: 2, color: Colors.red),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 30),
                    color: Colors.grey.shade300,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Tạm tính:',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    '${formatter.format(_cost)}đ',
                                    style: const TextStyle(fontSize: 14),
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
                                    'Khuyến mãi:',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    '${formatter.format(_sale)}đ',
                                    style: const TextStyle(fontSize: 14),
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
                                    '${formatter.format(_costShipper)}đ',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 10,
                          thickness: 2,
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
                                    '${formatter.format(_totalCost)}đ',
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
                  CheckboxListTile(
                    title: const Text(
                      'Giao hàng định kỳ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    value: context.watch<CartViewModel>().isCheckbox,
                    onChanged: (bool? value) {
                      Provider.of<CartViewModel>(context, listen: false)
                          .changeCheckBox(value);
                    },
                  ),
                  Container(
                    child: Provider.of<CartViewModel>(context, listen: false)
                            .isCheckbox
                        ? _buildContainer()
                        : null,
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green.shade500)),
                      onPressed: _orderedProduct,
                      child: const Text(
                        'ĐẶT HÀNG',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
      // : const Center(
      //     child: CircularProgressIndicator(
      //       backgroundColor: Colors.green,
      //     ),
      //   ),
    );
  }

  void getOrderedProduct() {
    int counter = 0;
    for (int i = 0; i < listOrders.length; i++) {
      Key key = Key('Product $counter');
      counter++;
      listWidgetOrders.add(
        _buildRowOrderedProduct(
            counter: counter, orderedProductModel: listOrders[i], key: key),
      );
      _cost = _cost! +
          listOrders[i].orderedProduct!.cost! * listOrders[i].quantity!;
    }
    _totalCost = _cost! + _costShipper! - _sale!;
  }

  Row _buildRowOrderedProduct(
      {int? counter, OrderedProductModel? orderedProductModel, Key? key}) {
    int quantity = orderedProductModel!.quantity!;

    return Row(
      key: key,
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
        Expanded(
          flex: 1,
          child: IconButton(
            onPressed: () async {
              int quantityUpdate = (await showProductDialog(
                  orderedProductModel.orderedProduct!,
                  orderedProductModel.quantity!)) as int;
              print('UPADATE $quantityUpdate');
              setState(() {
                quantity = quantityUpdate;
                listWidgetOrders = [];

                _sale = 0;
                _costShipper = 5000;
                _cost = 0;
                _totalCost = _cost! + _costShipper! - _sale!;
                listOrders = cartSave.orderedItems!;
                listOrders.isNotEmpty ? getOrderedProduct() : null;
                print('UPADATE $quantityUpdate');
              });
            },
            icon: const Icon(
              Icons.edit,
              color: Colors.green,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: IconButton(
            onPressed: () {
              Provider.of<CartViewModel>(context, listen: false)
                  .deleteOrderProduct(orderedProductModel: orderedProductModel);
              _removeOrderProduct(key!);
              listWidgetOrders = [];

              _sale = 0;
              _costShipper = 5000;
              _cost = 0;
              _totalCost = _cost! + _costShipper! - _sale!;
              listOrders = cartSave.orderedItems!;
              listOrders.isNotEmpty ? getOrderedProduct() : null;
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  void _removeOrderProduct(Key key) {
    for (int i = 0; i < listWidgetOrders.length; i++) {
      Widget widget = listWidgetOrders.elementAt(i);
      if (widget.key == key) {
        setState(() {
          listWidgetOrders.removeAt(i);
        });
      }
    }
  }

  Container _buildContainer() {
    return Container(
      padding: const EdgeInsets.only(right: 20.0, left: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: context.watch<CartViewModel>().isMonday
                      ? MaterialStateProperty.all(Colors.green.shade600)
                      : MaterialStateProperty.all(Colors.green.shade100),
                ),
                onPressed: () {
                  Provider.of<CartViewModel>(context, listen: false)
                      .clickMonday();
                  _isMonday = Provider.of<CartViewModel>(context, listen: false)
                      .isMonday;
                },
                child: const Text(
                  'Thứ 2',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: context.watch<CartViewModel>().isTuesday
                        ? MaterialStateProperty.all(Colors.green.shade600)
                        : MaterialStateProperty.all(Colors.green.shade100),
                  ),
                  onPressed: () {
                    Provider.of<CartViewModel>(context, listen: false)
                        .clickTuesday();
                    _isTuesday =
                        Provider.of<CartViewModel>(context, listen: false)
                            .isTuesday;
                  },
                  child: const Text(
                    'Thứ 3',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: context.watch<CartViewModel>().isWednesday
                        ? MaterialStateProperty.all(Colors.green.shade600)
                        : MaterialStateProperty.all(Colors.green.shade100),
                  ),
                  onPressed: () {
                    Provider.of<CartViewModel>(context, listen: false)
                        .clickWednesday();
                    _isWednesday =
                        Provider.of<CartViewModel>(context, listen: false)
                            .isWednesday;
                  },
                  child: const Text(
                    'Thứ 4',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: context.watch<CartViewModel>().isThursday
                        ? MaterialStateProperty.all(Colors.green.shade600)
                        : MaterialStateProperty.all(Colors.green.shade100),
                  ),
                  onPressed: () {
                    Provider.of<CartViewModel>(context, listen: false)
                        .clickThursday();
                    _isThursday =
                        Provider.of<CartViewModel>(context, listen: false)
                            .isThursday;
                  },
                  child: const Text(
                    'Thứ 5',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: context.watch<CartViewModel>().isFriday
                      ? MaterialStateProperty.all(Colors.green.shade600)
                      : MaterialStateProperty.all(Colors.green.shade100),
                ),
                onPressed: () {
                  Provider.of<CartViewModel>(context, listen: false)
                      .clickFriday();
                  _isFriday = Provider.of<CartViewModel>(context, listen: false)
                      .isFriday;
                },
                child: const Text(
                  'Thứ 6',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: context.watch<CartViewModel>().isSaturday
                        ? MaterialStateProperty.all(Colors.green.shade600)
                        : MaterialStateProperty.all(Colors.green.shade100),
                  ),
                  onPressed: () {
                    Provider.of<CartViewModel>(context, listen: false)
                        .clickSaturday();
                    _isSaturday =
                        Provider.of<CartViewModel>(context, listen: false)
                            .isSaturday;
                  },
                  child: const Text(
                    'Thứ 7',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: context.watch<CartViewModel>().isSunday
                        ? MaterialStateProperty.all(Colors.green.shade600)
                        : MaterialStateProperty.all(Colors.green.shade100),
                  ),
                  onPressed: () {
                    Provider.of<CartViewModel>(context, listen: false)
                        .clickSunday();
                    _isSunday =
                        Provider.of<CartViewModel>(context, listen: false)
                            .isSunday;
                  },
                  child: const Text(
                    'CN',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 15.0, bottom: 20.0),
            child: Text(
              'Thời gian giao hàng',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          Row(
            children: [
              Radio(
                value: 0,
                groupValue: _groupValue,
                onChanged: (dynamic val) {
                  setState(() {
                    _groupValue = val;
                  });
                },
              ),
              Text(
                'Trong giờ hành chính (8h-16h)',
                style: TextStyle(
                    fontSize: 17.0,
                    color: _groupValue == 0 ? Colors.blue : Colors.grey),
              ),
            ],
          ),
          Row(
            children: [
              Radio(
                value: 1,
                groupValue: _groupValue,
                onChanged: (dynamic val) {
                  setState(() {
                    _groupValue = val;
                  });
                },
              ),
              Text(
                'Sau 6h tối',
                style: TextStyle(
                    fontSize: 17.0,
                    color: _groupValue == 1 ? Colors.blue : Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _orderedProduct() {
    if (_formKey.currentState!.validate()) {
      if (listOrders.isEmpty) {
        showToast('Giỏ hàng của bạn không có sản phẩm nào');
      } else {
        timeOrdered = '';
        cartSave =
            Provider.of<CartViewModel>(context, listen: false).currentCart!;
        listOrders = cartSave.orderedItems!;
        print(listOrders.length);
        if (Provider.of<CartViewModel>(context, listen: false).isCheckbox ==
            false) {
          timeOrdered = 'false,';
        } else {
          timeOrdered = 'true,';
          if (_isMonday == true) {
            timeOrdered = "${timeOrdered}Thứ hai,";
          }
          if (_isTuesday == true) {
            timeOrdered = "${timeOrdered}Thứ ba,";
          }
          if (_isWednesday == true) {
            timeOrdered = "${timeOrdered}Thứ tư,";
          }
          if (_isFriday == true) {
            timeOrdered = "${timeOrdered}Thứ sáu,";
          }
          if (_isThursday == true) {
            timeOrdered = "${timeOrdered}Thứ năm,";
          }
          if (_isSaturday == true) {
            timeOrdered = "${timeOrdered}Thứ bảy,";
          }
          if (_isSunday == true) {
            timeOrdered = "${timeOrdered}Chủ Nhật,";
          }
          timeOrdered = "$timeOrdered$_groupValue";
        }

        cartSave.customerName = _name.text;
        cartSave.customerAddress = _customerAddress.text;
        cartSave.customerPhone = _numberPhone.text;
        cartSave.note = _note.text;
        cartSave.totalCost = _totalCost;
        cartSave.orderedItems = listOrders;
        cartSave.orderCheckoutTime = timeOrdered;
        var now = DateTime.now();
        var formatter = DateFormat('dd/MM/yyyy');
        String formattedDate = formatter.format(now);
        cartSave.dateCreated = formattedDate;
        if (FirebaseAuth.instance.currentUser != null) {
          cartRepoImpl.addCart(cartSave);
          showToast('Đặt hàng thành công');
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const FreshCarHomeScreen()));
        } else {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        }
        context.read<CartViewModel>().deleteFromCart();
        deleteData();
        setState(() {
          listWidgetOrders = [];
          _sale = 0;
          _costShipper = 5000;
          _cost = 0;
          _totalCost = _cost! + _costShipper! - _sale!;
        });
      }
    }
    if (_name.text.isEmpty ||
        _numberPhone.text.isEmpty ||
        _customerAddress.text.isEmpty) {
      showToast('Bạn cần điền đầy đủ thông tin');
    }
  }

  Future<int?> showProductDialog(ProductModel productModel, int quantity) =>
      showDialog<int>(
        context: context,
        builder: (context) {
          return ProductDetailDialog(
            product: productModel,
            quantity: quantity,
            action: 'EDIT',
          );
        },
      );

  void showToast(String msg) {
    showToastWidget(
      Container(
        height: MediaQuery.of(context).size.height * 0.06,
        width: MediaQuery.of(context).size.width * 0.6,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          color: Colors.black54,
        ),
        child: Center(
          child: Text(
            msg,
            style: const TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      context: context,
      isIgnoring: false,
      position: StyledToastPosition.center,
      duration: const Duration(seconds: 2),
    );
  }
}
