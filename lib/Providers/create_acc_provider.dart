import 'package:flutter/foundation.dart';
import 'package:freshmart/Api/auth_api.dart';

class CreateAccProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<String> _towerList = [];
  List<String> get towerList => _towerList;

  bool _isTowerLoading = false;
  bool get isTowerLoading => _isTowerLoading;

  String? _towerError;
  String? get towerError => _towerError;

  Future<void> fetchTowers() async {
    _isTowerLoading = true;
    _towerError = null;
    notifyListeners();

    try {
      final response = await ApiService.getTowers(); // new api call

      if (response["status"] == "success") {
        _towerList = List<String>.from(response["tower"]);
      } else {
        _towerError = "Unable to load towers";
      }
    } catch (e) {
      _towerError = e.toString();
    }

    _isTowerLoading = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> createAccount({
    required String flatNo,
    required String towerName,
    required String customerName,
    required String phoneNo,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.registerUser(
        flatNo,
        towerName,
        customerName,
        phoneNo,
      );

      _isLoading = false;
      notifyListeners();
      return response;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception(e.toString());
    }
  }
}
