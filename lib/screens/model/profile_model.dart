class ProfileModel {
  String responseCode;
  String message;
  User user;
  List<Review> review;
  String status;

  ProfileModel(
      {this.responseCode, this.message, this.user, this.review, this.status});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['review'] != null) {
       // ignore: deprecated_member_use
      review = new List<Review>();
      json['review'].forEach((v) {
        review.add(new Review.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['message'] = this.message;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.review != null) {
      data['review'] = this.review.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class User {
  String username;
  String email;
  String isGold;
  String profilePic;
  String profileCreated;
  String deviceToken;

  User(
      {this.username,
      this.email,
      this.isGold,
      this.profilePic,
      this.profileCreated,
      this.deviceToken});

  User.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    isGold = json['isGold'];
    profilePic = json['profile_pic'];
    profileCreated = json['profile_created'];
    deviceToken = json['device_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['isGold'] = this.isGold;
    data['profile_pic'] = this.profilePic;
    data['profile_created'] = this.profileCreated;
    data['device_token'] = this.deviceToken;
    return data;
  }
}

class Review {
  String revId;
  String revUser;
  String revRes;
  String revStars;
  String revText;
  String revDate;
  String revResId;
  String revUsername;
  String revResImage;

  Review(
      {this.revId,
      this.revUser,
      this.revRes,
      this.revStars,
      this.revText,
      this.revDate,
      this.revResId,
      this.revUsername,
      this.revResImage});

  Review.fromJson(Map<String, dynamic> json) {
    revId = json['rev_id'];
    revUser = json['rev_user'];
    revRes = json['rev_res'];
    revStars = json['rev_stars'];
    revText = json['rev_text'];
    revDate = json['rev_date'];
    revResId = json['rev_res_id'];
    revUsername = json['rev_username'];
    revResImage = json['rev_res_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rev_id'] = this.revId;
    data['rev_user'] = this.revUser;
    data['rev_res'] = this.revRes;
    data['rev_stars'] = this.revStars;
    data['rev_text'] = this.revText;
    data['rev_date'] = this.revDate;
    data['rev_res_id'] = this.revResId;
    data['rev_username'] = this.revUsername;
    data['rev_res_image'] = this.revResImage;
    return data;
  }
}
