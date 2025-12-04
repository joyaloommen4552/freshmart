import 'package:flutter/material.dart';
import 'package:freshmart/Providers/order_page_provider.dart';
import 'package:freshmart/common/order_details_popup.dart';
import 'package:freshmart/common/colors.dart';
import 'package:provider/provider.dart';
import 'package:freshmart/Models/ordermodel.dart';

class PendingDelivery extends StatefulWidget {
  const PendingDelivery({super.key});

  @override
  State<PendingDelivery> createState() => _PendingDeliveryState();
}

class _PendingDeliveryState extends State<PendingDelivery> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<OrderProvider>(context, listen: false).loadOrders(),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "ordered":
        return Colors.orange;
      case "pending":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildCard(OrderModel order) {
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
                  color: _getStatusColor(order.status).withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(
                    color: _getStatusColor(order.status),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            "Time: ${order.time}",
            style: TextStyle(fontSize: 14, color: AppColors.grey),
          ),
          const SizedBox(height: 12),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
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
                  color: AppColors.primary,
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
        final data = orderProv.pendingOrders;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            title: const Text(
              "Pending Orders",
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
                      "No Pending Orders",
                      style: TextStyle(color: AppColors.grey, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (_, i) => _buildCard(data[i]),
                  ),
          ),
        );
      },
    );
  }
}
