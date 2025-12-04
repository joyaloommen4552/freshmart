import 'package:flutter/material.dart';
import 'package:freshmart/Providers/order_page_provider.dart';
import 'package:freshmart/common/order_details_popup.dart';
import 'package:freshmart/common/colors.dart';
import 'package:provider/provider.dart';
import 'package:freshmart/Models/ordermodel.dart';

class DeliveryCompleted extends StatefulWidget {
  const DeliveryCompleted({super.key});

  @override
  State<DeliveryCompleted> createState() => _DeliveryCompletedState();
}

class _DeliveryCompletedState extends State<DeliveryCompleted> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<OrderProvider>(context, listen: false).loadOrders(),
    );
  }

  Widget _buildCompletedCard(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order ID: ${order.orderId}",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Delivered",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "Delivered At: ${order.time}",
            style: TextStyle(color: AppColors.grey),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              // onPressed: () => showOrderDetailsPopup(context, {
              //   "orderId": order.orderId,
              //   "items": order.items,
              // }),
              onPressed: () async {
                final provider = Provider.of<OrderProvider>(
                  context,
                  listen: false,
                );
                final details = await provider.fetchOrderDetails(
                  order.orderId,
                );

                if (details != null) {
                  showOrderDetailsPopup(context, details);
                }
              },

              child: Text(
                "View Items",
                style: TextStyle(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (ctx, orderProv, _) {
        final data = orderProv.completedOrders;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            title: const Text(
              "Completed Delivery",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 19,
              ),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: orderProv.isLoading
                ? const Center(child: CircularProgressIndicator())
                : data.isEmpty
                ? Center(
                    child: Text(
                      "No Completed Orders",
                      style: TextStyle(color: AppColors.grey, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (_, i) => _buildCompletedCard(data[i]),
                  ),
          ),
        );
      },
    );
  }
}
