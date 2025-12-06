import 'package:flutter/material.dart';
import 'package:freshmart/Models/category_nofification_model.dart';
import 'package:freshmart/Models/sub_category_notifiaction_model.dart';
import 'package:provider/provider.dart';
import 'package:freshmart/common/colors.dart';
import 'package:freshmart/Providers/category_notification_provider.dart';
import 'package:freshmart/Providers/subcategory_notification_provider.dart';

class NotificationPage extends StatefulWidget {
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
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNotificationData();
    });
  }

  Future<void> _loadNotificationData() async {
    try {
      if (widget.isSubCategory) {
        await Provider.of<SubCategoryNotificationProvider>(
          context,
          listen: false,
        ).loadSubCategoryNotification(widget.id);
      } else {
        await Provider.of<CategoryNotificationProvider>(
          context,
          listen: false,
        ).loadCategoryNotification(widget.id);
      }
    } catch (e) {
      print('Error loading notification data: $e');
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(widget.title),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    final categoryProv = Provider.of<CategoryNotificationProvider>(context);
    final subProv = Provider.of<SubCategoryNotificationProvider>(context);

    final products = widget.isSubCategory
        ? (subProv.notification?.products ??
              <SubCategoryNotificationProduct>[])
        : (categoryProv.notification?.products ??
              <CategoryNotificationProduct>[]);

    return products.isEmpty
        ? const Center(child: Text("No notifications found"))
        : RefreshIndicator(
            onRefresh: _loadNotificationData,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: products.length,
              itemBuilder: (_, i) {
                final product = products[i];
                final productName = widget.isSubCategory
                    ? (product as SubCategoryNotificationProduct).name
                    : (product as CategoryNotificationProduct).name;

                return Card(child: ListTile(title: Text(productName)));
              },
            ),
          );
  }
}
