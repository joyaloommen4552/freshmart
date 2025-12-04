import 'package:flutter/material.dart';
import 'package:freshmart/Providers/category_provider.dart';
import 'package:freshmart/Providers/category_product_provider.dart';
import 'package:freshmart/Providers/weight_provider.dart';
import 'package:freshmart/Screens/Secondary_pages/category_section.dart';
import 'package:freshmart/common/colors.dart';
import 'package:freshmart/common/order_summary_pop.dart';
import 'package:freshmart/utils/logout_helper.dart';
import 'package:freshmart/Models/category_model.dart';
import 'package:freshmart/Models/category_product_model.dart';
import 'package:freshmart/utils/shared_pref.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  String? customerName;
  List<Map<String, dynamic>> cart = [];
  bool _hasPrefetchedProducts = false;

  @override
  void initState() {
    super.initState();
    _loadCustomerName();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialLoad();
    });
  }

  Future<void> _loadCustomerName() async {
    final name = await SharedPrefs.getCustomerName();
    setState(() => customerName = name ?? "Guest");
  }

  Future<void> _prefetchCategoryProducts(
    List<CategoryModel> categories,
  ) async {
    final prod = Provider.of<ProductProvider>(context, listen: false);

    for (var c in categories) {
      final id = int.tryParse(c.id);
      if (id != null) {
        await prod.fetchProductsByCategory(id);
      }
    }
    setState(() => _hasPrefetchedProducts = true);
  }

  void addToCart(ProductModel product, String weight) {
    setState(() {
      cart.add({
        "name": product.name,
        "price": product.price,
        "weight": weight,
      });
    });
  }

  // Initial data load
  Future<void> _initialLoad() async {
    await Provider.of<CategoryProvider>(
      context,
      listen: false,
    ).fetchCategories();
    await Provider.of<WeightProvider>(context, listen: false).fetchWeights();
  }

  // Pull-to-refresh function
  Future<void> _handleRefresh() async {
    // Clear all caches
    Provider.of<ProductProvider>(context, listen: false).clearCache();

    // Reset prefetch flag
    setState(() {
      _hasPrefetchedProducts = false;
    });

    await Future.wait([
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories(),
      Provider.of<WeightProvider>(context, listen: false).fetchWeights(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final catProv = Provider.of<CategoryProvider>(context);

    if (!_hasPrefetchedProducts &&
        !catProv.isLoading &&
        catProv.categories.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _prefetchCategoryProducts(catProv.categories),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(14),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => showOrderSummaryDialog(context, cart, () {
            setState(() => cart.clear());
          }),
          child: const Text(
            "ORDER NOW",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Hi ${customerName ?? ""}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.red),
                    onPressed: () => LogoutHelper.showLogoutDialog(context),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                // PULL-TO-REFRESH IMPLEMENTATION
                child: RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: catProv.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : catProv.categories.isEmpty
                      ? const Center(
                          child: Text(
                            'No categories found\nPull down to refresh',
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.separated(
                          itemCount: catProv.categories.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 14),
                          itemBuilder: (ctx, i) => CategorySection(
                            category: catProv.categories[i],
                            onAddToCart: addToCart,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
