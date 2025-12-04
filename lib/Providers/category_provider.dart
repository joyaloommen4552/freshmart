import 'package:flutter/material.dart';
import 'package:freshmart/Api/main_api_serevices.dart';
import '../Models/category_model.dart';

class CategoryProvider extends ChangeNotifier {
  bool isLoading = false;
  List<CategoryModel> categories = [];
  String? error;

  Future<void> fetchCategories() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final data = await MainApiService.getCategoryList();
      categories = data;
    } catch (e) {
      error = e.toString();
      categories = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearCategories() {
    categories.clear();
    notifyListeners();
  }
}
