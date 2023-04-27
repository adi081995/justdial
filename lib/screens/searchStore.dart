import 'dart:convert';
import 'dart:math';
import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:line_icons/line_icons.dart';
import 'package:nlytical/constant/global.dart';
import 'package:nlytical/constant/sizeconfig.dart';
import 'package:nlytical/screens/favourite_list.dart';
import 'package:nlytical/screens/detail.dart';
import 'package:nlytical/screens/model/allrestaurent_model.dart';
import 'package:nlytical/screens/model/like_modal.dart';
import 'package:nlytical/screens/model/unlike_modal.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class SearchStore extends StatefulWidget {
  AllResModel allResModel;
   Position currentPosition;
  SearchStore({this.allResModel,this.currentPosition});
  @override
  _DiscoverNewState createState() => _DiscoverNewState();
}

class _DiscoverNewState extends State<SearchStore> {
 
  
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    super.initState();

   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appColorWhite,
        appBar: AppBar(
          backgroundColor: appColorGreen,
          elevation: 2,
          title: _textfield(context),
          centerTitle: false,
          automaticallyImplyLeading: false,
          leading: null,
          actions: [
            Container(
              width: 60,
              child: IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Text(
                    "Cancel",
                    style: TextStyle(
                        color: appColorWhite, fontWeight: FontWeight.bold),
                  )),
            ),
            Container(width: 10),
          ],
        ),
        body: widget.allResModel == null 
            ? Center(
                child: CupertinoActivityIndicator(),
              )
            : SingleChildScrollView(
                physics: BouncingScrollPhysics(), child: exploreWidget()));
  }

  Widget _textfield(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 5, right: 0, left: 0, bottom: 5),
        child: Container(
          decoration: new BoxDecoration(
              color: appColorWhite,
              borderRadius: new BorderRadius.all(
                Radius.circular(30.0),
              )),
          height: 40,
          child: Center(
            child: TextField(
              controller: controller,
              onChanged: onSearchTextChanged,
              style: TextStyle(color: appColorBlack),
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.grey[200]),
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(30.0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.grey[200]),
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(30.0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.grey[200]),
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(30.0),
                  ),
                ),
                filled: true,
                hintStyle: new TextStyle(color: Colors.grey[600], fontSize: 14),
                hintText: "Search",
                contentPadding: EdgeInsets.only(top: 10.0),
                fillColor: Colors.grey[200],
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[600],
                  size: 25.0,
                ),
              ),
            ),
          ),
        ));
  }

  Widget exploreWidget() {
    return widget.allResModel.restaurants.length > 0
        ? _searchResult.length != 0 ||
                controller.text.trim().toLowerCase().isNotEmpty
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: 20),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _searchResult.length,
                itemBuilder: (context, int index) {
                  return sortingCard(context, _searchResult[index]);
                },
              )
            : ListView.builder(
                padding: EdgeInsets.only(bottom: 20),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.allResModel.restaurants.length,
                itemBuilder: (context, int index) {
                  return sortingCard(
                      context, widget.allResModel.restaurants[index]);
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
                                                      widget.currentPosition.latitude,
                                                      widget.currentPosition
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

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    widget.allResModel.restaurants.forEach((userDetail) {
      if (userDetail.resName != null) if (userDetail.resName
          .toLowerCase()
          .contains(text.toLowerCase())) _searchResult.add(userDetail);
    });

    setState(() {});
  }
}

List _searchResult = [];
