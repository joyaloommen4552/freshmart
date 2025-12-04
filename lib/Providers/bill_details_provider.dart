import 'package:flutter/material.dart';
import 'package:freshmart/Api/main_api_serevices.dart';
import 'package:freshmart/Models/bill_model.dart';

class BillDetailProvider extends ChangeNotifier {
  BillModel? billDetails;
  bool isLoading = false;
  String? error;

  Future<void> fetchBillDetails(String billId) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final result = await MainApiService.getBillDetails(billId);
      billDetails = result;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
