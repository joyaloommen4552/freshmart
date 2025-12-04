import 'package:flutter/material.dart';
import 'package:freshmart/Screens/Bottom_Navigation_Screens/bill_section.dart';
import 'package:freshmart/Screens/Bottom_Navigation_Screens/delivery_completed.dart';
import 'package:freshmart/Screens/Bottom_Navigation_Screens/orders_page.dart';
import 'package:freshmart/Screens/Bottom_Navigation_Screens/pending_delivery.dart';
import '../common/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    OrdersPage(),
    PendingDelivery(),
    DeliveryCompleted(),
    BillPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: _screens[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        selectedFontSize: 12,
        unselectedFontSize: 11,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront_rounded),
            label: "Order",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pending_actions_rounded),
            label: "Pending",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: "Completed",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: "Bill",
          ),
        ],
      ),
    );
  }
}
