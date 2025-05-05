

class CategoryModel {
  final String title;
  final String? image, svgSrc;
  final List<CategoryModel>? subCategories;

  CategoryModel({
    required this.title,
    this.image,
    this.svgSrc,
    this.subCategories,
  });
}

class Category {
  final int id;
  final String title;
  final int isParent;
  final int? parentId;
  final String? image;
  final String? svgSrc;
  final List<Category> children;

  Category({
    required this.id,
    required this.title,
    required this.isParent,
    required this.children,
    this.parentId,
    this.image,
    this.svgSrc,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: json['title'],
      children: (json['child_cat'] as List?)
              ?.map((child) => Category.fromJson(child))
              .toList() ??
          [],
      isParent: json['is_parent'],
      parentId: json['parent_id'],
      image: json['photo'],
      svgSrc: 'assets/icons/cate.svg', // Gán giá trị mặc định cho svgSrc
    );
  }
}

final List<CategoryModel> demoCategoriesWithImage = [
  CategoryModel(title: "Woman’s", image: "https://i.imgur.com/5M89G2P.png"),
  CategoryModel(title: "Man’s", image: "https://i.imgur.com/UM3GdWg.png"),
  CategoryModel(title: "Kid’s", image: "https://i.imgur.com/Lp0D6k5.png"),
  CategoryModel(title: "Accessories", image: "https://i.imgur.com/3mSE5sN.png"),
];

final List<CategoryModel> demoCategories = [
  CategoryModel(
    title: "On sale",
    svgSrc: "assets/icons/Sale.svg",
    subCategories: [
      CategoryModel(title: "All Clothing"),
      CategoryModel(title: "New In"),
      CategoryModel(title: "Coats & Jackets"),
      CategoryModel(title: "Dresses"),
      CategoryModel(title: "Jeans"),
    ],
  ),
  CategoryModel(
    title: "Man’s & Woman’s",
    svgSrc: "assets/icons/Man&Woman.svg",
    subCategories: [
      CategoryModel(title: "All Clothing"),
      CategoryModel(title: "New In"),
      CategoryModel(title: "Coats & Jackets"),
    ],
  ),
  CategoryModel(
    title: "Kids",
    svgSrc: "assets/icons/Child.svg",
    subCategories: [
      CategoryModel(title: "All Clothing"),
      CategoryModel(title: "New In"),
      CategoryModel(title: "Coats & Jackets"),
    ],
  ),
  CategoryModel(
    title: "Accessories",
    svgSrc: "assets/icons/Accessories.svg",
    subCategories: [
      CategoryModel(title: "All Clothing"),
      CategoryModel(title: "New In"),
    ],
  ),
];
