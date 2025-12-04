import 'package:flutter/material.dart';
import 'package:freshmart/Providers/authprovider.dart';
import 'package:freshmart/Providers/bill_details_provider.dart';
import 'package:freshmart/Providers/bill_provider.dart';
import 'package:freshmart/Providers/category_product_provider.dart';
import 'package:freshmart/Providers/category_provider.dart';
import 'package:freshmart/Providers/create_acc_provider.dart';
import 'package:freshmart/Providers/order_page_provider.dart';
import 'package:freshmart/Providers/place_order_provider.dart';

import 'package:freshmart/Providers/weight_provider.dart';
import 'package:freshmart/Screens/homepage.dart';
import 'package:freshmart/Screens/login_screen.dart';
import 'package:freshmart/common/screenconfig.dart';
import 'package:freshmart/utils/shared_pref.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final token = await SharedPrefs.getToken();

  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;
  const MyApp({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CreateAccProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => WeightProvider()),
        ChangeNotifierProvider(create: (_) => BillProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()..loadOrders()),
        ChangeNotifierProvider(create: (_) => PlaceOrderProvider()),
        ChangeNotifierProvider(create: (_) => BillDetailProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
        debugShowCheckedModeBanner: false,
        routes: {
          "/login": (context) => const LoginScreen(),
          "/home": (context) => const HomePage(),
        },
        home: Builder(
          builder: (context) {
            ScreenConfig.init(context);

            return token == null ? const LoginScreen() : const HomePage();
          },
        ),
      ),
    );
  }
}
