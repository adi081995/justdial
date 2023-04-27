class DetailsModal {
  int status;
  String msg;
  Restaurant restaurant;
  List<Review> review;

  DetailsModal({this.status, this.msg, this.restaurant, this.review});

  DetailsModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    restaurant = json['restaurant'] != null
        ? new Restaurant.fromJson(json['restaurant'])
        : null;
    if (json['review'] != null) {
       // ignore: deprecated_member_use
      review = new List<Review>();
      json['review'].forEach((v) {
        review.add(new Review.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.restaurant != null) {
      data['restaurant'] = this.restaurant.toJson();
    }
    if (this.review != null) {
      data['review'] = this.review.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Restaurant {
  String resId;
  String catId;
  String vid;
  String resName;
  String resNameU;
  String resDesc;
  String resDescU;
  String resWebsite;
  ResImage resImage;
  String logo;
  String resPhone;
  String resAddress;
  String resIsOpen;
  String resStatus;
  String resRatings;
  String status;
  String resVideo;
  String resUrl;
  String mfo;
  String mondayFrom;
  String mondayTo;
  String tuesdayFrom;
  String tuesdayTo;
  String wednesdayFrom;
  String wednesdayTo;
  String thursdayFrom;
  String thursdayTo;
  String fridayFrom;
  String fridayTo;
  String saturdayFrom;
  String saturdayTo;
  String sundayFrom;
  String sundayTo;
  String lat;
  String lon;
  String resCreateDate;
  List<String> allImage;
  String cName;

  Restaurant(
      {this.resId,
      this.catId,
      this.vid,
      this.resName,
      this.resNameU,
      this.resDesc,
      this.resDescU,
      this.resWebsite,
      this.resImage,
      this.logo,
      this.resPhone,
      this.resAddress,
      this.resIsOpen,
      this.resStatus,
      this.resRatings,
      this.status,
      this.resVideo,
      this.resUrl,
      this.mfo,
      this.mondayFrom,
      this.mondayTo,
      this.tuesdayFrom,
      this.tuesdayTo,
      this.wednesdayFrom,
      this.wednesdayTo,
      this.thursdayFrom,
      this.thursdayTo,
      this.fridayFrom,
      this.fridayTo,
      this.saturdayFrom,
      this.saturdayTo,
      this.sundayFrom,
      this.sundayTo,
      this.lat,
      this.lon,
      this.resCreateDate,
      this.allImage,
      this.cName});

  Restaurant.fromJson(Map<String, dynamic> json) {
    resId = json['res_id'];
    catId = json['cat_id'];
    vid = json['vid'];
    resName = json['res_name'];
    resNameU = json['res_name_u'];
    resDesc = json['res_desc'];
    resDescU = json['res_desc_u'];
    resWebsite = json['res_website'];
    resImage = json['res_image'] != null
        ? new ResImage.fromJson(json['res_image'])
        : null;
    logo = json['logo'];
    resPhone = json['res_phone'];
    resAddress = json['res_address'];
    resIsOpen = json['res_isOpen'];
    resStatus = json['res_status'];
    resRatings = json['res_ratings'];
    status = json['status'];
    resVideo = json['res_video'];
    resUrl = json['res_url'];
    mfo = json['mfo'];
    mondayFrom = json['monday_from'];
    mondayTo = json['monday_to'];
    tuesdayFrom = json['tuesday_from'];
    tuesdayTo = json['tuesday_to'];
    wednesdayFrom = json['wednesday_from'];
    wednesdayTo = json['wednesday_to'];
    thursdayFrom = json['thursday_from'];
    thursdayTo = json['thursday_to'];
    fridayFrom = json['friday_from'];
    fridayTo = json['friday_to'];
    saturdayFrom = json['saturday_from'];
    saturdayTo = json['saturday_to'];
    sundayFrom = json['sunday_from'];
    sundayTo = json['sunday_to'];
    lat = json['lat'];
    lon = json['lon'];
    resCreateDate = json['res_create_date'];
    allImage = json['all_image'].cast<String>();
    cName = json['c_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['res_id'] = this.resId;
    data['cat_id'] = this.catId;
    data['vid'] = this.vid;
    data['res_name'] = this.resName;
    data['res_name_u'] = this.resNameU;
    data['res_desc'] = this.resDesc;
    data['res_desc_u'] = this.resDescU;
    data['res_website'] = this.resWebsite;
    if (this.resImage != null) {
      data['res_image'] = this.resImage.toJson();
    }
    data['logo'] = this.logo;
    data['res_phone'] = this.resPhone;
    data['res_address'] = this.resAddress;
    data['res_isOpen'] = this.resIsOpen;
    data['res_status'] = this.resStatus;
    data['res_ratings'] = this.resRatings;
    data['status'] = this.status;
    data['res_video'] = this.resVideo;
    data['res_url'] = this.resUrl;
    data['mfo'] = this.mfo;
    data['monday_from'] = this.mondayFrom;
    data['monday_to'] = this.mondayTo;
    data['tuesday_from'] = this.tuesdayFrom;
    data['tuesday_to'] = this.tuesdayTo;
    data['wednesday_from'] = this.wednesdayFrom;
    data['wednesday_to'] = this.wednesdayTo;
    data['thursday_from'] = this.thursdayFrom;
    data['thursday_to'] = this.thursdayTo;
    data['friday_from'] = this.fridayFrom;
    data['friday_to'] = this.fridayTo;
    data['saturday_from'] = this.saturdayFrom;
    data['saturday_to'] = this.saturdayTo;
    data['sunday_from'] = this.sundayFrom;
    data['sunday_to'] = this.sundayTo;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['res_create_date'] = this.resCreateDate;
    data['all_image'] = this.allImage;
    data['c_name'] = this.cName;
    return data;
  }
}

class ResImage {
  String resImag0;
  String resImag1;
  String resImag2;

  ResImage({this.resImag0, this.resImag1, this.resImag2});

  ResImage.fromJson(Map<String, dynamic> json) {
    resImag0 = json['res_imag0'];
    resImag1 = json['res_imag1'];
    resImag2 = json['res_imag2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['res_imag0'] = this.resImag0;
    data['res_imag1'] = this.resImag1;
    data['res_imag2'] = this.resImag2;
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
  RevUserData revUserData;

  Review(
      {this.revId,
      this.revUser,
      this.revRes,
      this.revStars,
      this.revText,
      this.revDate,
      this.revUserData});

  Review.fromJson(Map<String, dynamic> json) {
    revId = json['rev_id'];
    revUser = json['rev_user'];
    revRes = json['rev_res'];
    revStars = json['rev_stars'];
    revText = json['rev_text'];
    revDate = json['rev_date'];
    revUserData = json['rev_user_data'] != null
        ? new RevUserData.fromJson(json['rev_user_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rev_id'] = this.revId;
    data['rev_user'] = this.revUser;
    data['rev_res'] = this.revRes;
    data['rev_stars'] = this.revStars;
    data['rev_text'] = this.revText;
    data['rev_date'] = this.revDate;
    if (this.revUserData != null) {
      data['rev_user_data'] = this.revUserData.toJson();
    }
    return data;
  }
}

class RevUserData {
  String id;
  String username;
  String email;
  String password;
  String facebookId;
  String loginType;
  String profilePic;
  String isGold;
  String deviceToken;
  String date;

  RevUserData(
      {this.id,
      this.username,
      this.email,
      this.password,
      this.facebookId,
      this.loginType,
      this.profilePic,
      this.isGold,
      this.deviceToken,
      this.date});

  RevUserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    password = json['password'];
    facebookId = json['facebook_id'];
    loginType = json['login_type'];
    profilePic = json['profile_pic'];
    isGold = json['isGold'];
    deviceToken = json['device_token'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['password'] = this.password;
    data['facebook_id'] = this.facebookId;
    data['login_type'] = this.loginType;
    data['profile_pic'] = this.profilePic;
    data['isGold'] = this.isGold;
    data['device_token'] = this.deviceToken;
    data['date'] = this.date;
    return data;
  }
}