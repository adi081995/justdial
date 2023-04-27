import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nlytical/constant/global.dart';
import 'package:nlytical/screens/model/vendorData_modal.dart';
import 'package:photo_view/photo_view.dart';

class FireChat extends StatefulWidget {
  final String peerID;
  final String peerUrl;
  final String peerName;
  // final String peerToken;

  final String currentusername;
  final String currentuserimage;
  final String currentuser;

  FireChat({
    @required this.peerID,
    this.peerUrl,
    @required this.peerName,
    this.currentusername,
    this.currentuserimage,
    this.currentuser,
    //this.peerToken
  });

  @override
  _ChatState createState() => _ChatState(
        peerID: peerID,
        peerUrl: peerUrl,
        peerName: peerName,
        //peerToken: peerToken
      );
}

class _ChatState extends State<FireChat> {
  final String peerID;
  final String peerUrl;
  final String peerName;

  String groupChatId;
  var listMessage;
  File imageFile;
  bool isLoading;
  String imageUrl;
  int limit = 20;

  String peerCode;
  _ChatState({
    @required this.peerID,
    this.peerUrl,
    @required this.peerName,
  });

  final TextEditingController textEditingController = TextEditingController();
  ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  TextEditingController reviewCode = TextEditingController();
  TextEditingController reviewText = TextEditingController();
  final picker = ImagePicker();

  String vendorToken = "";

  @override
  void initState() {
    _getVendor();

    super.initState();

    groupChatId = '';
    isLoading = false;

    imageUrl = '';

    readLocal();
    removeBadge();
    setState(() {});
  }

