import 'package:flutter/material.dart';
import 'package:freshmart/utils/shared_pref.dart';

class LogoutHelper {
  static void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await logoutProcess(context);
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  static Future<void> logoutProcess(BuildContext context) async {
    await SharedPrefs.clearAll();

    Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
  }
}
