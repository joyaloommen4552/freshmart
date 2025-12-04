class SubCategoryModel {
  final String subId;
  final String subcategoryName;

  SubCategoryModel({required this.subId, required this.subcategoryName});

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      subId: json['sub_id']?.toString() ?? '',
      subcategoryName: json['subcategory_name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'sub_id': subId,
    'subcategory_name': subcategoryName,
  };
}
