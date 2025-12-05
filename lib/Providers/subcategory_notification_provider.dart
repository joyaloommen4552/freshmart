import 'package:flutter/material.dart';
import 'package:freshmart/Api/main_api_serevices.dart';
import 'package:freshmart/Models/sub_category_notifiaction_model.dart';

class SubCategoryNotificationProvider extends ChangeNotifier {
  SubCategoryNotificationModel? notification;
  bool isLoading = false;
  String? error;

  Future<void> loadSubCategoryNotification(int id) async {
    isLoading = true;
    error = null;
    notifyListeners();

    final result = await MainApiService.fetchSubCategoryNotification(id);

    if (result == null) {
      error = "Failed to load subcategory notifications";
    } else {
      notification = result;
    }

    isLoading = false;
    notifyListeners();
  }
}
