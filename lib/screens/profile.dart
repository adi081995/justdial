import 'dart:convert';
import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nlytical/constant/global.dart';
import 'package:nlytical/constant/sizeconfig.dart';
import 'package:nlytical/screens/fb_sign_in.dart';
import 'package:nlytical/screens/model/editProfile_modal.dart';
import 'package:nlytical/screens/model/profile_model.dart';
import 'package:nlytical/screens/my_reviews.dart';
import 'package:nlytical/screens/welcome.dart';
import 'package:nlytical/share_preference/preferencesKey.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
// ignore: must_be_immutable
class Profile extends StatefulWidget {
  bool back;
  Profile({this.back});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController _email = TextEditingController();
  TextEditingController _username = TextEditingController();
  bool isLoading = false;

  File selectedImage;
  ProfileModel profileModel;

  @override
  void initState() {
    _getUser();

    super.initState();
  }

  Future _getUser() async {
    var uri = Uri.parse('${baseUrl()}/user_data');
    var request = new http.MultipartRequest("Post", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields.addAll({'user_id': userID});

    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    if (mounted) {
      setState(() {
        likeStore.clear();
        profileModel = ProfileModel.fromJson(userData);
        if (profileModel != null) {
          _email.text = profileModel.user.email;
          _username.text = profileModel.user.username;
          isLoading = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appColorWhite,
        appBar: AppBar(
          backgroundColor: appColorGreen,
          elevation: 2,
          title: Text(
            'Profile',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: false,
          automaticallyImplyLeading: false,
          leading: widget.back == true
              ? IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              : null,
          actions: [
            Container(
              width: 80,
              child: IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    _updateUser();
                  },
                  icon: Text(
                    "Done",
                    style: TextStyle(
                        color: appColorWhite, fontWeight: FontWeight.bold),
                  )),
            )
          ],
        ),
        body: Stack(
          children: [_userInfo(), isLoading == true ? load() : Container()],
        ));
  }

  Widget _userInfo() {
    return profileModel == null
        ? Center(
            child: CupertinoActivityIndicator(),
          )
        : Stack(
            children: <Widget>[
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 11,
                    ),
                    profilePic(profileModel.user),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 2,
                    ),
                    profileModel.user.username != null
                        ? Text(
                            profileModel.user.username,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.blockSizeHorizontal * 5),
                          )
                        : Text(
                            'Loading..',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.blockSizeHorizontal * 5),
                          ),
                    Container(height: 20),
                    divider(),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            child: Text(
                              "Name",
                              style: TextStyle(
                                  color: appColorBlack,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: TextField(
                                controller: _username,
                                decoration: InputDecoration(
                                  hintText: "Enter Name",
                                  hintStyle: TextStyle(
                                      color: Colors.grey[500], fontSize: 14),
                                  alignLabelWithHint: true,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black45, width: 0.5),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black45, width: 0.5),
                                  ),
                                ),
                                // scrollPadding: EdgeInsets.all(20.0),
                                // keyboardType: TextInputType.multiline,
                                // maxLines: 99999,
                                style: TextStyle(
                                    color: appColorBlack, fontSize: 15),
                                autofocus: false,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            child: Text(
                              "Email",
                              style: TextStyle(
                                  color: appColorBlack,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: TextField(
                                controller: _email,
                                decoration: InputDecoration(
                                  hintText: "Enter Email",
                                  hintStyle: TextStyle(
                                      color: Colors.grey[500], fontSize: 14),
                                  alignLabelWithHint: true,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black45, width: 0.5),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black45, width: 0.5),
                                  ),
                                ),
                                // scrollPadding: EdgeInsets.all(20.0),
                                // keyboardType: TextInputType.multiline,
                                // maxLines: 99999,
                                style: TextStyle(
                                    color: appColorBlack, fontSize: 15),
                                autofocus: false,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(height: 50),
                    divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 15),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyReviews(
                                    allRestaurent: profileModel.review)),
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              'My Reviews',
                              style: TextStyle(
                                  color: appColorBlack,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Expanded(child: Container()),
                            Icon(Icons.arrow_forward_ios, size: 20),
                            Container(width: 10),
                          ],
                        ),
                      ),
                    ),
                    Container(height: 10),
                    divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 15),
                      child: InkWell(
                        onTap: () {
                          signOutGoogle();
                          signOutFacebook();
                          preferences
                              .remove(SharedPreferencesKey.LOGGED_IN_USERRDATA)
                              .then((_) {
                            likeStore = [];
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => WelcomeScreen(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              'Logout',
                              style: TextStyle(
                                  color: appColorBlack,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Expanded(child: Container()),
                            Icon(Icons.arrow_forward_ios, size: 20),
                            Container(width: 10),
                          ],
                        ),
                      ),
                    ),
                    Container(height: 10),
                    divider(),
                  ],
                ),
              ),
            ],
          );
  }

  Widget headerText() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Text(
          'Profile',
          style: TextStyle(
              color: Colors.white,
              fontSize: SizeConfig.blockSizeHorizontal * 5),
        ),
      ),
    );
  }

  Widget profilePic(User user) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        userImg(user),
        editIconForPhoto(),
      ],
    );
  }

  Widget userImg(User user) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        height: 150,
        width: 150,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: selectedImage == null
              ? user.profilePic != null
                  ? CachedNetworkImage(
                      imageUrl: user.profilePic,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          new CircularProgressIndicator(),
                      errorWidget: (context, url, error) => new Icon(
                            CupertinoIcons.person_fill,
                            size: 100,
                            color: Colors.black45,
                          ))
                  : Icon(Icons.person, size: 100)
              : Image.file(selectedImage, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget editIconForPhoto() {
    return Container(
      height: 35,
      width: 35,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      padding: EdgeInsets.all(0),
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: appColorGreen),
        child: IconButton(
          icon: Icon(
            Icons.edit,
            size: 18,
            color: appColorWhite,
          ),
          onPressed: () {
            openImageFromCamOrGallary(context);
          },
        ),
      ),
    );
  }

  void containerForSheet<T>({BuildContext context, Widget child}) {
    showCupertinoModalPopup<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T value) {});
  }

  openImageFromCamOrGallary(BuildContext context) {
    containerForSheet<String>(
      context: context,
      child: CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(
              "Camera",
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            onPressed: () {
              getImageFromCamera();
              Navigator.of(context, rootNavigator: true).pop("Discard");
            },
          ),
          CupertinoActionSheetAction(
            child: Text(
              "Photo & Video Library",
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            onPressed: () {
              getImageFromGallery();
              Navigator.of(context, rootNavigator: true).pop("Discard");
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          isDefaultAction: true,
          onPressed: () {
            // Navigator.pop(context, 'Cancel');
            Navigator.of(context, rootNavigator: true).pop("Discard");
          },
        ),
      ),
    );
  }

  Future<void> getImageFromCamera() async {
    PickedFile file;
    file = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50);

    if (file != null) {
      setState(() {
        selectedImage = File(file.path);
      });
      // sendImage(file);
    }
  }

  Future<void> getImageFromGallery() async {
    PickedFile file;
    file = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);

    if (file != null) {
      setState(() {
        selectedImage = File(file.path);
      });
    }
  }

  Widget divider() {
    return Container(
      height: 0.5,
      color: Colors.grey[400],
    );
  }

  _updateUser() async {
    closeKeyboard();
    EditProfileModal editProfileModal;
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (regex.hasMatch(_email.text.trim())) {
      setState(() {
        isLoading = true;
      });

      var uri = Uri.parse('${baseUrl()}/user_edit');
      var request = new http.MultipartRequest("POST", uri);
      Map<String, String> headers = {
        "Accept": "application/json",
      };
      request.headers.addAll(headers);
      request.fields['username'] = _username.text;
      request.fields['id'] = userID;
      request.fields['email'] = _email.text.trim();

      if (selectedImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'profile_pic', selectedImage.path));
      }
      var response = await request.send();
      print(response.statusCode);
      String responseData =
          await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responseData);
      editProfileModal = EditProfileModal.fromJson(userData);

      if (editProfileModal.responseCode == "1") {
        _getUser().then((value) {
          setState(() {
            isLoading = false;
          });
        });

        Flushbar(
          title: "Update Successfully",
          message: editProfileModal.message,
          duration: Duration(seconds: 3),
          icon: Icon(
            Icons.done,
            color: Colors.green,
            size: 35,
          ),
        )..show(context);
      } else {
        setState(() {
          isLoading = false;
        });
        Flushbar(
          title: "Error",
          message: editProfileModal.message,
          duration: Duration(seconds: 3),
          icon: Icon(
            Icons.error,
            color: Colors.red,
          ),
        )..show(context);
      }
    } else {
      Flushbar(
        title: "Invalid Email",
        message: "Please enter valid email",
        duration: Duration(seconds: 3),
        icon: Icon(
          Icons.error,
          color: Colors.red,
        ),
      )..show(context);
    }
  }
}
