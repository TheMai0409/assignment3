import 'package:assignment3/features/cart_screen.dart';
import 'package:assignment3/view_model/cart_viewmodel.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(60);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'CHỢ ONLINE',
        style: TextStyle(
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.menu,
          size: 30,
        ),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      actions: [
        _shoppingCartBadge(),
        const Padding(padding: EdgeInsets.only(right: 30)),
      ],
    );
  }

  Widget _shoppingCartBadge() {
    return Consumer(
      builder:
          (BuildContext context, CartViewModel cartViewModel, Widget? widget) {
        cartViewModel.getCount();
        return Badge(
          position: BadgePosition.topEnd(top: 0, end: 3),
          animationDuration: const Duration(milliseconds: 300),
          animationType: BadgeAnimationType.slide,
          badgeColor: Colors.blue,
          badgeContent: Text(
            cartViewModel.counter.toString(),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.shopping_cart,
              size: 30,
            ),
            onPressed: () {

              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) => const CartScreen()),
              );
            },
          ),
        );
      },
    );
  }
}
