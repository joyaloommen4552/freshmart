import 'dart:async';
import 'dart:convert';
import 'package:freshmart/Models/bill_model.dart';
import 'package:freshmart/Models/ordermodel.dart';
import 'package:freshmart/utils/shared_pref.dart';
import 'package:http/http.dart' as http;
import '../Models/category_model.dart';
import '../Models/category_product_model.dart';

class MainApiService {
  static const String _baseUrl = "https://design-pods.com/flatgrocery/public/";

  // Build headers: include Content-Type and Authorization from SharedPrefs.
  static Future<Map<String, String>> _buildHeaders() async {
    final token = await SharedPrefs.getToken(); // returns null or string
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
    };

    if (token != null && token.trim().isNotEmpty) {
      final trimmed = token.trim();
      // If stored token already begins with 'Bearer ' (case-insensitive), use as-is
      final isBearer = RegExp(
        r'^(Bearer\s)',
        caseSensitive: false,
      ).hasMatch(trimmed);
      headers['Authorization'] = isBearer ? trimmed : 'Bearer $trimmed';
    }

    return headers;
  }

  // Fetch categories
  static Future<List<CategoryModel>> getCategoryList() async {
    final uri = Uri.parse("${_baseUrl}category_api.php");
    final headers = await _buildHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Failed to load categories: ${response.statusCode}');
    }

    final body = response.body;
    final jsonData = jsonDecode(body);

    // your sample response: { "status": true, "message": "...", "data": [...] }
    final data = jsonData['data'];
    if (data is List) {
      return data.map((e) {
        if (e is Map<String, dynamic>) return CategoryModel.fromJson(e);
        return CategoryModel.fromJson(Map<String, dynamic>.from(e));
      }).toList();
    } else {
      return <CategoryModel>[];
    }
  }

  // Fetch weights
  static Future<List<String>> getWeights() async {
    final uri = Uri.parse("${_baseUrl}weight_api.php");
    final headers = await _buildHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception('Failed to load weights: ${response.statusCode}');
    }

    final jsonData = jsonDecode(response.body);
    // sample: {"status":"success","count":9,"weights":["3kg","50g",...]}
    final weights = jsonData['weights'];
    if (weights is List) {
      return weights.map((e) => e?.toString() ?? '').toList();
    } else {
      return <String>[];
    }
  }

  ///////products bu catogory screen...................................completed
  ///
  static Future<List<ProductModel>> getProductsByCategory(
    int categoryId,
  ) async {
    final uri = Uri.parse(
      "${_baseUrl}products_by_category.php?cid=$categoryId",
    );
    final headers = await _buildHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception("Failed to load products");
    }

    final jsonData = jsonDecode(response.body);

    if (jsonData['products'] == null) return [];

    List<ProductModel> products = (jsonData['products'] as List)
        .map(
          (p) =>
              ProductModel.fromJson(Map<String, dynamic>.from(p), categoryId),
        )
        .toList();

    return products;
  }

  //products by sub catogory screen ................................... on going
  static Future<List<ProductModel>> getProductsBySubCategory(
    int subCategoryId,
  ) async {
    final uri = Uri.parse(
      "${_baseUrl}getproducts_api.php?sub_id=$subCategoryId",
    );

    final headers = await _buildHeaders();

    final response = await http
        .get(uri, headers: headers)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to load products by sub category: ${response.statusCode}",
      );
    }

    final jsonData = jsonDecode(response.body);

    // Handle API error case
    if (jsonData is Map &&
        (jsonData['status'] == 'error' || jsonData['status'] == false)) {
      final msg = jsonData['message']?.toString() ?? 'Unknown error';
      throw Exception('API error: $msg');
    }

    // Parse products list
    final products = jsonData['products'];
    if (products is List) {
      return products.map((p) {
        if (p is Map<String, dynamic>) {
          return ProductModel.fromJson(p, subCategoryId);
        }
        return ProductModel.fromJson(
          Map<String, dynamic>.from(p),
          subCategoryId,
        );
      }).toList();
    }

    return <ProductModel>[];
  }

  //bill api main
  static Future<List<BillModel>> getBills() async {
    final headers = await _buildHeaders(); // include Authorization token
    final url = Uri.parse("${_baseUrl}bill_list_api.php");

    final response = await http.get(url, headers: headers);

    if (response.statusCode != 200) {
      throw Exception("Failed to load bills");
    }

    final jsonData = jsonDecode(response.body);

    if (jsonData['status'] != "success") {
      return [];
    }

    List<dynamic> data = jsonData['bills'] ?? [];

    return data.map((bill) => BillModel.fromJson(bill)).toList();
  }

  static Future<BillModel> getBillDetails(String billId) async {
    final headers = await _buildHeaders();
    final url = Uri.parse("${_baseUrl}viewbill_api.php?bill_id=$billId");

    final response = await http.get(url, headers: headers);

    if (response.statusCode != 200) {
      throw Exception("Failed to load bill details");
    }

    final jsonData = jsonDecode(response.body);

    if (jsonData['status'] != "success") {
      throw Exception("Bill not found");
    }

    return BillModel.fromJson(jsonData);
  }

  // order ststus api
  static Future<List<OrderModel>> getOrders() async {
    final uri = Uri.parse("${_baseUrl}orders_api.php");
    final headers = await _buildHeaders();

    final response = await http.get(uri, headers: headers);

    if (response.statusCode != 200) {
      throw Exception("Orders Fetch Failed: ${response.statusCode}");
    }

    final jsonData = jsonDecode(response.body);

    if (jsonData['orders'] == null) return [];

    return (jsonData['orders'] as List)
        .map((o) => OrderModel.fromJson(Map<String, dynamic>.from(o)))
        .toList();
  }

  // get order details like items
  static Future<Map<String, dynamic>> getOrderDetails(String orderId) async {
    final url = Uri.parse(
      "${_baseUrl}vieworder_details_api.php?order_id=$orderId",
    );
    final headers = await _buildHeaders();

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["status"] == "success") {
        return {"orderId": data["order_id"], "items": data["items"]};
      }
    }

    return {"items": []};
  }

  // Placeing order
  static Future<Map<String, dynamic>> placeOrder(
    List<Map<String, dynamic>> cart,
  ) async {
    final url = Uri.parse("${_baseUrl}placeorder_api.php");

    // Fetch required shared values
    final userId = await SharedPrefs.getUserId();
    final tower = await SharedPrefs.getTowerName();
    final flatNo = await SharedPrefs.getFlatNo();

    // Request body
    final body = {
      "user_id": userId ?? "0",
      "tower": tower ?? "",
      "flat_number": flatNo ?? "",
      "products": cart
          .map((item) => {"name": item["name"], "weight": item["weight"]})
          .toList(),
    };

    final headers = await _buildHeaders();

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {"status": "error", "message": "Failed: ${response.statusCode}"};
    }
  }
}
