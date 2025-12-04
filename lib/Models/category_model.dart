import 'subcategory_model.dart';

class CategoryModel {
  final String id;
  final String categoryName;
  final List<SubCategoryModel> subcategories;

  CategoryModel({
    required this.id,
    required this.categoryName,
    required this.subcategories,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final subs = <SubCategoryModel>[];
    if (json['subcategories'] is List) {
      for (final s in (json['subcategories'] as List)) {
        if (s is Map<String, dynamic>) {
          subs.add(SubCategoryModel.fromJson(s));
        } else if (s is Map) {
          subs.add(SubCategoryModel.fromJson(Map<String, dynamic>.from(s)));
        }
      }
    }

    return CategoryModel(
      id: json['id']?.toString() ?? '',
      categoryName: json['category_name']?.toString() ?? '',
      subcategories: subs,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'category_name': categoryName,
    'subcategories': subcategories.map((s) => s.toJson()).toList(),
  };
}
