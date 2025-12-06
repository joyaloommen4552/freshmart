import 'package:flutter/material.dart';
import 'package:freshmart/Models/category_product_model.dart';
import 'package:freshmart/Providers/category_product_provider.dart';
import 'package:freshmart/common/colors.dart';
import 'package:freshmart/common/product_items.dart';
import 'package:provider/provider.dart';

class ProductBottomSheet extends StatelessWidget {
  final int categoryId;
  final String categoryName;
  final void Function(ProductModel, String) onAddToCart;
  final bool isSubCategory;

  const ProductBottomSheet({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.onAddToCart,
    this.isSubCategory = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // White background for entire sheet
      height: MediaQuery.of(context).size.height * 0.85, // Fixed height
      child: Column(
        children: [
          // Header - NO SafeArea, it creates padding
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white, // Header also white
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    categoryName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey, size: 24),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          const Divider(height: 0, thickness: 1),

          // Products List Area
          Expanded(
            child: Container(
              color: Colors.white, // Make list area white too
              child: Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  // Get the products
                  final products = isSubCategory
                      ? productProvider.getSubCategoryProducts(categoryId)
                      : productProvider.getCategoryProducts(categoryId);

                  // Loading state
                  if (productProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Error state
                  if (productProvider.error != null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          productProvider.error!,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  // Empty state
                  if (products.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 50,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 12),
                          Text(
                            "No products available",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }

                  // Products list
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white, // Product card white
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ProductItem(
                          product: products[index],
                          onAddToCart: onAddToCart,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
