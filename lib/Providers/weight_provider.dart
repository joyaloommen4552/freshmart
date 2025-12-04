import 'package:flutter/material.dart';
import 'package:freshmart/Api/main_api_serevices.dart';

class WeightProvider extends ChangeNotifier {
  bool isLoading = false;
  List<String> weights = [];
  String? error;

  Future<void> fetchWeights() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final data = await MainApiService.getWeights();
      weights = data;
    } catch (e) {
      error = e.toString();
      weights = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
