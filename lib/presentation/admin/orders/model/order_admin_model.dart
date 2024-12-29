class OrderAdminModel {
  int? id;
  String? address;
  String? addressLink;
  String? notes;
  String? phoneNumber;
  String? status;
  String? totalPrice;
  int? userId;
  String? createdAt;
  String? updatedAt;
  int? orderItemsCount;
  User? user;
  List<OrderItems>? orderItems;

  OrderAdminModel(
      {this.id,
        this.address,
        this.addressLink,
        this.notes,
        this.phoneNumber,
        this.status,
        this.totalPrice,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.orderItemsCount,
        this.user,
        this.orderItems});

  OrderAdminModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    addressLink = json['address_link'];
    notes = json['notes'];
    phoneNumber = json['phone_number'];
    status = json['status'];
    totalPrice = json['total_price'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    orderItemsCount = json['order_items_count'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['order_items'] != null) {
      orderItems = <OrderItems>[];
      json['order_items'].forEach((v) {
        orderItems!.add(new OrderItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address'] = this.address;
    data['address_link'] = this.addressLink;
    data['notes'] = this.notes;
    data['phone_number'] = this.phoneNumber;
    data['status'] = this.status;
    data['total_price'] = this.totalPrice;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['order_items_count'] = this.orderItemsCount;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;

  User({this.id, this.name, this.email});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    return data;
  }
}

class OrderItems {
  int? id;
  int? orderId;
  int? productId;
  int? quantity;
  String? price;
  String? createdAt;
  String? updatedAt;
  Product? product;

  OrderItems(
      {this.id,
        this.orderId,
        this.productId,
        this.quantity,
        this.price,
        this.createdAt,
        this.updatedAt,
        this.product});

  OrderItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    quantity = json['quantity'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
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
  int? storeId;
  Store? store;

  Product({this.id, this.name, this.price, this.storeId, this.store});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    storeId = json['store_id'];
    store = json['store'] != null ? new Store.fromJson(json['store']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['store_id'] = this.storeId;
    if (this.store != null) {
      data['store'] = this.store!.toJson();
    }
    return data;
  }
}

class Store {
  int? id;
  String? name;

  Store({this.id, this.name});

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
