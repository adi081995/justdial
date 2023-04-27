import 'dart:convert';
import 'dart:math';
import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nlytical/constant/global.dart';
import 'package:nlytical/constant/sizeconfig.dart';
import 'package:nlytical/screens/chat/fireChatList.dart';
import 'package:nlytical/screens/favourite_list.dart';
import 'package:nlytical/screens/detail.dart';
import 'package:nlytical/screens/fb_sign_in.dart';
import 'package:nlytical/screens/model/allrestaurent_model.dart';
import 'package:nlytical/screens/model/categories_model.dart';
import 'package:nlytical/screens/model/favourite_restaurent_modal.dart';
import 'package:nlytical/screens/ViewCategory.dart';
import 'package:line_icons/line_icons.dart';
import 'package:http/http.dart' as http;
import 'package:nlytical/screens/model/banner_modal.dart';
import 'package:nlytical/screens/model/like_modal.dart';
import 'package:nlytical/screens/model/popularStoreModal.dart' as p;
import 'package:nlytical/screens/model/profile_model.dart';
import 'package:nlytical/screens/model/unlike_modal.dart';
import 'package:nlytical/screens/mynotifications.dart';
import 'package:nlytical/screens/newTabbar.dart';
import 'package:nlytical/screens/profile.dart';
import 'package:nlytical/screens/searchStore.dart';
import 'package:nlytical/screens/welcome.dart';
import 'package:nlytical/share_preference/preferencesKey.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeNew extends StatefulWidget {
  @override
  _HomeNewState createState() => _HomeNewState();
}

class _HomeNewState extends State<HomeNew> with SingleTickerProviderStateMixin {
  String _currentAddress;
  Position _currentPosition;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  BannerModal bannerModal;
  CateModel cateModel;
  AllResModel allResModel;
  p.PopularStoreModal popularStoreModal;
  FancyDrawerController _controller;
  bool menu = false;

  @override
  void initState() {
    _controller = FancyDrawerController(
        vsync: this, duration: Duration(milliseconds: 250))
      ..addListener(() {
        setState(() {});
      });
    getUserDataFromPrefs();

    super.initState();
  }

  getUserDataFromPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userDataStr =
        preferences.getString(SharedPreferencesKey.LOGGED_IN_USERRDATA);
    Map<String, dynamic> userData = json.decode(userDataStr);
    print(userData);
    if (mounted)
      setState(() {
        userID = userData['user_id'];
      });
    _getUser();
    _getCurrentLocation();
    _getBanners();
    _getCategory();

