class AdsModel {
  int? id;
  String? image;
  int? isActive;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;

  AdsModel(
      {this.id,
        this.image,
        this.isActive,
        this.createdAt,
        this.updatedAt,
        this.imageUrl});

  AdsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
