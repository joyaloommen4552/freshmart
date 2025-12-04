import 'package:flutter/material.dart';
import 'package:freshmart/Providers/place_order_provider.dart';
import 'package:freshmart/common/colors.dart';
import 'package:freshmart/common/screenconfig.dart';
import 'package:provider/provider.dart';

void showOrderSummaryDialog(
  BuildContext context,
  List<Map<String, dynamic>> cart,
  VoidCallback onSubmit,
) {
  ScreenConfig.init(context);

  if (cart.isEmpty) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("No items selected")));
    return;
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => OrderSummaryPopup(cart: cart, onSubmit: onSubmit),
  );
}

class OrderSummaryPopup extends StatelessWidget {
  final List<Map<String, dynamic>> cart;
  final VoidCallback onSubmit;

  const OrderSummaryPopup({
    super.key,
    required this.cart,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    ScreenConfig.init(context);

    return Container(
      height: ScreenConfig.screenHeight * 0.65,
      padding: EdgeInsets.only(
        left: ScreenConfig.blockWidth * 4,
        right: ScreenConfig.blockWidth * 4,
        top: ScreenConfig.blockHeight * 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.grey.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: ScreenConfig.blockHeight * 2),

          Center(
            child: Text(
              "Your Order",
              style: TextStyle(
                fontSize: ScreenConfig.blockWidth * 6,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),

          SizedBox(height: ScreenConfig.blockHeight * 2),

          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (ctx, i) {
                final item = cart[i];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    title: Text(
                      item["name"],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      item["weight"],
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.grey,
                      ),
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        cart.removeAt(i);
                        Navigator.pop(context);
                        showOrderSummaryDialog(context, cart, onSubmit);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: ScreenConfig.blockHeight * 1),

          SizedBox(
            width: double.infinity,
            height: ScreenConfig.blockHeight * 6,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () async {
                final placeorderProvider = Provider.of<PlaceOrderProvider>(
                  context,
                  listen: false,
                );
                Navigator.pop(context);

                final result = await placeorderProvider.submitOrder(cart);

                if (result) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Order Confirmed")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Order Failed")),
                  );
                }
              },

              child: Text(
                "Submit Order",
                style: TextStyle(
                  fontSize: ScreenConfig.blockWidth * 4.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ),
          ),

          SizedBox(height: ScreenConfig.blockHeight * 2),
        ],
      ),
    );
  }
}
