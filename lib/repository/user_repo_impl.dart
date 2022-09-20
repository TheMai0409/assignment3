import 'package:assignment3/repository/user_repository.dart';
import 'package:assignment3/utlis/snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class UserRepoImpl implements UserRepository {
  final _auth = FirebaseAuth.instance;

  @override
  Future<void> changePassword({String? email}) async {
    await _auth.sendPasswordResetEmail(email: email!);
  }

  // Future<UserModel> getUser() async {
  //   String uid = _auth.currentUser!.uid;
  //   DocumentReference doc =
  //       FirebaseFirestore.instance.collection('user').doc(uid);
  //   UserModel userModel = UserModel();
  //
  //   print(doc.snapshots());
  //   return userModel;
  // }

  @override
  Future<void> login({String? email, String? password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email!, password: password!);
    } on FirebaseAuthException catch (error) {
      print(error.message);
      SnackBarError.showSnackBar(error.message);
    }
  }

  @override
  Future<void> register(
      {String? email,
      String? password,
      String? name,
      String? phone,
      String? address}) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email!, password: password!)
          .then((value) => addUser(
              name: name, phone: phone, address: address, email: email));

    } on FirebaseAuthException catch (error) {
      print(error.message);
      SnackBarError.showSnackBar(error.message);
    }
  }

  @override
  Future<void> updateUser(
      {String? name, String? numberPhone, String? address}) async {
    String uid = _auth.currentUser!.uid;
    DocumentReference doc =
        FirebaseFirestore.instance.collection('user').doc(uid);
    Map<String, dynamic> user = {
      'address': address,
      'phone': numberPhone,
      'name': name,
    };
    await doc.update(user);
  }

  @override
  Future<void> addUser(
      {String? name, String? phone, String? address, String? email}) async {
    User? userLogin = _auth.currentUser;
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection('user').doc(userLogin!.uid);
    // .collection('cart').doc();

    DocumentReference cartDoc = FirebaseFirestore.instance
        .collection('user')
        .doc(userLogin.uid)
        .collection('cart')
        .doc(userLogin.uid);
    Map<String, dynamic> user = {
      'address': address,
      'phone': phone,
      'name': name,
      'uid': userLogin.uid,
      'favoriteProducts': [],
      'orderHistory': [],
      'email': email
    };
    Map<String, dynamic> cart = {
      'customerName': name,
      'customerAddress': address,
      'customerPhone': phone,
      'note': '',
      'orderedItems': [],
      'orderCheckoutTime': 'false',
      'totalCost': 0.0,
      'dateCreated': ' ',
    };
    await userDoc.set(user);
    await cartDoc.set(cart);
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
