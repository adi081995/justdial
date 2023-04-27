import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:nlytical/constant/global.dart';
import 'package:nlytical/constant/sizeconfig.dart';
import 'package:nlytical/screens/favourite_list.dart';
import 'package:nlytical/images/images.dart';
import 'package:nlytical/screens/detail.dart';
import 'package:nlytical/screens/model/allrestaurent_model.dart';
import 'package:nlytical/screens/filter/filterOption.dart';
import 'package:nlytical/screens/model/like_modal.dart';
import 'package:nlytical/screens/model/unlike_modal.dart';
import 'package:nlytical/screens/searchStore.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;

class Explore extends StatefulWidget {
  @override
  _DiscoverNewState createState() => _DiscoverNewState();
}

class _DiscoverNewState extends State<Explore> {
  String _mapStyle;

  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _markers = {};
  Position _currentPosition;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  bool explorScreen = true;
  bool mapScreen = false;

  AllResModel allResModel;
  AutoScrollController listScrollController;
  final scrollDirection = Axis.horizontal;
  int gotoindex;

  _scrollToIndex(index) async {
    await listScrollController.scrollToIndex(index,
        preferPosition: AutoScrollPosition.begin);
  }

  @override
  void initState() {
    super.initState();
    listScrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);
    _getCurrentLocation();

