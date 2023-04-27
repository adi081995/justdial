class VendorDataModal {
  String responseCode;
  String message;
  User user;
  String status;

  VendorDataModal({this.responseCode, this.message, this.user, this.status});

  VendorDataModal.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['message'] = this.message;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class User {
  String uname;
  String email;
  String gender;
  String dateOfBirth;
  String profileImage;
  String deviceToken;

  User(
      {this.uname,
      this.email,
      this.gender,
      this.dateOfBirth,
      this.profileImage,
      this.deviceToken});

  User.fromJson(Map<String, dynamic> json) {
    uname = json['uname'];
    email = json['email'];
    gender = json['gender'];
    dateOfBirth = json['date_of_birth'];
    profileImage = json['profile_image'];
    deviceToken = json['device_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uname'] = this.uname;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['date_of_birth'] = this.dateOfBirth;
    data['profile_image'] = this.profileImage;
    data['device_token'] = this.deviceToken;
    return data;
  }
}