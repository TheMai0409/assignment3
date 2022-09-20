import 'package:assignment3/fresh_car_home_screen.dart';
import 'package:assignment3/view_model/cart_viewmodel.dart';
import 'package:assignment3/view_model/product_detail_viewmodel.dart';
import 'package:assignment3/view_model/product_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'service/service_manager.dart';
import 'utlis/snack_bar.dart';

Map<int, Color> color = {
  50: const Color.fromRGBO(51, 153, 255, .1),
  100: const Color.fromRGBO(51, 153, 255, .2),
  200: const Color.fromRGBO(51, 153, 255, .3),
  300: const Color.fromRGBO(51, 153, 255, .4),
  400: const Color.fromRGBO(51, 153, 255, .5),
  500: const Color.fromRGBO(51, 153, 255, .6),
  600: const Color.fromRGBO(51, 153, 255, .7),
  700: const Color.fromRGBO(51, 153, 255, .8),
  800: const Color.fromRGBO(51, 153, 255, .9),
  900: const Color.fromRGBO(51, 153, 255, 1),
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FreshCar());
}

final darkNotifier = ValueNotifier<bool>(false);

class FreshCar extends StatefulWidget {
  const FreshCar({Key? key}) : super(key: key);
  static bool isDark = darkNotifier.value;
  @override
  State<FreshCar> createState() => _FreshCarState();
}

class _FreshCarState extends State<FreshCar> {
  Future<bool>? _initDependencies;

  @override
  void initState() {
    _initDependencies = initDependencies();
    super.initState();
  }


  final CollectionReference reference =
      FirebaseFirestore.instance.collection('product');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initDependencies,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<ProductViewModel>(
                create: (BuildContext context) => ProductViewModel.instance()),
            ChangeNotifierProvider<CartViewModel>(
                create: (BuildContext context) => CartViewModel.instance()),
            ChangeNotifierProvider<ProductDetailViewModel>(
                create: (BuildContext context) => ProductDetailViewModel()),
          ],
          child: ValueListenableBuilder(
            valueListenable: darkNotifier,
            builder: (BuildContext context, bool isDark, Widget? child) {
              Provider.of<CartViewModel>(context, listen: false).getSaveData();

              return MaterialApp(
                scaffoldMessengerKey: SnackBarError.messagerKey,
                debugShowCheckedModeBanner: false,
                themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
                theme: ThemeData(
                  primarySwatch: MaterialColor(0xFFFFFFFF, color),
                  inputDecorationTheme: const InputDecorationTheme(
                    prefixIconColor: Colors.black,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(width: 1, color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(width: 1, color: Colors.black),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(width: 1, color: Colors.black),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(width: 1, color: Colors.black),
                    ),
                  ),
                  textTheme: const TextTheme(
                    button: TextStyle(color: Colors.black, fontSize: 17),
                  ),
                  iconTheme: const IconThemeData(
                    color: Colors.black,
                  ),
                  tabBarTheme: const TabBarTheme(
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.black,
                  ),
                  bottomNavigationBarTheme: BottomNavigationBarThemeData(
                    unselectedItemColor: Colors.black,
                    selectedItemColor: Colors.blue.shade900,
                  ),
                  floatingActionButtonTheme: FloatingActionButtonThemeData(
                    backgroundColor: Colors.blue.shade900,
                    elevation: 20,
                  ),
                  appBarTheme: AppBarTheme(
                    titleTextStyle: TextStyle(
                      color: Colors.green.shade500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  textSelectionTheme:
                      const TextSelectionThemeData(cursorColor: Colors.black),
                ),
                darkTheme: ThemeData.dark(),
                home: const Scaffold(
                  body: FreshCarHomeScreen(),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
