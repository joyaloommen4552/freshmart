import 'package:flutter/material.dart';
import 'package:freshmart/common/colors.dart';
import 'package:freshmart/Models/category_model.dart';
import 'package:freshmart/Providers/category_product_provider.dart';
import 'package:freshmart/Models/category_product_model.dart';
import 'package:freshmart/common/product_items.dart';
import 'package:provider/provider.dart';
import 'product_bottomsheet.dart';

class CategorySection extends StatelessWidget {
  final CategoryModel category;
  final void Function(ProductModel, String) onAddToCart;

  const CategorySection({
    super.key,
    required this.category,
    required this.onAddToCart,
  });

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

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => ProductBottomSheet(
        categoryId: id,
        categoryName: isSubCategory
            ? subCategoryName ?? 'Subcategory Products'
            : category.categoryName,
        onAddToCart: onAddToCart,
        isSubCategory: isSubCategory,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final catId = int.tryParse(category.id);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              if (category.subcategories.isEmpty && catId != null) {
                _openProductSheet(context, catId, false, null);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
              ),
              child: Center(
                child: Text(
                  category.categoryName,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(
            height: 120,
            child: category.subcategories.isNotEmpty
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: category.subcategories.length,
                    itemBuilder: (ctx, idx) {
                      final subCat = category.subcategories[idx];
                      final subCatId = int.tryParse(subCat.subId);

                      return ListTile(
                        title: Text(
                          subCat.subcategoryName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                        ),
                        onTap: () {
                          if (subCatId != null) {
                            _openProductSheet(
                              context,
                              subCatId,
                              true,
                              subCat.subcategoryName,
                            );
                          }
                        },
                      );
                    },
                  )
                : Consumer<ProductProvider>(
                    builder: (_, prodProv, __) {
                      if (prodProv.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (prodProv.error != null) {
                        return Center(child: Text(prodProv.error!));
                      }

                      final products = catId == null
                          ? []
                          : prodProv.getCategoryProducts(catId);

                      if (products.isEmpty) {
                        return const Center(
                          child: Text("Tap category to load products"),
                        );
                      }

                      return ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (ctx, idx) {
                          return ProductItem(
                            product: products[idx],
                            onAddToCart: onAddToCart,
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
