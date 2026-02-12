class CartItemModel {
  String id;
  String title;
  String imageUrl;
  String time;
  double rating;
  int reviewCount;
  double price;
  int quantity;

  CartItemModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.time,
    required this.rating,
    required this.reviewCount,
    required this.price,
    this.quantity = 1,
  });
}