    _getPopular();
    _getWishList();
  }

  Future _getUser() async {
    ProfileModel profileModel;
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
          userName = profileModel.user.username;
          userImg = profileModel.user.profilePic;
        }
      });
    }
  }

  _getCurrentLocation() {
    geolocator.getCurrentPosition().then((Position position) {
      if (mounted)
        setState(() {
          _currentPosition = position;
        });
      _getAddressFromLatLng();
      _getRes();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];
      _currentAddress =
          "${place.subLocality},${place.locality},${place.country}";
      if (mounted)
        setState(() {
          _currentAddress =
              "${place.subLocality},${place.locality},${place.country}";
        });
    } catch (e) {
      print(e);
    }
  }

  _getBanners() async {
    var uri = Uri.parse('${baseUrl()}/get_all_banners');
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
        bannerModal = BannerModal.fromJson(userData);
      });
    }
  }

  _getCategory() async {
    var uri = Uri.parse('${baseUrl()}/get_all_cat');
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
        cateModel = CateModel.fromJson(userData);
      });
    }
  }

  List numberofNearBy = [];

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
        if (allResModel != null && _currentPosition != null) {
          for (var i = 0; i < allResModel.restaurants.length; i++) {
            if (calculateDistance(
                    _currentPosition.latitude,
                    _currentPosition.longitude,
                    double.parse(allResModel.restaurants[i].lat),
                    double.parse(allResModel.restaurants[i].lon)) <=
                30) {
              numberofNearBy.add(allResModel.restaurants[i]);
            }
          }
        }
      });
    }
  }

  _getPopular() async {
    var uri = Uri.parse('${baseUrl()}/get_all_cat_nvip_sorting');
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
        popularStoreModal = p.PopularStoreModal.fromJson(userData);
      });
    }
  }

  _getWishList() async {
    FavouriteModal favouriteModal;
    var uri = Uri.parse('${baseUrl()}/get_liked_res');
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
        favouriteModal = FavouriteModal.fromJson(userData);
        if (favouriteModal != null) {
          if (favouriteModal.status == 1) {
            for (var i = 0; i < favouriteModal.restaurants.length; i++) {
              likeStore.add(favouriteModal.restaurants[i].resId.toString());
            }
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return FancyDrawerWrapper(
      backgroundColor: Colors.white,
      controller: _controller,
      drawerItems: <Widget>[
        Row(
          children: [
            userImg.length > 0
                ? Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(100.0),
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0),
                        border: Border.all(),
                        image: DecorationImage(
                          image: NetworkImage(userImg),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : Icon(
                    CupertinoIcons.person_crop_circle,
                    size: 70,
                    color: Colors.grey,
                  ),
          ],
        ),
        Text(
          "Hi " + userName,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: appColorBlack),
        ),
        Container(height: 30),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TabbarScreen()),
            );
          },
          child: Row(
            children: [
              Icon(
                CupertinoIcons.house_alt,
                color: Colors.black45,
              ),
              SizedBox(
                width: 10,
              ),
              Text("Home",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Profile(back: true)),
            );
          },
          child: Row(
            children: [
              Icon(
                CupertinoIcons.person,
                color: Colors.black45,
              ),
              SizedBox(
                width: 10,
              ),
              Text("Profile",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Notifications()),
            );
          },
          child: Row(
            children: [
              Icon(
                CupertinoIcons.bell,
                color: Colors.black45,
              ),
              SizedBox(
                width: 10,
              ),
              Text("Notification",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FireChatList()),
            );
          },
          child: Row(
            children: [
              Icon(
                CupertinoIcons.chat_bubble_text,
                color: Colors.black45,
              ),
              SizedBox(
                width: 10,
              ),
              Text("Messages",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        InkWell(
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
              Icon(
                CupertinoIcons.power,
                color: Colors.red,
              ),
              SizedBox(
                width: 10,
              ),
              Text("Logout",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Container(height: 100),
      ],
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Container(
          child: Scaffold(
            backgroundColor: appColorWhite,
            appBar: AppBar(
              backgroundColor: appColorGreen,
              elevation: 2,
              title: Text(
                'Home',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              centerTitle: false,
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Image.asset('assets/images/menuicon.png'),
                onPressed: () {
                  if (menu == false) {
                    setState(() {
                      menu = true;
                    });
                    _controller.toggle();
                  } else {
                    setState(() {
                      menu = false;
                    });
                    _controller.close();
                  }
                },
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: Container(
                    alignment: Alignment.centerRight,
                    width: 200,
                    child: _currentAddress != null
                        ? Text(
                            _currentAddress,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: appColorWhite,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                            maxLines: 2,
                          )
                        : Text(
                            "Please Wait..",
                            style:
                                TextStyle(color: appColorWhite, fontSize: 12),
                          ),
                  ),
                ),
                Container(width: 10),
              ],
            ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(height: 10),
                  _banner(context),
                  Container(height: 10),
                  categoryWidget(),
                  Container(height: 15),
                  _findStore(),
                  Container(height: 20),
                  _nearByStore(),
                  Container(height: 20),
                  Flexible(fit: FlexFit.loose, child: _popularStore(context)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _banner(BuildContext context) {
    Widget carousel = bannerModal == null
        ? Center(
            child: CupertinoActivityIndicator(),
          )
        : Stack(
            children: <Widget>[
              Carousel(
                images: bannerModal.banners.map((it) {
                  return ClipRRect(
                    // borderRadius: new BorderRadius.only(
                    //   bottomLeft: const Radius.circular(40.0),
                    //   bottomRight: const Radius.circular(40.0),
                    // ),
                    child: Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: CachedNetworkImage(
                        imageUrl: it,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            // borderRadius: new BorderRadius.only(
                            //   bottomLeft: const Radius.circular(40.0),
                            //   bottomRight: const Radius.circular(40.0),
                            // ),
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
                              child: CupertinoActivityIndicator()),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }).toList(),
                showIndicator: true,
                dotBgColor: Colors.transparent,
                borderRadius: true,
                autoplay: false,
                dotSize: 5.0,
                dotColor: Colors.black,
                dotSpacing: 15.0,
              ),
              // _customAppbar()
            ],
          );

    return SizedBox(
        height: 200,
        width: SizeConfig.screenWidth,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: carousel,
        ));
  }

  Widget categoryWidget() {
    return Container(
        height: 150,
        child: cateModel == null
            ? Center(
                child: CupertinoActivityIndicator(),
              )
            : cateModel.categories.length > 0
                ? ListView.builder(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: cateModel.categories.length,
                    itemBuilder: (context, int index) {
                      return widgetCatedata(cateModel.categories[index]);
                    },
                  )
                : Center(
                    child: Text(
                      "Don't have any categories now",
                      style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ));
  }

  Widget widgetCatedata(Categories categories) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => ViewCategory(
              id: categories.id,
              name: categories.cName,
            ),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            padding: const EdgeInsets.all(20.0),
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Center(
                child: new Image.network(
              categories.icon,
              width: 40,
            )),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              width: 100,
              child: Center(
                  child: Text(
                categories.cName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: appColorBlack,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              )))
        ],
      ),
    );
  }

  Widget _findStore() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Find Your Perfect Store',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchStore(
                            allResModel: allResModel,
                            currentPosition: _currentPosition)),
                  );
                },
                child: Text(
                  'SEE ALL',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: appColorGreen),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
            height: 200,
            width: SizeConfig.screenWidth,
            child: allResModel == null
                ? Center(
                    child: CupertinoActivityIndicator(),
                  )
                : allResModel.restaurants.length > 0
                    ? ListView.builder(
                        padding:
                            EdgeInsets.only(left: 0, right: 30, bottom: 10),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: allResModel.restaurants.length,
                        itemBuilder: (
                          context,
                          int index,
                        ) {
                          return widgetCard(allResModel.restaurants[index]);
                        },
                      )
                    : Center(
                        child: Text(
                          "Don't have any restaurants now",
                          style: TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      )),
      ],
    );
  }

  Widget widgetCard(Restaurants categories) {
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
      child: Center(
        child: Container(
          width: 250,
          margin: EdgeInsets.only(
            left: 15,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      child: CachedNetworkImage(
                        height: 140,
                        fit: BoxFit.cover,
                        imageUrl: categories.resImage.resImag0,
                        placeholder: (context, url) =>
                            CupertinoActivityIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 8),
                      child: Text(categories.resName,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                    SizedBox(height: 5),
                  ],
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 10, top: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 25,
                            decoration: BoxDecoration(
                              color: appColorGreen,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(80.0)),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    categories.cName,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(child: Container()),
                          Container(
                            height: 25,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(80.0)),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
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
                                        fontSize:
                                            SizeConfig.blockSizeHorizontal *
                                                2.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _nearByStore() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
           
          ),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Widget _nearYouBuildItem(Restaurants categories) {
    return calculateDistance(
                _currentPosition.latitude,
                _currentPosition.longitude,
                double.parse(categories.lat),
                double.parse(categories.lon)) <=
            30
        ? InkWell(
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
            child: Center(
              child: Container(
                width: 250,
                margin: EdgeInsets.only(
                  left: 15,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            child: CachedNetworkImage(
                              height: 140,
                              fit: BoxFit.cover,
                              imageUrl: categories.resImage.resImag0,
                              placeholder: (context, url) =>
                                  CupertinoActivityIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, top: 8),
                            child: Text(categories.resName,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10, top: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 25,
                                  decoration: BoxDecoration(
                                    color: appColorGreen,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(80.0)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          categories.cName,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(child: Container()),
                                Container(
                                  height: 25,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(80.0)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
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
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Container();
  }

  Widget _popularStore(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Popular Stores',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        popularStoreModal == null || _currentPosition == null
            ? Center(
                child: CupertinoActivityIndicator(),
              )
            : popularStoreModal.restaurants.length > 0
                ? ListView.builder(
                    padding: EdgeInsets.only(bottom: 10, top: 0),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: popularStoreModal.restaurants.length,
                    itemBuilder: (context, int index) {
                      return sortingCard(
                          context, popularStoreModal.restaurants[index]);
                    },
                  )
                : Center(
                    child: Text(
                      "Don't have any restaurants now",
                      style: TextStyle(
                        color: appColorBlack,
                      ),
                    ),
                  )
      ],
    );
  }

  Widget sortingCard(BuildContext context, p.Restaurants categories) {
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
                                      ? IconButton(
                                          onPressed: () {
                                            unLikeServiceFunction(
                                                categories.resId, userID);
                                          },
                                          icon: Icon(
                                            LineIcons.heart,
                                            color: Colors.red,
                                          ))
                                      : IconButton(
                                          onPressed: () {
                                            likeServiceFunction(
                                                categories.resId, userID);
                                          },
                                          icon: Icon(LineIcons.heart_o))
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
      if (mounted)
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
      if (mounted)
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

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
