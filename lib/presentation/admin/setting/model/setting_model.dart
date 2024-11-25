
class SettingModel {
  int? id;
  String? phone;
  String? facebook;
  String? createdAt;
  String? updatedAt;

  SettingModel({this.id, this.phone, this.facebook, this.createdAt, this.updatedAt});

  SettingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
    facebook = json['facebook'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

}
