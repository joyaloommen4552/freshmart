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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            // Header
            Text(
              categoryName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const Divider(),

            // Products List
            Expanded(
              child: Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  // Show loading state
                  if (productProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Show error state
                  if (productProvider.error != null) {
                    return Center(child: Text(productProvider.error!));
                  }

                  // Get the correct products based on isSubCategory flag
                  final products = isSubCategory
                      ? productProvider.getSubCategoryProducts(categoryId)
                      : productProvider.getCategoryProducts(categoryId);

                  // Show empty state
                  if (products.isEmpty) {
                    return const Center(
                      child: Text("No products found for this selection"),
                    );
                  }

                  // Show products list using ProductItem widget
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductItem(
                        product: products[index],
                        onAddToCart: onAddToCart,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
