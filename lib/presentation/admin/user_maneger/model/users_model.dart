class UserModel {
  int? id;
  String? name;
  String? email;
  String? phoneNumber;
  String? createdAt;
  String? updatedAt;
  String? role;

  UserModel(
      {this.id,
        this.name,
        this.email,
        this.phoneNumber,
        this.createdAt,
        this.updatedAt,
        this.role});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['role'] = this.role;
    return data;
  }
}
