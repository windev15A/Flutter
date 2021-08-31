class Product {
  Product({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.image,
    this.price,
    this.createdAt,

  });

  int id;
  String name;
  String slug;
  String description;
  String image;
  int price;
  DateTime createdAt;


  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    description: json["description"],
    image: json["image"],
    price: json["price"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "description": description,
    "image": image,
    "price": price,
    "created_at": createdAt.toIso8601String(),

  };
}