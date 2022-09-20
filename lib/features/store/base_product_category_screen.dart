import 'package:assignment3/features/store/house_ware_tab.dart';
import 'package:assignment3/features/store/meat_tab.dart';
import 'package:assignment3/features/store/vegetable_tab.dart';
import 'package:flutter/material.dart';

class BaseProductCategoryScreen extends StatefulWidget {
  const BaseProductCategoryScreen({Key? key}) : super(key: key);

  @override
  State<BaseProductCategoryScreen> createState() =>
      _BaseProductCategoryScreenState();
}

class _BaseProductCategoryScreenState extends State<BaseProductCategoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              text: 'Rau củ quả',
            ),
            Tab(
              text: 'Thịt cá',
            ),
            Tab(
              text: 'Đồ gia dụng',
            ),
          ],
          indicatorColor: Colors.blue.shade800,
          indicatorWeight: 5,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          VegetableTab(),
          MeatTab(),
          HouseWareTab(),
        ],
      ),
    );
  }
}
