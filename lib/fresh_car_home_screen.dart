import 'package:assignment3/features/home/home_screen.dart';
import 'package:assignment3/features/store/store_screen.dart';
import 'package:assignment3/main.dart';
import 'package:assignment3/widgets/my_app_bar.dart';
import 'package:assignment3/widgets/my_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_model/cart_viewmodel.dart';

class FreshCarHomeScreen extends StatefulWidget {
  const FreshCarHomeScreen({Key? key}) : super(key: key);

  @override
  State<FreshCarHomeScreen> createState() => _FreshCarHomeScreenState();
}

class _FreshCarHomeScreenState extends State<FreshCarHomeScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Provider.of<CartViewModel>(context, listen: false).initialCart();
  } // List<Widget> listTab = [];

  Widget getBody() {
    if (selectedIndex == 0) {
      return const HomeScreen();
    } else if (selectedIndex == 1) {
      return const StoreScreen();
    }
    return const HomeScreen();
  }

  void _onItemTapped(int value) => setState(() => selectedIndex = value);

  @override
  Widget build(BuildContext context) {
    // return CupertinoTabScaffold(
    //     resizeToAvoidBottomInset: true,
    //     controller: _tabController,
    //     tabBar: CupertinoTabBar(
    //       items: const <BottomNavigationBarItem>[
    //         BottomNavigationBarItem(
    //           icon: Icon(Icons.home),
    //           label: 'Home',
    //         ),
    //         BottomNavigationBarItem(
    //           icon: Icon(Icons.store),
    //           label: 'Store',
    //         ),
    //       ],
    //     ),
    //     tabBuilder: (BuildContext context, int index) {
    //       return listTab[_tabController.index];
    //     },
    //
    // );
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: const MyDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFloatingActionButton(),
      body: getBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        setState(() {
          FreshCar.isDark = !FreshCar.isDark;
          darkNotifier.value = FreshCar.isDark;
        });
      },
      child: Icon(FreshCar.isDark ? Icons.wb_sunny_outlined : Icons.dark_mode),
    );
  }

  TabBarView _buildBody() {
    return TabBarView(
      controller: _tabController,
      children: const [
        HomeScreen(),
        StoreScreen(),
      ],
    );
  }

  TabBar _buildTabBar() {
    return TabBar(
      controller: _tabController,
      labelColor: Colors.blue.shade700,
      unselectedLabelStyle:
          const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      tabs: const [
        Tab(
          icon: Icon(
            Icons.home,
            size: 30,
          ),
          text: "HOME",
        ),
        Tab(
          icon: Icon(
            Icons.store,
            size: 30,
          ),
          text: "STORE",
        ),
      ],
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 25,
            ),
            label: "HOME"),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.store,
              size: 25,
            ),
            label: "STORE"),
      ],
      currentIndex: selectedIndex,
      type: BottomNavigationBarType.fixed,
      onTap: _onItemTapped,
      unselectedLabelStyle:
          const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      selectedLabelStyle:
          const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    );
  }
}
