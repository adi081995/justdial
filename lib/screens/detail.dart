import 'dart:convert';
import 'dart:math';
import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:linkable/linkable.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:nlytical/constant/global.dart';
import 'package:nlytical/constant/sizeconfig.dart';
import 'package:nlytical/screens/chat/fireChat.dart';
import 'package:nlytical/screens/favourite_list.dart';
import 'package:nlytical/screens/model/detail_modal.dart';
import 'package:nlytical/screens/model/like_modal.dart';
import 'package:nlytical/screens/model/unlike_modal.dart';
import 'package:nlytical/screens/model/vendorData_modal.dart';
import 'package:nlytical/screens/ratingscreen.dart';
import 'package:nlytical/screens/viewImages.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class DetailScreen extends StatefulWidget {
  String resId;

  DetailScreen({
    this.resId,
  });
  @override
  _OrderSuccessWidgetState createState() => _OrderSuccessWidgetState();
}

class _OrderSuccessWidgetState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController;
  bool fixedScroll;
  bool isLoading = false;

  Position _currentPosition;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  VendorDataModal vendorDataModal;
  String vid = '';

  @override
  void initState() {
    _getCurrentLocation();
    _getProductDetails();
    _scrollController = ScrollController();

    super.initState();
  }

  _getCurrentLocation() {
    geolocator.getCurrentPosition().then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  DetailsModal restaurants;

  refresh() {
    _getProductDetails();
  }

  _getProductDetails() async {
    print(widget.resId);
    var uri = Uri.parse('${baseUrl()}/get_res_details');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields['res_id'] = widget.resId;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);

    if (mounted) {
      setState(() {
        restaurants = DetailsModal.fromJson(userData);
      });
    }
    if (restaurants != null) {
      vid = restaurants.restaurant.vid;
      _getVendor(restaurants.restaurant.vid);
    }

    print(responseData);
  }

  Future _getVendor(String vid) async {
    var uri = Uri.parse('${baseUrl()}/vendor_data');
    var request = new http.MultipartRequest("Post", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields.addAll({'vid': vid});

    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    if (mounted) {
      setState(() {
        vendorDataModal = VendorDataModal.fromJson(userData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColorWhite,
      body: Stack(
        children: [
          restaurants == null || _currentPosition == null
              ? Center(child: CupertinoActivityIndicator())
              : _projectInfo(),
        ],
      ),
    );
  }

  Widget _projectInfo() {
    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (context, value) {
        return [
          SliverAppBar(
            shape: ContinuousRectangleBorder(
                // borderRadius: BorderRadius.only(
                //     bottomLeft: Radius.circular(70),
                //     bottomRight: Radius.circular(70))
                ),
            backgroundColor: appColorGreen,
            expandedHeight: 400,
            elevation: 0,
            floating: true,
            pinned: true,
            automaticallyImplyLeading: false,
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: _poster2(context),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(12),
              child: RawMaterialButton(
                shape: CircleBorder(),
                padding: const EdgeInsets.all(0),
                fillColor: Colors.white54,
                splashColor: Colors.grey[400],
                child: Icon(
                  Icons.arrow_back,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            actions: [
              Container(
                width: 40,
                child: likeStore.contains(restaurants.restaurant.resId)
                    ? Padding(
                        padding: const EdgeInsets.all(4),
                        child: RawMaterialButton(
                          shape: CircleBorder(),
                          padding: const EdgeInsets.all(0),
                          fillColor: Colors.white54,
                          splashColor: Colors.grey[400],
                          child: Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 20,
                          ),
                          onPressed: () {
                            unLikeServiceFunction(
                                restaurants.restaurant.resId, userID);
                          },
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(4),
                        child: RawMaterialButton(
                          shape: CircleBorder(),
                          padding: const EdgeInsets.all(0),
                          fillColor: Colors.white54,
                          splashColor: Colors.grey[400],
                          child: Icon(
                            Icons.favorite_border,
                            size: 20,
                          ),
                          onPressed: () {
                            likeServiceFunction(
                                restaurants.restaurant.resId, userID);
                          },
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: RawMaterialButton(
                  shape: CircleBorder(),
                  padding: const EdgeInsets.all(0),
                  fillColor: Colors.white54,
                  splashColor: Colors.grey[400],
                  child: Icon(
                    Icons.fullscreen,
                    size: 20,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewImages(
                                images: restaurants.restaurant.allImage,
                                number: 0,
                              )),
                    );
                  },
                ),
              ),
            ],
          ),
        ];
      },
      body: DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    width: SizeConfig.screenWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _details(),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TabBar(
                            labelColor: Colors.black,
                            indicatorSize: TabBarIndicatorSize.label,
                            isScrollable: true,
                            labelStyle: TextStyle(
                                fontSize: 15.0, fontFamily: 'Montserrat'),
                            indicator: UnderlineTabIndicator(
                              borderSide: BorderSide(
                                  color: Color(0xFF1E3C72), width: 3.0),
                              // insets:
                              //     EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 40.0),
                            ),
                            tabs: <Widget>[
                              Tab(
                                text: 'About',
                              ),
                              Tab(
                                text: 'Reviews',
                              ),
                              Tab(
                                text: 'Opening Hours',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            restaurants.restaurant.resDesc,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: reviewWidget(restaurants.review),
                      ),
                      restaurants.restaurant.mfo != null &&
                              restaurants.restaurant.mfo.length > 0
                          ? Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                restaurants.restaurant.mfo.toString(),
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            )
                          : _openingHours(),
                    ],
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: appColorGreen,
                      ),
                      child: IconButton(
                        icon: Icon(
                          CupertinoIcons.text_badge_star,
                          color: appColorWhite,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => RateRiview(
                                  restaurants: restaurants.restaurant,
                                  review: restaurants.review,
                                  refresh: refresh),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: appColorGreen,
                      ),
                      child: IconButton(
                        icon: Icon(
                          CupertinoIcons.text_bubble_fill,
                          color: appColorWhite,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => FireChat(
                                      currentuser: userID,
                                      currentusername: userName,
                                      currentuserimage: userImg,
                                      peerID: vid,
                                      peerUrl:
                                          vendorDataModal.user.profileImage,
                                      peerName: vendorDataModal.user.uname)));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _openingHours() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: RichText(
          text: TextSpan(
            text: '',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 15,
                fontFamily: 'Montserrat'),
            children: <TextSpan>[
              restaurants.restaurant.mondayFrom != ""
                  ? TextSpan(
                      text:
                          'Monday : ${restaurants.restaurant.mondayFrom} : ${restaurants.restaurant.mondayTo}')
                  : TextSpan(text: 'Monday : '),
              restaurants.restaurant.tuesdayFrom != ""
                  ? TextSpan(
                      text:
                          '\nTuesday : ${restaurants.restaurant.tuesdayFrom} : ${restaurants.restaurant.tuesdayTo}')
                  : TextSpan(text: '\nTuesday : '),
              restaurants.restaurant.wednesdayFrom != ""
                  ? TextSpan(
                      text:
                          '\nWednesday: ${restaurants.restaurant.wednesdayFrom} : ${restaurants.restaurant.wednesdayTo}')
                  : TextSpan(text: '\nWednesday : '),
              restaurants.restaurant.thursdayFrom != ""
                  ? TextSpan(
                      text:
                          '\nThursday: ${restaurants.restaurant.thursdayFrom} : ${restaurants.restaurant.thursdayTo}')
                  : TextSpan(text: '\nThursday : '),
              restaurants.restaurant.fridayFrom != ""
                  ? TextSpan(
                      text:
                          '\nFriday: ${restaurants.restaurant.fridayFrom} : ${restaurants.restaurant.fridayTo}')
                  : TextSpan(text: '\nFriday : '),
              restaurants.restaurant.saturdayFrom != ""
                  ? TextSpan(
                      text:
                          '\nSaturday: ${restaurants.restaurant.saturdayFrom} : ${restaurants.restaurant.saturdayTo}')
                  : TextSpan(text: '\nSaturday : '),
              restaurants.restaurant.sundayFrom != ""
                  ? TextSpan(
                      text:
                          '\nSunday: ${restaurants.restaurant.sundayFrom} : ${restaurants.restaurant.sundayTo}')
                  : TextSpan(text: '\nSunday : '),
            ],
          ),
        ),
      ),
    );
  }

  Widget _poster2(BuildContext context) {
    Widget carousel = restaurants.restaurant.allImage == null
        ? Center(
            child: SpinKitCubeGrid(
              color: Colors.white,
            ),
          )
        : Stack(
            children: <Widget>[
              Carousel(
                images: restaurants.restaurant.allImage.map((it) {
                  return ClipRRect(
                    // borderRadius: BorderRadius.only(
                    //     bottomLeft: Radius.circular(30),
                    //     bottomRight: Radius.circular(30)),
                    child: CachedNetworkImage(
                      imageUrl: it,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Center(
                        child: Container(
                          height: 100,
                          width: 100,
                          // margin: EdgeInsets.all(70.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                appColorGreen),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  );
                }).toList(),
                showIndicator: true,
                dotBgColor: Colors.transparent,
                borderRadius: false,
                autoplay: false,
                dotSize: 5.0,
                dotSpacing: 15.0,
              ),
            ],
          );

    return SizedBox(width: SizeConfig.screenWidth, child: carousel);
  }

  Widget _details() {
    return Container(
      width: SizeConfig.screenWidth,
      child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(height: 15),
            Text(
              restaurants.restaurant.resName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Container(height: 6),
            Text(
              restaurants.restaurant.cName,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.grey),
            ),
            Container(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                RatingBar.builder(
                  initialRating: restaurants.restaurant.resRatings != ''
                      ? double.parse(restaurants.restaurant.resRatings)
                      : 0.0,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 18,
                  ignoreGestures: true,
                  unratedColor: Colors.grey,
                  itemBuilder: (context, _) =>
                      Icon(Icons.star, color: Color(0xFF1E3C72)),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child: Text(
                    restaurants.restaurant.resRatings.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                        color: appColorBlack, fontWeight: FontWeight.bold),
                  ),
                ),
                // Text("(45)")
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Divider(),
            ),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Color(0xFF1E3C72),
                ),
                Container(
                  width: 10,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      MapsLauncher.launchCoordinates(
                          double.parse(restaurants.restaurant.lat ?? 0),
                          double.parse(restaurants.restaurant.lon ?? 0),
                          'Location');
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurants.restaurant.resAddress,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: appColorBlack,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        Text(
                          'About ' +
                              calculateDistance(
                                      _currentPosition.latitude,
                                      _currentPosition.longitude,
                                      double.parse(
                                          restaurants.restaurant.lat ?? 0),
                                      double.parse(
                                          restaurants.restaurant.lon ?? 0))
                                  .toStringAsFixed(0) +
                              ' km for you',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: appColorBlack,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Divider(),
            ),
            InkWell(
              onTap: () => launch('tel:${restaurants.restaurant.resPhone}'),
              child: Row(
                children: [
                  Icon(
                    Icons.phone,
                    color: Color(0xFF1E3C72),
                  ),
                  Container(width: 10),
                  Text(
                    restaurants.restaurant.resPhone,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: appColorBlack,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Divider(),
            ),
            Row(
              children: [
                Icon(
                  Icons.public,
                  color: Color(0xFF1E3C72),
                ),
                Container(width: 10),
                Linkable(
                  text: restaurants.restaurant.resWebsite,
                  softWrap: true,
                  linkColor: appColorBlack,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'Montserrat'),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Divider(),
            ),
          ],
        ),
      ),
    );
  }

  Widget reviewWidget(List<Review> model) {
    return model.length > 0
        ? ListView.builder(
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            itemCount: model.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return model[index].revUserData == null
                  ? Container()
                  : InkWell(
                      onTap: () {},
                      child: Center(
                        child: Container(
                          child: SizedBox(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Card(
                                        elevation: 4.0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0)),
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(50.0)),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                            child: CachedNetworkImage(
                                              imageUrl: model[index]
                                                  .revUserData
                                                  .profilePic,
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              placeholder: (context, url) =>
                                                  Center(
                                                child: Container(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2.0,
                                                    valueColor:
                                                        new AlwaysStoppedAnimation<
                                                                Color>(
                                                            appColorGreen),
                                                  ),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) => Icon(
                                                Icons.person,
                                                color: Colors.black45,
                                                size: 25,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(width: 10.0),
                                      Flexible(
                                        fit: FlexFit.loose,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(height: 10.0),
                                            Text(
                                              model[index].revUserData.username,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Container(height: 5),
                                            RatingBar.builder(
                                              initialRating: double.parse(
                                                  model[index].revStars),
                                              minRating: 0,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 15,
                                              ignoreGestures: true,
                                              unratedColor: Colors.grey,
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: appColorGreen,
                                              ),
                                              onRatingUpdate: (rating) {
                                                print(rating);
                                              },
                                            ),
                                            Container(height: 5),
                                            Text(
                                              model[index].revText,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              maxLines: 3,
                                              overflow: TextOverflow.clip,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Container(
                                      height: 0.8,
                                      color: Colors.grey[600],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ));
            })
        : Text("No reviews found.");
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  likeServiceFunction(String resId, String userID) async {
    LikeModal likeModal;

    var uri = Uri.parse('${baseUrl()}/likeRes');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields.addAll({
      'res_id': resId,
      'user_id': userID,
    });

    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);

    likeModal = LikeModal.fromJson(userData);

    if (likeModal.responseCode == "1") {
      setState(() {
        likeStore.add(resId);
      });
      Flushbar(
        backgroundColor: appColorWhite,
        messageText: Text(
          likeModal.message,
          style: TextStyle(
            fontSize: SizeConfig.blockSizeHorizontal * 4,
            color: appColorBlack,
          ),
        ),

        duration: Duration(seconds: 3),
        // ignore: deprecated_member_use
        mainButton: FlatButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FavouriteRest(back:true),
              ),
            );
          },
          child: Text(
            "Go to wish list",
            style: TextStyle(color: appColorBlack),
          ),
        ),
        icon: Icon(
          Icons.favorite,
          color: appColorBlack,
          size: 25,
        ),
      )..show(context);
    } else {
      Flushbar(
        title: "Fail",
        message: likeModal.message,
        duration: Duration(seconds: 3),
        icon: Icon(
          Icons.error,
          color: Colors.red,
        ),
      )..show(context);
    }
  }

  unLikeServiceFunction(String resId, String userID) async {
    UnlikeModel unlikeModel;

    var uri = Uri.parse('${baseUrl()}/unlike');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields.addAll({
      'res_id': resId,
      'user_id': userID,
    });

    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);

    unlikeModel = UnlikeModel.fromJson(userData);

    if (unlikeModel.status == 1) {
      setState(() {
        likeStore.remove(resId);
      });
      Flushbar(
        backgroundColor: appColorWhite,
        messageText: Text(
          unlikeModel.msg,
          style: TextStyle(
            fontSize: SizeConfig.blockSizeHorizontal * 4,
            color: appColorBlack,
          ),
        ),

        duration: Duration(seconds: 3),
        // ignore: deprecated_member_use
        mainButton: Container(),
        icon: Icon(
          Icons.favorite_border,
          color: appColorBlack,
          size: 25,
        ),
      )..show(context);
    } else {
      Flushbar(
        title: "Fail",
        message: unlikeModel.msg,
        duration: Duration(seconds: 3),
        icon: Icon(
          Icons.error,
          color: Colors.red,
        ),
      )..show(context);
    }
  }
}
