import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nlytical/constant/global.dart';
import 'package:nlytical/constant/sizeconfig.dart';
import 'package:nlytical/screens/model/categories_model.dart';
import 'package:nlytical/screens/ViewCategory.dart';
import 'package:http/http.dart' as http;

class CategoriesNew extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<CategoriesNew> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  CateModel cateModel;

  @override
  void initState() {
    _getCategory();

    super.initState();
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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Container(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: appColorGreen,
            elevation: 2,
            title: Text(
              'Categories',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            centerTitle: false,
            automaticallyImplyLeading: false,
          ),
          body: cateModel == null
              ? Center(
                  child: CupertinoActivityIndicator(),
                )
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      cateModel.categories.length > 0
                          ? Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: cateModel.categories.length,
                                itemBuilder: (context, int index) {
                                  return widgetCatedata(
                                      cateModel.categories[index]);
                                },
                              ),
                            )
                          : Center(
                              child: Text(
                                "Don't have any restaurants now",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            )
                    ],
                  ),
                ),
        ),
      ),
    );
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
      child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, bottom: 20),
        child: new Card(
          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  child: Container(
                    height: 170.0,
                    width: MediaQuery.of(context).size.width,
                    child: FittedBox(
                      child: CachedNetworkImage(
                        imageUrl: categories.img,
                        placeholder: (context, url) => Center(
                            child: Padding(
                          padding: const EdgeInsets.all(100),
                          child: Container(
                              height: 20,
                              width: 20,
                              child: CupertinoActivityIndicator()),
                        )),
                        errorWidget: (context, url, error) => Container(
                          height: 150,
                          width: 150,
                          child: Icon(
                            Icons.error,
                          ),
                        ),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(270, 270, 270, 0.50),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      categories.cName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
