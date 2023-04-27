class NotificationModel {
  String responseCode;
  String message;
  String status;
  List<Data> data;

  NotificationModel({this.responseCode, this.message, this.status, this.data});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
       // ignore: deprecated_member_use
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String notId;
  String vId;
  String dealId;
  String title;
  String message;
  String date;

  Data(
      {this.notId, this.vId, this.dealId, this.title, this.message, this.date});

  Data.fromJson(Map<String, dynamic> json) {
    notId = json['not_id'];
    vId = json['v_id'];
    dealId = json['deal_id'];
    title = json['title'];
    message = json['message'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['not_id'] = this.notId;
    data['v_id'] = this.vId;
    data['deal_id'] = this.dealId;
    data['title'] = this.title;
    data['message'] = this.message;
    data['date'] = this.date;
    return data;
  }
}
