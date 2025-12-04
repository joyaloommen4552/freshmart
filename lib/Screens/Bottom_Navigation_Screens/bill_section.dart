import 'package:flutter/material.dart';
import 'package:freshmart/Providers/bill_provider.dart';
import 'package:freshmart/Screens/Secondary_pages/bill_details_page.dart';
import 'package:freshmart/common/colors.dart';
import 'package:freshmart/common/screenconfig.dart';
import 'package:provider/provider.dart';

class BillPage extends StatefulWidget {
  const BillPage({super.key});

  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BillProvider>(context, listen: false).fetchBills();
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenConfig.init(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bills"),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: Consumer<BillProvider>(
        builder: (context, billProvider, _) {
          if (billProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (billProvider.error != null) {
            return Center(
              child: Text(
                billProvider.error!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (billProvider.bills.isEmpty) {
            return const Center(child: Text("No bills available"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: billProvider.bills.length,
            itemBuilder: (context, index) {
              final bill = billProvider.bills[index];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      bill.billImageUrl,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.receipt),
                    ),
                  ),
                  title: Text(
                    bill.customerName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    "Bill ID: ${bill.billId}\nDate: ${bill.date}",
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.secondary,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BillDetailPage(bill: bill),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
