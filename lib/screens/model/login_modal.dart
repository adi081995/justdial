class LoginModel {
  String responseCode;
  String message;
  String status;
  String userId;
  String userToken;

  LoginModel(
      {this.responseCode,
      this.message,
      this.status,
      this.userId,
      this.userToken});

  LoginModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    status = json['status'];
    userId = json['user_id'];
    userToken = json['user_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['message'] = this.message;
    data['status'] = this.status;
    data['user_id'] = this.userId;
    data['user_token'] = this.userToken;
    return data;
  }
}