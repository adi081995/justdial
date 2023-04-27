class BannerModal {
  int status;
  String msg;
  List<String> banners;

  BannerModal({this.status, this.msg, this.banners});

  BannerModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    banners = json['Banners'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    data['Banners'] = this.banners;
    return data;
  }
}