import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nlytical/constant/global.dart';
import 'package:nlytical/constant/sizeconfig.dart';
import 'package:nlytical/screens/model/mynotifications_model.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notifications> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController controller = new TextEditingController();

  bool isLoading = false;
  @override
  void initState() {
    _getProducts();
    super.initState();
  }

  NotificationModel notificationModel;

  _getProducts() async {
    setState(() {
      isLoading = true;
    });

    var uri = Uri.parse('${baseUrl()}/user_notification_listing');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);

    request.fields['user_id'] = userID;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    notificationModel = NotificationModel.fromJson(userData);

    //  for(var i=0; i<=allProductsModel.restaurants.length; i++){
    if (notificationModel != null) {}
    if (mounted)
      setState(() {
        isLoading = false;
      });

    // }

    print("+++++++++");
    print(responseData);
    print("+++++++++");
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: appColorGreen,
            elevation: 2,
            title: Text(
              'Notifications',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            centerTitle: false,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
          body: isLoading == false
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(height: 20),
                      notificationModel != null
                          ? notificationModel.responseCode == '1'
                              ? ListView.separated(
                                  padding: EdgeInsets.only(bottom: 10),
                                  itemCount: notificationModel.data.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, int index) {
                                    return notificationWidget(
                                        notificationModel.data[index]);
                                  },
                                  separatorBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Divider(),
                                    );
                                  },
                                )
                              : ConstrainedBox(
                                  constraints: BoxConstraints(
                                      minHeight:
                                          MediaQuery.of(context).size.height),
                                  child: Center(
                                    child: Text(
                                      'No notificatios',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ))
                          : Container()
                    ],
                  ),
                )
              : Center(child: CircularProgressIndicator())),
    );
  }

  Widget notificationWidget(Data data) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 10, top: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ClipOval(
            child: Material(
              color: appColorGreen, // Button color
              child: InkWell(
                splashColor: Colors.red, // Splash color
                onTap: () {},
                child: Container(
                  height: 35,
                  width: 35,
                  child: SizedBox(
                      child: Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 20,
                  )),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          // Container(
          //   height: 50,
          //   width: 50,
          //   decoration: BoxDecoration(
          //     border: Border.all(
          //       width: 0.5,
          //     ),
          //     shape: BoxShape.circle,
          //     color: Colors.red,
          //   ),
          //   child: Material(
          //     child: data.re != null
          //         ? CachedNetworkImage(
          //             placeholder: (context, url) => Container(
          //               child: CupertinoActivityIndicator(),
          //               width: 35.0,
          //               height: 35.0,
          //               padding: EdgeInsets.all(10.0),
          //             ),
          //             errorWidget: (context, url, error) => Material(
          //               child: Padding(
          //                 padding: const EdgeInsets.all(0.0),
          //                 child: Icon(
          //                   Icons.person,
          //                   size: 30,
          //                   color: Colors.grey,
          //                 ),
          //               ),
          //               borderRadius: BorderRadius.all(
          //                 Radius.circular(8.0),
          //               ),
          //               clipBehavior: Clip.hardEdge,
          //             ),
          //             imageUrl: image,
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
          //       Radius.circular(100.0),
          //     ),
          //     clipBehavior: Clip.hardEdge,
          //   ),
          // ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 0),
              child: SizedBox(
                //  width: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: new TextSpan(
                        style: new TextStyle(
                          fontSize: 14.0,
                          //color: Colors.black,
                        ),
                        children: <TextSpan>[
                          new TextSpan(
                            text: data.title,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                                fontFamily: "Poppins-Medium"),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: new TextSpan(
                        style: new TextStyle(
                          fontSize: 12.0,
                          //color: Colors.black,
                        ),
                        children: <TextSpan>[
                          new TextSpan(
                            text: data.message,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Poppins-Medium"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