  Future _getVendor() async {
    VendorDataModal vendorDataModal;
    var uri = Uri.parse('${baseUrl()}/vendor_data');
    var request = new http.MultipartRequest("Post", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields.addAll({'vid': widget.peerID});

    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    if (mounted) {
      setState(() {
        vendorDataModal = VendorDataModal.fromJson(userData);
        if (vendorDataModal != null) {
          vendorToken = vendorDataModal.user.deviceToken;
        }
      });
    }
  }

  removeBadge() async {
    await FirebaseFirestore.instance
        .collection("chatList")
        .doc(userID)
        .collection(userID)
        .doc(peerID)
        .get()
        .then((doc) async {
      if (doc.exists) {
        await FirebaseFirestore.instance
            .collection("chatList")
            .doc(userID)
            .collection(userID)
            .doc(peerID)
            .update({'badge': '0'});
      }
    });
  }

  void _scrollListener() {
    if (listScrollController.position.pixels ==
        listScrollController.position.maxScrollExtent) {
      startLoader();
    }
  }

  void startLoader() {
    setState(() {
      isLoading = true;
      fetchData();
    });
  }

  fetchData() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, onResponse);
  }

  void onResponse() {
    setState(() {
      isLoading = false;
      limit = limit + 20;
    });
  }

  readLocal() {
    if (widget.currentuser.hashCode <= peerID.hashCode) {
      groupChatId = '${widget.currentuser}-$peerID';
    } else {
      groupChatId = '$peerID-${widget.currentuser}';
    }
  }

  @override
  Widget build(BuildContext context) {
    listScrollController = new ScrollController()..addListener(_scrollListener);
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          title: Text(
            widget.peerName,
            style: TextStyle(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: <Widget>[],
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40)),
                ),
                child: Column(
                  children: <Widget>[
                    buildListMessage(),

                    // Input content
                    buildInput(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: isLoading
                  ? Container(
                      padding: EdgeInsets.all(5),
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.grey[200])))
                  : Container(),
            ),
          ],
        ));
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId == ''
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(appColorGreen)))
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .doc(groupChatId)
                  .collection(groupChatId)
                  .orderBy('timestamp', descending: true)
                  .limit(limit)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(appColorGreen)));
                } else {
                  listMessage = snapshot.data.docs;
                  return Padding(
                    padding: const EdgeInsets.only(left: 0, right: 0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1.0, 1.0), //(x,y)
                            blurRadius: 1.0,
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.all(10.0),
                        itemBuilder: (context, index) =>
                            buildItem(index, snapshot.data.docs[index]),
                        itemCount: snapshot.data.docs.length,
                        reverse: true,
                        controller: listScrollController,
                      ),
                    ),
                  );
                }
              },
            ),
    );
  }

  // Future getImage() async {
  //   imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

  //   if (imageFile != null) {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     uploadFile();
  //   }
  // }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        setState(() {
          isLoading = true;
        });

        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  // Future uploadFile() async {
  //   String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //   Reference reference =
  //       FirebaseStorage.instance.ref().child("ChatMedia").child(fileName);

  //   UploadTask uploadTask = reference.putFile(imageFile);
  //   UploadTask storageTaskSnapshot = await uploadTask.onComplete;
  //   storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
  //     imageUrl = downloadUrl;
  //     setState(() {
  //       isLoading = false;
  //       onSendMessage(imageUrl, 1);
  //     });
  //   }, onError: (err) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     // Fluttertoast.showToast(msg: 'This file is not an image');
  //   });
  // }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference =
        FirebaseStorage.instance.ref().child("ChatMedia").child(fileName);

    UploadTask uploadTask = reference.putFile(imageFile);
    TaskSnapshot storageTaskSnapshot = await uploadTask;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      // Fluttertoast.showToast(msg: 'This file is not an image');
    });
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document['idFrom'] == widget.currentuser) {
      // Right (my message)
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              document['type'] == 0
                  // Text
                  ? Container(
                      child: Text(
                        document['content'],
                        style: TextStyle(
                            color: appColorWhite,
                            fontWeight: FontWeight.normal,
                            fontSize: 13),
                      ),
                      padding: EdgeInsets.fromLTRB(20.0, 13.0, 10.0, 13.0),
                      width: 200.0,
                      decoration: BoxDecoration(
                          color: appColorGreen,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      margin: EdgeInsets.only(
                          bottom: isLastMessageRight(index) ? 10.0 : 10.0,
                          right: 10.0),
                    )
                  : Container(
                     // ignore: deprecated_member_use
                      child: FlatButton(
                        child: Material(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    appColorGreen),
                              ),
                              width: 200.0,
                              height: 200.0,
                              padding: EdgeInsets.all(70.0),
                              decoration: BoxDecoration(
                                color: Color(0xffE8E8E8),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Material(
                              child: Text("Not Avilable"),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                            imageUrl: document['content'],
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        onPressed: () {
                          imagePreview(
                            document['content'],
                          );
                        },
                        padding: EdgeInsets.all(0),
                      ),
                      margin: EdgeInsets.only(
                          bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                          right: 10.0),
                    ),
            ],
            mainAxisAlignment: MainAxisAlignment.end,
          ),
          isLastMessageRight(index)
              ? Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    DateFormat('dd MMM kk:mm').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            int.parse(document['timestamp']))),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontStyle: FontStyle.normal),
                  ),
                  margin: EdgeInsets.only(right: 10.0),
                )
              : Container()
        ],
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                //isLastMessageLeft(index)
                // ? Material(
                //     child: peerUrl != null
                //         ? CachedNetworkImage(
                //             placeholder: (context, url) => Container(
                //               child: CircularProgressIndicator(
                //                 strokeWidth: 1.0,
                //                 valueColor: AlwaysStoppedAnimation<Color>(
                //                     appColorGreen),
                //               ),
                //               width: 35.0,
                //               height: 35.0,
                //               padding: EdgeInsets.all(10.0),
                //             ),
                //             imageUrl: peerUrl,
                //             width: 35.0,
                //             height: 35.0,
                //             fit: BoxFit.cover,
                //           )
                //         : Padding(
                //             padding: const EdgeInsets.all(10.0),
                //             child: Icon(
                //               Icons.person,
                //               size: 25,
                //             ),
                //           ),
                //     borderRadius: BorderRadius.all(
                //       Radius.circular(18.0),
                //     ),
                //     clipBehavior: Clip.hardEdge,
                //   )
                // : Container(width: 35.0),
                document['type'] == 0
                    ? Container(
                        child: Text(
                          document['content'],
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 13),
                        ),
                        padding: EdgeInsets.fromLTRB(20.0, 13.0, 10.0, 13.0),
                        width: 200.0,
                        decoration: BoxDecoration(
                            color: Colors.grey[400],
                            // border: Border.all(color: Color(0xffE8E8E8)),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        margin: EdgeInsets.only(left: 10.0),
                      )
                    : Container(
                       // ignore: deprecated_member_use
                        child: FlatButton(
                          child: Material(
                            child: CachedNetworkImage(
                              placeholder: (context, url) => Container(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      appColorGreen),
                                ),
                                width: 200.0,
                                height: 200.0,
                                padding: EdgeInsets.all(70.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Material(
                                child: Text("Not Avilable"),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                                clipBehavior: Clip.hardEdge,
                              ),
                              imageUrl: document['content'],
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            clipBehavior: Clip.hardEdge,
                          ),
                          onPressed: () {
                            imagePreview(document['content']);
                          },
                          padding: EdgeInsets.all(0),
                        ),
                        margin: EdgeInsets.only(left: 10.0),
                      ),
              ],
            ),

            // Time
            isLastMessageLeft(index)
                ? Container(
                    child: Text(
                      DateFormat('dd MMM kk:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(document['timestamp']))),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.0,
                          fontStyle: FontStyle.normal),
                    ),
                    margin: EdgeInsets.only(left: 15.0, top: 5.0, bottom: 5.0),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] == widget.currentuser) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] != widget.currentuser) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> onSendMessage(String content, int type) async {
    // type: 0 = text, 1 = image, 2 = sticker
    int badgeCount = 0;
    print(content);
    print(content.trim());
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'idFrom': widget.currentuser,
            'idTo': peerID,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      }).then((onValue) async {
        await FirebaseFirestore.instance
            .collection("chatList")
            .doc(widget.currentuser)
            .collection(widget.currentuser)
            .doc(peerID)
            .set({
          'id': peerID,
          'name': peerName,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'content': content,
          'badge': '0',
          'profileImage': peerUrl,
        }).then((onValue) async {
          try {
            await FirebaseFirestore.instance
                .collection("chatList")
                .doc(peerID)
                .collection(peerID)
                .doc(widget.currentuser)
                .get()
                .then((doc) async {
              debugPrint(doc["badge"]);
              if (doc["badge"] != null) {
                badgeCount = int.parse(doc["badge"]);
                await FirebaseFirestore.instance
                    .collection("chatList")
                    .doc(peerID)
                    .collection(peerID)
                    .doc(widget.currentuser)
                    .set({
                  'id': widget.currentuser,
                  'name': "${widget.currentusername}",
                  'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
                  'content': content,
                  'badge': '${badgeCount + 1}',
                  'profileImage': widget.currentuserimage,
                });
              }
            });
          } catch (e) {
            await FirebaseFirestore.instance
                .collection("chatList")
                .doc(peerID)
                .collection(peerID)
                .doc(widget.currentuser)
                .set({
              'id': widget.currentuser,
              'name': "${widget.currentusername}",
              'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
              'content': content,
              'badge': '${badgeCount + 1}',
              'profileImage': widget.currentuserimage,
            });
            print(e);
          }
        });
      });

      sendNotification(vendorToken, content);

      //NOTIFICATION HERE>>>>>>>>>>>>>>>>>>

      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      print('Nothing to send');
      // Fluttertoast.showToast(
      //     msg: 'Nothing to send', backgroundColor: Colors.red);
    }
  }

  Future<http.Response> sendNotification(
      String peerToken, String content) async {
    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: "key=$serverKey"
      },
      body: jsonEncode({
        "to": peerToken,
        "priority": "high",
        "data": {
          "type": "100",
          "user_id": userID,
          "title": content,
          "message": userName,
          "time": DateTime.now().millisecondsSinceEpoch,
          "sound": "default",
          "vibrate": "300",
        },
        "notification": {
          "vibrate": "300",
          "priority": "high",
          "body": content,
          "title": userName,
          "sound": "default",
        }
      }),
    );
    return response;
  }

  Widget buildInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: Container(
        margin: safeQueries(context) ? EdgeInsets.only(bottom: 25) : null,
        child: Row(
          children: <Widget>[
            // Button send image
            Material(
              child: new Container(
                margin: new EdgeInsets.symmetric(horizontal: 1.0),
                child: new IconButton(
                  icon: Icon(
                    Icons.camera_alt,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    getImage();
                  },
                  // color: primaryColor,
                ),
              ),
              color: Colors.white,
            ),

            // Edit text
            Flexible(
              child: Container(
                child: TextField(
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                  controller: textEditingController,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Type your message...',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  // focusNode: focusNode,
                ),
              ),
            ),

            // Button send message
            Material(
              child: new Container(
                margin: new EdgeInsets.symmetric(horizontal: 8.0),
                child: new IconButton(
                  icon: new Icon(
                    Icons.send,
                    color: Colors.grey[700],
                  ),
                  onPressed: () {
                    onSendMessage(textEditingController.text, 0);
                  },
                  // color: primaryColor,
                ),
              ),
              color: Colors.white,
            ),
          ],
        ),
        width: double.infinity,
        height: 50.0,
        decoration: new BoxDecoration(
            border:
                new Border(top: new BorderSide(color: Colors.grey, width: 0.7)),
            color: Colors.white),
      ),
    );
  }

  imagePreview(String url) {
    return showDialog(
      context: context,
      builder: (_) => Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                top: 100, left: 10, right: 10, bottom: 100),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                child: PhotoView(
                  imageProvider: NetworkImage(url),
                ),
              ),
            ),
          ),
          //buildFilterCloseButton(context),
        ],
      ),
    );
  }

  Widget buildFilterCloseButton(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        color: Colors.black.withOpacity(0.0),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}

dynamic safeQueries(BuildContext context) {
  return (MediaQuery.of(context).size.height >= 812.0 ||
      MediaQuery.of(context).size.height == 812.0 ||
      (MediaQuery.of(context).size.height >= 812.0 &&
          MediaQuery.of(context).size.height <= 896.0 &&
          Platform.isIOS));
}
