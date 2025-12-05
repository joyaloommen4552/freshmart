class SubCategoryNotificationProduct {
  final String id;
  final String name;

  SubCategoryNotificationProduct({required this.id, required this.name});

  factory SubCategoryNotificationProduct.fromJson(Map<String, dynamic> json) {
    return SubCategoryNotificationProduct(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class SubCategoryNotificationModel {
  final bool status;
  final int count;
  final List<SubCategoryNotificationProduct> products;

  SubCategoryNotificationModel({
    required this.status,
    required this.count,
    required this.products,
  });

  factory SubCategoryNotificationModel.fromJson(Map<String, dynamic> json) {
    List<SubCategoryNotificationProduct> list = [];

    if (json['products'] is List) {
      list = (json['products'] as List)
          .map(
            (e) => SubCategoryNotificationProduct.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList();
    }

    return SubCategoryNotificationModel(
      status: json['status'] ?? false,
      count: json['count'] ?? 0,
      products: list,
    );
  }
}
