class CardModel {
  int? id;
  int? userId;
  int? productId;
  int? quantity;
  String? createdAt;
  String? updatedAt;
  Product? product;

  CardModel(
      {this.id,
        this.userId,
        this.productId,
        this.quantity,
        this.createdAt,
        this.updatedAt,
        this.product});

  CardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    productId = json['product_id'];
    quantity = json['quantity'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}

class Product {
  int? id;
  String? name;
  String? price;
  int? isAvailable;
  String? image;
  int? storeId;
  String? imageUrl;
  Store? store;

  Product(
      {this.id,
        this.name,
        this.price,
        this.isAvailable,
        this.image,
        this.storeId,
        this.imageUrl,
        this.store});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    isAvailable = json['is_available'];
    image = json['image'];
    storeId = json['store_id'];
    imageUrl = json['image_url'];
    store = json['store'] != null ? new Store.fromJson(json['store']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['is_available'] = this.isAvailable;
    data['image'] = this.image;
    data['store_id'] = this.storeId;
    data['image_url'] = this.imageUrl;
    if (this.store != null) {
      data['store'] = this.store!.toJson();
    }
    return data;
  }
}

class Store {
  int? id;
  String? name;
  String? image;
  String? imageUrl;

  Store({this.id, this.name, this.image, this.imageUrl});

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
