import 'package:flutter/material.dart';
import 'package:pos_superbootcamp/common/themes/app_color.dart';
import 'package:pos_superbootcamp/presentation/home/home_screen.dart';
import 'package:pos_superbootcamp/presentation/inventory/inventory_screen.dart';
import 'package:pos_superbootcamp/presentation/report/report_screen.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);

  final List<Widget> _pages = [
    HomeScreen(),
    InventoryScreen(),
    ReportScreen(),
  ];

  void _onItemTapped(int index) {
    _selectedIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _selectedIndex,
      builder: (context, value, _) {
        return Scaffold(
          backgroundColor: AppColor.white,
          body: _pages[_selectedIndex.value],
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: AppColor.white,
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex.value,
            selectedItemColor: AppColor.primary,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.inventory_rounded),
                label: 'Inventory',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_chart_rounded),
                label: 'Report',
              ),
            ],
          ),
        );
      },
    );
  }
}
