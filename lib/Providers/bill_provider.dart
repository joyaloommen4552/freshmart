import 'package:flutter/material.dart';
import 'package:freshmart/Api/main_api_serevices.dart';
import 'package:freshmart/Models/bill_model.dart';

class BillProvider extends ChangeNotifier {
  List<BillModel> bills = [];
  bool isLoading = false;
  String? error;

  Future<void> fetchBills() async {
    try {
      isLoading = true;
      notifyListeners();

      bills = await MainApiService.getBills();
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
