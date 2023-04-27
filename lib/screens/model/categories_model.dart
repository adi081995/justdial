// ignore: camel_case_types
class CateModel {
  int status;
  String msg;
  List<Categories> categories;

  CateModel({this.status, this.msg, this.categories});

  CateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['categories'] != null) {
       // ignore: deprecated_member_use
      categories = new List<Categories>();
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  String id;
  String cName;
  String cNameA;
  String icon;
  String img;
  String type;
  bool dataV = false;

  Categories(
      {this.id,
      this.cName,
      this.cNameA,
      this.icon,
      this.img,
      this.type,
      this.dataV});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cName = json['c_name'];
    cNameA = json['c_name_a'];
    icon = json['icon'];
    img = json['img'];
    type = json['type'];
    dataV = json['dataV'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['c_name'] = this.cName;
    data['c_name_a'] = this.cNameA;
    data['icon'] = this.icon;
    data['img'] = this.img;
    data['type'] = this.type;
    data['dataV'] = this.dataV;
    return data;
  }
}
