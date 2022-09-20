import 'package:assignment3/features/history_screen.dart';
import 'package:assignment3/features/user/account_screen.dart';
import 'package:assignment3/repository/user_repo_impl.dart';
import 'package:assignment3/widgets/my_bannner.dart';
import 'package:flutter/material.dart';

import '../features/favourite_screen.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    UserRepoImpl userRepoImpl = UserRepoImpl();
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.amber,
            ),
            child: const MyBanner(),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Tài khoản'),
            onTap: () {
              //close the drawer
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Lịch sử'),
            onTap: () {
              //close the drawer
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistoryScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Sản phẩm yêu thích'),
            onTap: () {
              //close the drawer
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavouriteScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Đăng xuất'),
            onTap: () {
              //close the drawer
              Navigator.pop(context);
              userRepoImpl.signOut();
            },
          ),
        ],
      ),
    );
  }
}
