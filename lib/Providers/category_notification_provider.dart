import 'package:flutter/material.dart';
import 'package:freshmart/Api/main_api_serevices.dart';
import 'package:freshmart/Models/category_nofification_model.dart';

class CategoryNotificationProvider extends ChangeNotifier {
  CategoryNotificationModel? notification;
  bool isLoading = false;
  String? error;

  Future<void> loadCategoryNotification(int catId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    final result = await MainApiService.fetchCategoryNotification(catId);

    if (result == null) {
      error = "Failed to load category notifications";
    } else {
      notification = result;
    }

    isLoading = false;
    notifyListeners();
  }
}
