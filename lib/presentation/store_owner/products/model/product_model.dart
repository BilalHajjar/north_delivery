class ProductModel {
  int? id;
  String? name;
  String? description;
  String? price;
  int? isAvailable;
  String? image;
  int? storeId;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;
  bool? inCart;

  ProductModel(
      {this.id,
        this.name,
        this.description,
        this.price,
        this.isAvailable,
        this.image,
        this.storeId,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.inCart,
        this.imageUrl});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    isAvailable = json['is_available'];
    image = json['image'];
    storeId = json['store_id'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    inCart = json['in_cart'];
    updatedAt = json['updated_at'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['is_available'] = this.isAvailable;
    data['image'] = this.image;
    data['store_id'] = this.storeId;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
