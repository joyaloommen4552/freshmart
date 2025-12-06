import 'package:flutter/material.dart';
import 'package:freshmart/Providers/subcategory_notification_provider.dart';
import 'package:freshmart/Screens/Secondary_pages/notification_page.dart';
import 'package:freshmart/common/colors.dart';
import 'package:freshmart/Models/category_model.dart';
import 'package:freshmart/Providers/category_product_provider.dart';
import 'package:freshmart/Models/category_product_model.dart';
import 'package:freshmart/Providers/category_notification_provider.dart';
import 'package:freshmart/common/product_items.dart';
import 'package:provider/provider.dart';
import 'product_bottomsheet.dart';

class CategorySection extends StatefulWidget {
  final CategoryModel category;
  final void Function(ProductModel, String) onAddToCart;

  const CategorySection({
    super.key,
    required this.category,
    required this.onAddToCart,
  });

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  @override
  void initState() {
    super.initState();

    final catId = int.tryParse(widget.category.id);
    final hasSub = widget.category.subcategories.isNotEmpty;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (catId != null && !hasSub) {
        Provider.of<CategoryNotificationProvider>(
          context,
          listen: false,
        ).loadCategoryNotification(catId);

        Provider.of<ProductProvider>(
          context,
          listen: false,
        ).fetchProductsByCategory(catId);
      }

      for (final sub in widget.category.subcategories) {
        final sid = int.tryParse(sub.subId);
        if (sid != null) {
          Provider.of<SubCategoryNotificationProvider>(
            context,
            listen: false,
          ).loadSubCategoryNotification(sid);
        }
      }
    });
  }

  Future<void> _openProductSheet(
    BuildContext context,
    int id,
    bool isSubCategory,
    String? subCategoryName,
  ) async {
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );

    if (isSubCategory) {
      await productProvider.fetchProductsBySubCategory(id);
    } else {
      await productProvider.fetchProductsByCategory(id);
    }

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white, // ← 1. Make bottom sheet background WHITE
      barrierColor: Colors.black, // ← 2. Make backdrop DARK
      isDismissible: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => ProductBottomSheet(
        categoryId: id,
        categoryName: isSubCategory
            ? subCategoryName ?? 'Subcategory Products'
            : widget.category.categoryName,
        onAddToCart: widget.onAddToCart,
        isSubCategory: isSubCategory,
      ),
    );
  }

  void _openNotificationPage(BuildContext context, int id, bool isSub) {
    // Simply navigate without preloading
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NotificationPage(
          id: id,
          isSubCategory: isSub,
          title: isSub
              ? 'SubCategory Notifications'
              : 'Category Notifications',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final catId = int.tryParse(widget.category.id);
    final hasSub = widget.category.subcategories.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              if (!hasSub && catId != null) {
                _openProductSheet(context, catId, false, null);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              color: AppColors.primary.withAlpha(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left spacer to balance the notification icon
                  if (!hasSub)
                    Consumer<CategoryNotificationProvider>(
                      builder: (_, prov, __) {
                        final count = prov.notification?.count ?? 0;
                        return count > 0
                            ? SizedBox(
                                width:
                                    36, // Same width as the notification icon container
                              )
                            : const SizedBox(width: 36);
                      },
                    )
                  else
                    const SizedBox(
                      width: 36,
                    ), // Balance spacing when no notification
                  // Centered category name
                  Expanded(
                    child: Center(
                      child: Text(
                        widget.category.categoryName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  // Notification icon at right corner
                  if (!hasSub)
                    Consumer<CategoryNotificationProvider>(
                      builder: (_, prov, __) {
                        final count = prov.notification?.count ?? 0;
                        if (catId == null) return const SizedBox(width: 36);

                        return GestureDetector(
                          onTap: () =>
                              _openNotificationPage(context, catId, false),
                          child: Container(
                            width: 36,
                            alignment: Alignment.center,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Notification icon
                                const Icon(
                                  Icons.notifications,
                                  size: 25,
                                  color: Colors.grey,
                                ),

                                // Notification badge
                                if (count > 0)
                                  Positioned(
                                    top: 2,
                                    right: 2,
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 16,
                                        minHeight: 16,
                                      ),
                                      child: Text(
                                        '$count',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  else
                    const SizedBox(
                      width: 36,
                    ), // Spacer when no notification needed
                ],
              ),
            ),
          ),
          SizedBox(
            height: 120,
            child: hasSub
                ? ListView.builder(
                    itemCount: widget.category.subcategories.length,
                    itemBuilder: (ctx, idx) {
                      final sub = widget.category.subcategories[idx];
                      final sid = int.tryParse(sub.subId);

                      return ListTile(
                        title: Text(
                          sub.subcategoryName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Consumer<SubCategoryNotificationProvider>(
                          builder: (_, prov, __) {
                            final count = prov.notification?.count ?? 0;
                            return count > 0
                                ? GestureDetector(
                                    onTap: () => _openNotificationPage(
                                      context,
                                      sid!,
                                      true,
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        const Icon(
                                          Icons.notifications,
                                          size: 25,
                                          color: Colors.grey,
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            constraints: const BoxConstraints(
                                              minWidth: 14,
                                              minHeight: 14,
                                            ),
                                            child: Text(
                                              '$count',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 8,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox.shrink();
                          },
                        ),
                        onTap: () {
                          if (sid != null) {
                            _openProductSheet(
                              context,
                              sid,
                              true,
                              sub.subcategoryName,
                            );
                          }
                        },
                      );
                    },
                  )
                : Consumer<ProductProvider>(
                    builder: (_, productProv, __) {
                      final products = catId == null
                          ? []
                          : productProv.getCategoryProducts(catId);

                      return products.isEmpty
                          ? const Center(
                              child: Text("Tap category to load products"),
                            )
                          : ListView.builder(
                              itemCount: products.length,
                              itemBuilder: (ctx, idx) {
                                return ProductItem(
                                  product: products[idx],
                                  onAddToCart: widget.onAddToCart,
                                );
                              },
                            );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
