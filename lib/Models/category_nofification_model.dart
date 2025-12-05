class CategoryNotificationProduct {
  final String id;
  final String name;

  CategoryNotificationProduct({required this.id, required this.name});

  factory CategoryNotificationProduct.fromJson(Map<String, dynamic> json) {
    return CategoryNotificationProduct(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class CategoryNotificationModel {
  final bool status;
  final int count;
  final List<CategoryNotificationProduct> products;

  CategoryNotificationModel({
    required this.status,
    required this.count,
    required this.products,
  });

  factory CategoryNotificationModel.fromJson(Map<String, dynamic> json) {
    List<CategoryNotificationProduct> list = [];

    if (json['products'] is List) {
      list = (json['products'] as List)
          .map(
            (e) => CategoryNotificationProduct.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList();
    }

    return CategoryNotificationModel(
      status: json['status'] ?? false,
      count: json['count'] ?? 0,
      products: list,
    );
  }
}
