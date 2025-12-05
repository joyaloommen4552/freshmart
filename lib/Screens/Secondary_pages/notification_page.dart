import 'package:flutter/material.dart';
import 'package:freshmart/Models/category_nofification_model.dart';
import 'package:freshmart/Models/sub_category_notifiaction_model.dart';
import 'package:provider/provider.dart';
import 'package:freshmart/common/colors.dart';
import 'package:freshmart/Providers/category_notification_provider.dart';
import 'package:freshmart/Providers/subcategory_notification_provider.dart';

class NotificationPage extends StatelessWidget {
  final int id;
  final bool isSubCategory;
  final String title;

  const NotificationPage({
    super.key,
    required this.id,
    required this.isSubCategory,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final categoryProv = Provider.of<CategoryNotificationProvider>(context);
    final subProv = Provider.of<SubCategoryNotificationProvider>(context);

    final products = isSubCategory
        ? (subProv.notification?.products ??
              <SubCategoryNotificationProduct>[])
        : (categoryProv.notification?.products ??
              <CategoryNotificationProduct>[]);

    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.primary, title: Text(title)),
      body: products.isEmpty
          ? const Center(child: Text("No notifications found"))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: products.length,
              itemBuilder: (_, i) {
                final product = products[i];
                final productName = isSubCategory
                    ? (product as SubCategoryNotificationProduct).name
                    : (product as CategoryNotificationProduct).name;

                return Card(child: ListTile(title: Text(productName)));
              },
            ),
    );
  }
}
