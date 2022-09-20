import 'package:assignment3/model/cart_model.dart';
import 'package:assignment3/model/user_model.dart';
import 'package:assignment3/repository/cart_repo_impl.dart';
import 'package:assignment3/repository/user_repo_impl.dart';
import 'package:assignment3/view_model/cart_viewmodel.dart';
import 'package:assignment3/widgets/back_app_bar.dart';
import 'package:assignment3/widgets/my_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _numberPhone = TextEditingController();
  final TextEditingController _address = TextEditingController();
  CartRepoImpl cartRepoImpl = CartRepoImpl();
  bool? _isMonday,
      _isTuesday,
      _isWednesday,
      _isThursday,
      _isFriday,
      _isSaturday,
      _isSunday;
  bool isCheck = false;
  int? _groupValue;
  CartModel? cartModel;
  CartModel cart2 = CartModel();
  String timeOrdered = '';
  UserRepoImpl userRepoImpl = UserRepoImpl();
  bool isLoading = true;
  final CollectionReference reference =
      FirebaseFirestore.instance.collection('user');
  User user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    init();
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
    await reference.doc(user.uid).collection('cart').doc(user.uid).get().then(
        (cart) => cartModel =
            CartModel.fromQuerySnapshot(cart.data() as Map<String, dynamic>));
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

  void init() async {
    //
    UserModel userModel = UserModel();
    await reference.doc(user.uid).get().then((user) => userModel =
        UserModel.fromQuerySnapshot(user.data() as Map<String, dynamic>));

    _name.text = userModel.name!;
    _numberPhone.text = userModel.phone!;
    _address.text = userModel.address!;
    getCart();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _numberPhone.dispose();
    _address.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BackAppBar(
          title: 'TÀI KHOẢN',
        ),
        drawer: const MyDrawer(),
        body: isLoading == false
            ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.only(left: 20, top: 50, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Tài khoản:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 28.0),
                                child: Text(
                                  user.email.toString(),
                                  style: const TextStyle(fontSize: 18),
                                ),
                              )
                            ],
                          ),
                          Center(
                            child: TextButton(
                              child: Text(
                                'Đổi mật khẩu',
                                style: Theme.of(context).textTheme.button,
                              ),
                              onPressed: () {
                                userRepoImpl.changePassword(email: user.email);
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 80,
                          ),
                          const Text(
                            'Lưu thông tin của bạn để tự động điền trong thông tin đặt hàng',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                TextField(
                                  controller: _name,
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
                                TextField(
                                  controller: _numberPhone,
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
                                TextField(
                                  controller: _address,
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
                            backgroundColor: MaterialStateProperty.all(
                                Colors.green.shade500)),
                        onPressed: () {
                          timeOrdered = '';

                          userRepoImpl.updateUser(
                              name: _name.text,
                              numberPhone: _numberPhone.text,
                              address: _address.text);
                          cartRepoImpl.updateCart(
                              _name.text, _address.text, _numberPhone.text);
                          if (Provider.of<CartViewModel>(context, listen: false)
                                  .isCheckbox ==
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
                          cartRepoImpl.updateOrderCheckTime(time: timeOrdered);
                          showToast('Lưu thành công');
                        },
                        child: const Text(
                          'LƯU',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.green,
                ),
              ));
  }

  Widget _buildContainer() {
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
