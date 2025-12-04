
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  // Keys
  static const String _keyToken = 'token';
  static const String _keyUserId = 'user_id';
  static const String _keyFlatNo = 'flat_no';
  static const String _keyTowerName = 'tower_name';
  static const String _keyCustomerName = 'customer_name';
  static const String _keyPhoneNo = 'phone_no';

  // Save token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
  }

  // Save user id
  static Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, userId);
  }

  // Save flat number
  static Future<void> saveFlatNo(String flatNo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFlatNo, flatNo);
  }

  // Save tower name
  static Future<void> saveTowerName(String towerName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyTowerName, towerName);
  }

  // Save customer name
  static Future<void> saveCustomerName(String customerName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCustomerName, customerName);
  }

  // Save phone number
  static Future<void> savePhoneNo(String phoneNo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPhoneNo, phoneNo);
  }

  // Get methods
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  static Future<String?> getFlatNo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyFlatNo);
  }

  static Future<String?> getTowerName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyTowerName);
  }

  static Future<String?> getCustomerName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCustomerName);
  }

  static Future<String?> getPhoneNo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPhoneNo);
  }

  // Clear all saved data
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
