class OrderUserModel {
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

  OrderUserModel(
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
        this.orderItemsCount});

  OrderUserModel.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
