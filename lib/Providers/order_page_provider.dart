// import 'package:flutter/material.dart';
// import 'package:freshmart/Api/main_api_serevices.dart';
// import 'package:freshmart/Models/ordermodel.dart';

// class OrderProvider with ChangeNotifier {
//   List<OrderModel> _pendingOrders = [];
//   List<OrderModel> _completedOrders = [];
//   bool _isLoading = false;

//   bool get isLoading => _isLoading;
//   List<OrderModel> get pendingOrders => _pendingOrders;
//   List<OrderModel> get completedOrders => _completedOrders;

//   Future<void> loadOrders() async {
//     try {
//       _isLoading = true;
//       notifyListeners();

//       final orders = await MainApiService.getOrders();

//       _pendingOrders = orders
//           .where((o) => o.status.toLowerCase() != "delivered")
//           .toList();

//       _completedOrders = orders
//           .where((o) => o.status.toLowerCase() == "delivered")
//           .toList();

//       notifyListeners();
//     } catch (e) {
//       debugPrint("Error Loading Orders: $e");
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   // void markDelivered(OrderModel order) {
//   //   _pendingOrders.remove(order);
//   //   _completedOrders.add(order);
//   //   notifyListeners();
//   // }

// }
import 'package:flutter/material.dart';
import 'package:freshmart/Api/main_api_serevices.dart';
import 'package:freshmart/Models/ordermodel.dart';

class OrderProvider with ChangeNotifier {
  List<OrderModel> _pendingOrders = [];
  List<OrderModel> _completedOrders = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<OrderModel> get pendingOrders => _pendingOrders;
  List<OrderModel> get completedOrders => _completedOrders;

  Future<void> loadOrders() async {
    try {
      _isLoading = true;
      notifyListeners();

      final orders = await MainApiService.getOrders();

      _pendingOrders = orders
          .where((o) => o.status.toLowerCase() != "delivered")
          .toList();

      _completedOrders = orders
          .where((o) => o.status.toLowerCase() == "delivered")
          .toList();

      notifyListeners();
    } catch (e) {
      debugPrint("Error Loading Orders: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void markDelivered(OrderModel order) {
    _pendingOrders.remove(order);
    _completedOrders.add(order);
    notifyListeners();
  }

  //NEW: Fetch single order details via API
  Future<Map<String, dynamic>?> fetchOrderDetails(String orderId) async {
    try {
      final data = await MainApiService.getOrderDetails(orderId);
      return data;
    } catch (e) {
      debugPrint("Error Fetching Order Details: $e");
      return null;
    }
  }
}