    rootBundle.loadString('assets/mapStyle/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  _getCurrentLocation() {
    geolocator.getCurrentPosition().then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _getRes();
    }).catchError((e) {
      print(e);
    });
  }

  _getRes() async {
    var uri = Uri.parse('${baseUrl()}/get_all_res');
    var request = new http.MultipartRequest("GET", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    // request.fields['vendor_id'] = userID;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);

    if (mounted) {
      setState(() {
        allResModel = AllResModel.fromJson(userData);
        if (allResModel != null) {
          for (int i = 0; i < allResModel.restaurants.length; i++) {
            nar(allResModel.restaurants[i], i);
          }
        }
      });
    }
  }

  void nar(Restaurants data, int index) async {
    if (data.lat != "" && data.lon != "") {
      var markerIdVal = generateIds();
      final MarkerId markerId = MarkerId(markerIdVal.toString());
      final Uint8List markerIcon = await getBytesFromAsset(Images.mappin, 90);
      final Marker marker = Marker(
        icon: BitmapDescriptor.fromBytes(markerIcon),
        markerId: markerId,
        position: LatLng(
          double.parse(data.lat),
          double.parse(data.lon),
        ),
        infoWindow: InfoWindow(
          title: data.resName,
        ),
        onTap: () {
          print(data.resId);
          // _scrollToIndex(index);
          for (int i = 0; i < allResModel.restaurants.length; i++) {
            if (allResModel.restaurants[i].resId == data.resId) {
              gotoindex = i;
              _scrollToIndex(gotoindex);
            }
          }
        },
      );

      setState(() {
        _markers.add(marker);
      });
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  int generateIds() {
    var rng = new Random();
    var randomInt;
    randomInt = rng.nextInt(100);
    return randomInt;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColorWhite,
      body: allResModel == null || _currentPosition == null
          ? Center(
              child: CupertinoActivityIndicator(),
            )
          : Column(
              children: <Widget>[
                header(),
                explorScreen == true
                    ? Expanded(
                        child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: exploreWidget()))
                    : mapScreen == true
                        ? Expanded(
                            child: Stack(
                              children: <Widget>[
                                GoogleMap(
                                  markers: _markers,
                                  mapType: MapType.normal,
                                  myLocationButtonEnabled: true,
                                  myLocationEnabled: true,
                                  mapToolbarEnabled: false,
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                      _currentPosition.latitude,
                                      _currentPosition.longitude,
                                    ),
                                    zoom: 10,
                                  ),
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    controller.setMapStyle(_mapStyle);
                                    _controller.complete(controller);
                                  },
                                ),
                                _allresContainer()
                              ],
                            ),
                          )
                        : Container()
              ],
            ),
    );
  }

  Widget header() {
    return Container(
      height: SizeConfig.blockSizeVertical * 15,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Color(0xFF1E3C72), Color(0xFF2A5298)]),
      ),
      child: Center(
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        height: SizeConfig.blockSizeVertical * 5,
                        child: mapScreen == false
                            // ignore: deprecated_member_use
                            ? RaisedButton(
                                onPressed: () {
                                  setState(() {
                                    explorScreen = false;
                                    mapScreen = true;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(40),
                                      bottomLeft: Radius.circular(40)),
                                ),
                                padding: const EdgeInsets.all(0.0),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: <Color>[
                                          Color(0xFF1E3C72),
                                          Color(0xFF2A5298),
                                        ]),
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(40),
                                        bottomLeft: Radius.circular(40)),
                                  ),
                                  child: Container(
                                    constraints: const BoxConstraints(
                                        minWidth: 88.0,
                                        minHeight:
                                            36.0), // min sizes for Material buttons
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      'assets/images/location1.png',
                                      color: Colors.white,
                                      width: SizeConfig.blockSizeHorizontal * 5,
                                    ),
                                  ),
                                ),
                              )
                            // ignore: deprecated_member_use
                            : RaisedButton(
                                onPressed: () {
                                  setState(() {
                                    explorScreen = false;
                                    mapScreen = true;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(40),
                                      bottomLeft: Radius.circular(40)),
                                ),
                                padding: const EdgeInsets.all(0.0),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(40),
                                        bottomLeft: Radius.circular(40)),
                                  ),
                                  child: Container(
                                    constraints: const BoxConstraints(
                                        minWidth: 88.0,
                                        minHeight:
                                            36.0), // min sizes for Material buttons
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      'assets/images/location1.png',
                                      width: SizeConfig.blockSizeHorizontal * 5,
                                    ),
                                  ),
                                ),
                              )),
                    Container(
                        height: SizeConfig.blockSizeVertical * 5,

                        // width: SizeConfig.blockSizeHorizontal * 25,
                        child: explorScreen == false
                            // ignore: deprecated_member_use
                            ? RaisedButton(
                                onPressed: () {
                                  setState(() {
                                    explorScreen = true;
                                    mapScreen = false;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(40),
                                        bottomRight: Radius.circular(40))),
                                padding: const EdgeInsets.all(0.0),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: <Color>[
                                          Color(0xFF1E3C72),
                                          Color(0xFF2A5298),
                                        ]),
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(40),
                                        bottomRight: Radius.circular(40)),
                                  ),
                                  child: Container(
                                    constraints: const BoxConstraints(
                                        minWidth: 88.0,
                                        minHeight:
                                            36.0), // min sizes for Material buttons
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      'assets/images/list.png',
                                      color: Colors.white,
                                      width: SizeConfig.blockSizeHorizontal * 5,
                                    ),
                                  ),
                                ),
                              )
                            // ignore: deprecated_member_use
                            : RaisedButton(
                                onPressed: () {
                                  setState(() {
                                    explorScreen = true;
                                    mapScreen = false;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(40),
                                      bottomRight: Radius.circular(40)),
                                ),
                                padding: const EdgeInsets.all(0.0),
                                child: Ink(
                                  decoration: BoxDecoration(
                                      //  border: Border.all(color: Colors.white),
                                      // gradient: LinearGradient(
                                      //     begin: Alignment.topLeft,
                                      //     end: Alignment.bottomRight,
                                      //     colors: <Color>[
                                      //       Color(0xFF1E3C72),
                                      //       Color(0xFF2A5298),
                                      //     ]),

                                      ),
                                  child: Container(
                                    constraints: const BoxConstraints(
                                        minWidth: 88.0,
                                        minHeight:
                                            36.0), // min sizes for Material buttons
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      'assets/images/list.png',
                                      color: Colors.blue[900],
                                      width: SizeConfig.blockSizeHorizontal * 5,
                                    ),
                                  ),
                                ),
                              )),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Padding(
                  padding: const EdgeInsets.only(right: 20, top: 20),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SelectFilter()),
                      );
                    },
                    child: Image.asset(
                      'assets/images/filter.png',
                      width: SizeConfig.blockSizeHorizontal * 6,
                    ),
                  )),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchStore(
                                  allResModel: allResModel,
                                  currentPosition: _currentPosition)),
                        );
                      },
                      child: Icon(
                        CupertinoIcons.search_circle_fill,
                        size: 35,
                        color: appColorWhite,
                      ))),
            )
          ],
        ),
      ),
    );
  }

  Widget _allresContainer() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Container(
          height: 170,
          width: SizeConfig.screenWidth,
          child: allResModel.restaurants.length > 0
              ? ListView.builder(
                  padding: EdgeInsets.only(left: 0, right: 30),
                  controller: listScrollController,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: allResModel.restaurants.length,
                  itemBuilder: (context, int index) {
                    return AutoScrollTag(
                        key: ValueKey(index),
                        controller: listScrollController,
                        index: index,
                        child: widgetCard1(allResModel.restaurants[index]));
                  },
                )
              : Center(
                  child: Text(
                    "Don't have any store",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )),
    );
  }

  Widget widgetCard1(Restaurants categories) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => DetailScreen(
              resId: categories.resId,
            ),
          ),
        );
      },
      child: Container(
        width: 200,
        margin: EdgeInsets.only(left: 25, right: 0, top: 0, bottom: 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).focusColor.withOpacity(0.1),
                blurRadius: 15,
                offset: Offset(0, 5)),
          ],
        ),
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Image of the card

                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: CachedNetworkImage(
                    height: 100,
                    fit: BoxFit.cover,
                    imageUrl: categories.resImage.resImag0,
                    placeholder: (context, url) => CupertinoActivityIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(categories.resName,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 3)),
                            // Text(
                            //   'asdasdsaaaaaaa',
                            //   overflow: TextOverflow.fade,
                            //   softWrap: false,
                            //   style: Theme.of(context).textTheme.caption,
                            // ),
                            SizedBox(height: 5),
                            Text(categories.resAddress,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 2.5,
                                    color: Colors.grey)),
                            // Row(
                            //   children: Helper.getStarsList(double.parse(restaurant.rate)),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, top: 10),
                  child: Container(
                    width: 50,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(7)),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            color: Color(0xFF1E3C72),
                            size: 10,
                          ),
                          SizedBox(width: 5),
                          Text(
                            categories.resRatings,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.blockSizeHorizontal * 2.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget exploreWidget() {
    return allResModel.restaurants.length > 0
        ? ListView.builder(
            padding: EdgeInsets.only(bottom: 20),
            controller: listScrollController,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: allResModel.restaurants.length,
            itemBuilder: (context, int index) {
              return AutoScrollTag(
                key: ValueKey(index),
                controller: listScrollController,
                index: index,
                child: sortingCard(context, allResModel.restaurants[index]),
              );
            },
          )
        : Center(
            child: Text(
              "Don't have any restaurants now",
              style: TextStyle(
                color: appColorBlack,
              ),
            ),
          );
  }

  Widget sortingCard(BuildContext context, Restaurants categories) {
    return Container(
      height: 350,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 20),
            child: Stack(
              children: <Widget>[
                Material(
                  elevation: 5.0,
                  shadowColor: Colors.white,
                  borderRadius: BorderRadius.circular(14.0),
                  child: Container(
                    height: 500,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 0.0,
                        bottom: 00.0,
                        left: 0.0,
                        right: 0.0,
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: 200,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              child: CachedNetworkImage(
                                imageUrl: categories.resImage.resImag0,
                                placeholder: (context, url) => Center(
                                  child: Container(
                                    margin: EdgeInsets.all(70.0),
                                    child: CupertinoActivityIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  height: 5,
                                  width: 5,
                                  child: Icon(
                                    Icons.error,
                                  ),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, top: 10, right: 10),
                                child: Text(
                                  categories.resName,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  softWrap: true,
                                ),
                              )),
                          Container(height: 5),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Text(
                                        categories.resAddress,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                        maxLines: 1,
                                        softWrap: true,
                                      ),
                                    )),
                              ),
                              Container(width: 10),
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Container(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                        padding: const EdgeInsets.only(top: 0),
                                        child: Text(
                                          calculateDistance(
                                                      _currentPosition.latitude,
                                                      _currentPosition
                                                          .longitude,
                                                      double.parse(
                                                          categories.lat),
                                                      double.parse(
                                                          categories.lon))
                                                  .toStringAsFixed(0) +
                                              " km",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey),
                                          overflow: TextOverflow.ellipsis,
                                        ))),
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.grey.withOpacity(0.6),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Container(
                                  width: SizeConfig.blockSizeHorizontal * 30,
                                  // ignore: deprecated_member_use
                                  child: RaisedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) => DetailScreen(
                                            resId: categories.resId,
                                          ),
                                        ),
                                      );
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(80.0)),
                                    padding: const EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: <Color>[
                                            Color(0xFF1E3C72),
                                            Color(0xFF2A5298),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(80.0)),
                                      ),
                                      child: Container(
                                        constraints: const BoxConstraints(
                                            minWidth: 88.0,
                                            minHeight:
                                                36.0), // min sizes for Material buttons
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'View info',
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(7)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.star,
                                            color: Color(0xFF1E3C72),
                                            size: 10,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            categories.resRatings,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: SizeConfig
                                                        .blockSizeHorizontal *
                                                    2.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  likeStore.contains(categories.resId)
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: InkWell(
                                              onTap: () {
                                                unLikeServiceFunction(
                                                    categories.resId, userID);
                                              },
                                              child: Icon(LineIcons.heart)),
                                        )
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: InkWell(
                                              onTap: () {
                                                likeServiceFunction(
                                                    categories.resId, userID);
                                              },
                                              child: Icon(LineIcons.heart_o)),
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Chip(
                      backgroundColor: Color(0xFF1E3C72),
                      label: Text(
                        categories.cName,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.blockSizeHorizontal * 3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
