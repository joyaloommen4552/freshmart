import 'package:flutter/material.dart';
import 'package:freshmart/Providers/create_acc_provider.dart';
import 'package:freshmart/common/colors.dart';
import 'package:freshmart/common/screenconfig.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController flatNumberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  List<String> towers = [];
  String? selectedTower;
  bool isTowerLoading = false;

  @override
  void initState() {
    super.initState();
    fetchTowers();
  }

  Future<void> fetchTowers() async {
    setState(() {
      isTowerLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse("https://design-pods.com/flatgrocery/public/tower_api.php"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["status"] == "success" && data["tower"] != null) {
          setState(() {
            towers = List<String>.from(data["tower"]);
          });
        }
      }
    } catch (e) {
      debugPrint("Tower fetch error: $e");
    }

    setState(() {
      isTowerLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenConfig.init(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: Text(
          "Create Account",
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenConfig.blockWidth * 5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(ScreenConfig.blockWidth * 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ScreenConfig.blockHeight * 2),

            _label("Flat Number"),
            _inputField(
              controller: flatNumberController,
              hint: "Enter your flat number",
              keyboard: TextInputType.text,
            ),

            SizedBox(height: ScreenConfig.blockHeight * 2),

            _label("Select Tower"),
            isTowerLoading
                ? const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : _towerDropdown(),

            SizedBox(height: ScreenConfig.blockHeight * 2),

            _label("Customer Name"),
            _inputField(
              controller: nameController,
              hint: "Enter full name",
              keyboard: TextInputType.name,
            ),

            SizedBox(height: ScreenConfig.blockHeight * 2),

            _label("Mobile Number"),
            _inputField(
              controller: phoneController,
              hint: "Enter mobile number",
              keyboard: TextInputType.phone,
              maxLength: 10,
            ),

            SizedBox(height: ScreenConfig.blockHeight * 4),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(
                    vertical: ScreenConfig.blockHeight * 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _submitForm,
                child: Consumer<CreateAccProvider>(
                  builder: (context, provider, _) {
                    return provider.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Create Account",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenConfig.blockWidth * 4.5,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenConfig.blockHeight * 0.8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: ScreenConfig.blockWidth * 4.3,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required TextInputType keyboard,
    int? maxLength,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      maxLength: maxLength,
      decoration: InputDecoration(
        counterText: "",
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: ScreenConfig.blockWidth * 4,
          vertical: ScreenConfig.blockHeight * 2,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _towerDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenConfig.blockWidth * 4,
        vertical: ScreenConfig.blockHeight * 1.5,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedTower,
          hint: const Text("Select Tower"),
          isExpanded: true,
          items: towers.map((tower) {
            return DropdownMenuItem(value: tower, child: Text(tower));
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedTower = value;
            });
          },
        ),
      ),
    );
  }

  void _submitForm() async {
    if (flatNumberController.text.isEmpty ||
        nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        selectedTower == null) {
      _showError("Please fill all details");
      return;
    }

    if (phoneController.text.length != 10) {
      _showError("Enter a valid 10-digit mobile number");
      return;
    }

    final provider = Provider.of<CreateAccProvider>(context, listen: false);

    try {
      final response = await provider.createAccount(
        flatNo: flatNumberController.text.trim(),
        towerName: selectedTower!,
        customerName: nameController.text.trim(),
        phoneNo: phoneController.text.trim(),
      );

      if (response["status"] == "success") {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response["message"])));

        Navigator.pop(context);
      } else {
        _showError(response["message"] ?? "Unexpected error");
      }
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }
}
