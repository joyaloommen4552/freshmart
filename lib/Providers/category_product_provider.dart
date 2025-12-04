import 'package:flutter/material.dart';
import 'package:freshmart/Api/main_api_serevices.dart';
import 'package:freshmart/Models/category_product_model.dart';

class ProductProvider extends ChangeNotifier {
  bool isLoading = false;
  String? error;

  // Separate maps to avoid mixing category/subcategory products
  final Map<int, List<ProductModel>> _categoryProducts = {};
  final Map<int, List<ProductModel>> _subCategoryProducts = {};

  // Getters
  List<ProductModel> getCategoryProducts(int categoryId) {
    return _categoryProducts[categoryId] ?? [];
  }

  List<ProductModel> getSubCategoryProducts(int subCategoryId) {
    return _subCategoryProducts[subCategoryId] ?? [];
  }

  // Fetch by Category
  Future<void> fetchProductsByCategory(int categoryId) async {
    if (_categoryProducts.containsKey(categoryId)) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final data = await MainApiService.getProductsByCategory(categoryId);
      _categoryProducts[categoryId] = data;
    } catch (e) {
      error = "Failed to load category products";
      _categoryProducts[categoryId] = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Fetch by SubCategory

  //.........................................................................................//
  // p by sub
  Future<void> fetchProductsBySubCategory(int subCategoryId) async {
    if (_subCategoryProducts.containsKey(subCategoryId)) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final data = await MainApiService.getProductsBySubCategory(
        subCategoryId,
      );
      _subCategoryProducts[subCategoryId] = data;
    } catch (e) {
      error = "Failed to load subcategory products";
      _subCategoryProducts[subCategoryId] = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearCache() {
    _categoryProducts.clear();
    _subCategoryProducts.clear();
    notifyListeners();
  }
}
