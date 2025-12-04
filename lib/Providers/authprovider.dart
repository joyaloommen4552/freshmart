import 'package:flutter/foundation.dart';
import 'package:freshmart/Api/auth_api.dart';
import 'package:freshmart/utils/shared_pref.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String phone) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.authenticate(phone);
      print("API response: $response");

      if (response['status'] == 'success') {
        // Save token & user data
        await SharedPrefs.saveToken(response['token']);
        await SharedPrefs.saveUserId(response['user']['id']);
        await SharedPrefs.saveFlatNo(response['user']['flat_no']);
        await SharedPrefs.saveTowerName(response['user']['tower_name']);
        await SharedPrefs.saveCustomerName(response['user']['customer_name']);
        await SharedPrefs.savePhoneNo(response['user']['phone_no']);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        _errorMessage = response['message'] ?? 'Invalid login credentials';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      final cleanedError = e.toString().replaceAll("Exception:", "").trim();
      _errorMessage = cleanedError.isEmpty
          ? 'Unexpected error occurred. Please try again.'
          : cleanedError;

      notifyListeners();
      return false;
    }
  }
}
