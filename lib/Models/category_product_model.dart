class ProductModel {
  final String id;
  final String name;
  final String price; // Store as string
  final int categoryId;
  final String subCategory;
  final String priceType; // Track which field was used

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.categoryId,
    required this.subCategory,
    required this.priceType, // Add this
  });

  factory ProductModel.fromJson(Map<String, dynamic> json, int categoryId) {
    // Check which price field exists
    String priceValue;
    String priceType;

    if (json['new_price'] != null) {
      // Sub-category API
      priceValue = json['new_price']?.toString() ?? "0.00";
      priceType = 'new_price';
    } else if (json['price_per_kg'] != null) {
      // Category API
      priceValue = json['price_per_kg']?.toString() ?? "0.00";
      priceType = 'price_per_kg';
    } else {
      // Default
      priceValue = "0.00";
      priceType = 'unknown';
    }

    return ProductModel(
      id: json['id']?.toString() ?? "",
      name: json['name']?.toString() ?? "",
      price: priceValue,
      categoryId: categoryId,
      subCategory: json['subcategory']?.toString() ?? "",
      priceType: priceType, // Store which type
    );
  }

  // Helper getter for formatted price display
  String get formattedPrice {
    if (priceType == 'price_per_kg') {
      return '₹$price/kg';
    } else if (priceType == 'new_price') {
      return '₹$price';
    } else {
      return '₹$price';
    }
  }
}
