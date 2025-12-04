import 'package:flutter/material.dart';
import 'package:freshmart/Models/bill_model.dart';
import 'package:freshmart/Providers/bill_details_provider.dart';
import 'package:freshmart/common/colors.dart';
import 'package:freshmart/common/screenconfig.dart';
import 'package:provider/provider.dart';

class BillDetailPage extends StatefulWidget {
  final BillModel bill;

  const BillDetailPage({super.key, required this.bill});

  @override
  State<BillDetailPage> createState() => _BillDetailPageState();
}

class _BillDetailPageState extends State<BillDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BillDetailProvider>(
        context,
        listen: false,
      ).fetchBillDetails(widget.bill.billId);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenConfig.init(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text("Bill Details"),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: Consumer<BillDetailProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Text(
                provider.error!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final bill = provider.billDetails;

          if (bill == null) {
            return const Center(child: Text("No bill details available"));
          }

          return Column(
            children: [
              Expanded(
                child: InteractiveViewer(
                  maxScale: 4,
                  child: Image.network(
                    bill.billImageUrl,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                        const Center(child: Icon(Icons.broken_image)),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                color: AppColors.primaryLight.withValues(alpha: 0.2),
                child: Text(
                  "Bill ID: ${bill.billId}\n"
                  "Name: ${bill.customerName}\n"
                  "Date: ${bill.date}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
