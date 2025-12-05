class BillModel {
  final String billId;
  final String customerName;
  final String date;
  final String billImageUrl;

  BillModel({
    required this.billId,
    required this.customerName,
    required this.date,
    required this.billImageUrl,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      billId: json['bill_id'] ?? "",
      customerName: json['customer_name'] ?? "",
      date: json['date'] ?? "",
      billImageUrl: (json['bill_image_url'] ?? "").toString().trim(),
    );
  }
}
