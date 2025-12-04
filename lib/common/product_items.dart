import 'package:flutter/material.dart';
import 'package:freshmart/Models/category_product_model.dart';
import 'package:freshmart/common/colors.dart';
import 'package:freshmart/Providers/weight_provider.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  final ProductModel product;
  final void Function(ProductModel, String) onAddToCart;

  const ProductItem({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  void openWeightSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.45,
          minChildSize: 0.30,
          maxChildSize: 0.85,
          expand: false,
          builder: (_, scrollController) {
            return Consumer<WeightProvider>(
              builder: (context, wp, _) {
                if (wp.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (wp.error != null) {
                  return Center(child: Text(wp.error!));
                }

                if (wp.weights.isEmpty) {
                  return const Center(child: Text("No weights available"));
                }

                return Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: wp.weights.length,
                          itemBuilder: (context, index) {
                            String w = wp.weights[index];
                            return ListTile(
                              title: Text(w),
                              trailing: const Icon(Icons.check_circle_outline),
                              onTap: () {
                                Navigator.pop(ctx);
                                onAddToCart(product, w);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => openWeightSelection(context),
      child: Container(
        width: 120,
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '₹${product.price}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
