import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://design-pods.com/flatgrocery/public/";

  static final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Connection': 'keep-alive',
  };

  // LOGIN / AUTHENTICATION ...... finished

  static Future<Map<String, dynamic>> authenticate(String phone) async {
    final String url = "${baseUrl}login.php";

    final body = jsonEncode({"mobile": phone});

    try {
      final response = await http
          .post(Uri.parse(url), headers: headers, body: body)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw HttpException(
          'Failed to authenticate: ${response.statusCode}',
          uri: Uri.parse(url),
        );
      }
    } on SocketException {
      throw Exception("No Internet connection. Please check your network.");
    } on TimeoutException {
      throw Exception("Connection timed out. Please try again later.");
    } on FormatException {
      throw Exception("Invalid response format from server.");
    } catch (e) {
      throw Exception("Something went wrong: $e");
    }
  }

  // REGISTER USER........ finished

  static Future<Map<String, dynamic>> registerUser(
    String flatNo,
    String towerName,
    String customerName,
    String phoneNo,
  ) async {
    final String url = "${baseUrl}register.php";

    final body = jsonEncode({
      "flat_no": flatNo,
      "tower_name": towerName,
      "customer_name": customerName,
      "phone_no": phoneNo,
    });

    try {
      final response = await http
          .post(Uri.parse(url), headers: headers, body: body)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw HttpException(
          'Failed to register user: ${response.statusCode}',
          uri: Uri.parse(url),
        );
      }
    } on SocketException {
      throw Exception("No Internet connection. Please check your network.");
    } on TimeoutException {
      throw Exception("Connection timed out. Please try again later.");
    } on FormatException {
      throw Exception("Invalid response format from server.");
    } catch (e) {
      throw Exception("Something went wrong: $e");
    }
  }

  // get tower response ..... finished
  static Future<Map<String, dynamic>> getTowers() async {
    final uri = Uri.parse("${baseUrl}tower_api.php");
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load towers");
    }
  }
}
