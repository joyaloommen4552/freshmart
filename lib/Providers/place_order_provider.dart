import 'package:flutter/material.dart';
import 'package:freshmart/Api/main_api_serevices.dart';

class PlaceOrderProvider extends ChangeNotifier {
  bool isLoading = false;
  String? orderId;

  Future<bool> submitOrder(List<Map<String, dynamic>> cart) async {
    isLoading = true;
    notifyListeners();

    final result = await MainApiService.placeOrder(cart);

    isLoading = false;
    notifyListeners();

    if (result["status"] == "success") {
      orderId = result["order_id"].toString();
      return true;
    } else {
      return false;
    }
  }
}
