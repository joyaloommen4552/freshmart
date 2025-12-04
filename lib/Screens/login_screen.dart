import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:freshmart/Providers/authprovider.dart';
import 'package:freshmart/Screens/create_account.dart';
import 'package:freshmart/Screens/homepage.dart';
import 'package:freshmart/common/colors.dart';
import 'package:freshmart/common/screenconfig.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenConfig.init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenConfig.blockWidth * 6,
            vertical: ScreenConfig.blockHeight * 4,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: ScreenConfig.blockHeight * 6),

              Lottie.asset(
                "assets/lottie/Login.json",
                height: ScreenConfig.blockHeight * 50,
              ),
              Text(
                "Welcome to FreshMart",
                style: TextStyle(
                  fontSize: ScreenConfig.blockWidth * 6,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),

              SizedBox(height: ScreenConfig.blockHeight * 1),
              Text(
                "Enter your phone number to continue",
                style: TextStyle(
                  fontSize: ScreenConfig.blockWidth * 4,
                  color: Colors.grey.shade600,
                ),
              ),

              SizedBox(height: ScreenConfig.blockHeight * 4),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenConfig.blockWidth * 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: Row(
                  children: [
                    Text(
                      "+91",
                      style: TextStyle(
                        fontSize: ScreenConfig.blockWidth * 4.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: ScreenConfig.blockWidth * 3),
                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        decoration: InputDecoration(
                          hintText: "Enter phone number",
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          border: InputBorder.none,
                          counterText: '',
                        ),
                      ),
                    ),
                  ],
                ),
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
                  onPressed: () async {
                    final phone = phoneController.text.trim();

                    if (phone.length != 10) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Enter a valid 10-digit phone number"),
                        ),
                      );
                      return;
                    }

                    final authProvider = Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    );

                    final success = await authProvider.login(phone);

                    if (!mounted) return;

                    if (success) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const HomePage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            authProvider.errorMessage ?? 'Login failed',
                          ),
                        ),
                      );
                    }
                  },

                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: ScreenConfig.blockWidth * 4.5,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: ScreenConfig.blockHeight * 4),
              RichText(
                text: TextSpan(
                  text: "Don't have an account ?  ",
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: "Register",
                      style: TextStyle(color: AppColors.secondary),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateAccountPage(),
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
