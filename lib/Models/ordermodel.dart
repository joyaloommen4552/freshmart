class OrderModel {
  final String orderId;
  final String status;
  final String time;
  final List<Map<String, dynamic>> items;

  OrderModel({
    required this.orderId,
    required this.status,
    required this.time,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['order_id'] ?? '',
      status: json['status'] ?? '',
      time: json['Delivered At'] ?? json['Ordered At'] ?? '',
      items: List<Map<String, dynamic>>.from(json['items'] ?? []),
    );
  }
}
