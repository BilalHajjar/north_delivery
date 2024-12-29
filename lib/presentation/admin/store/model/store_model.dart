import 'list_model.dart';

class StoreModel {
  int? id;
  String? name;
  String? description;
  int? userId;
  int? regionId;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;
  List<CategoryModel>? categories;
  ListModel? region;
  User? user;

  StoreModel(
      {this.id,
        this.name,
        this.description,
        this.userId,
        this.regionId,
        this.createdAt,
        this.updatedAt,
        this.imageUrl,
        this.categories,
        this.region,
        this.user});

  StoreModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    userId = json['user_id'];
    regionId = json['region_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageUrl = json['image_url'];
    if (json['categories'] != null) {
      categories = <CategoryModel>[];
      json['categories'].forEach((v) {
        categories!.add(new CategoryModel.fromJson(v));
      });
    }
    region =
    json['region'] != null ? new ListModel.fromJson(json['region']) : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['user_id'] = this.userId;
    data['region_id'] = this.regionId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    if (this.region != null) {
      data['region'] = this.region!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class Categories {
  int? id;
  String? name;
  Pivot? pivot;

  Categories({this.id, this.name, this.pivot});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  int? storeId;
  int? categoryId;

  Pivot({this.storeId, this.categoryId});

  Pivot.fromJson(Map<String, dynamic> json) {
    storeId = json['store_id'];
    categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['store_id'] = this.storeId;
    data['category_id'] = this.categoryId;
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
class CategoryModel {
  int? id;
  String? name;
  String? image;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;

  CategoryModel(
      {this.id,
        this.name,
        this.image,
        this.createdAt,
        this.updatedAt,
        this.imageUrl});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
