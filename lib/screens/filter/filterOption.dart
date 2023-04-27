import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nlytical/block/allcate_block.dart';
import 'package:nlytical/constant/global.dart';
import 'package:nlytical/screens/filter/filterModel.dart';
import 'package:nlytical/screens/filter/filterRes.dart';
import 'package:http/http.dart' as http;
import 'package:nlytical/constant/sizeconfig.dart';
import 'package:nlytical/screens/model/categories_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class SelectFilter extends StatefulWidget {
  @override
  _SelectFilterState createState() => _SelectFilterState();
}

class _SelectFilterState extends State<SelectFilter> {
  // bool checkedValue = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var array = [];
  var rat;

  @override
  void initState() {
    allcate.allcateSink();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Container(
        //  decoration: BoxDecoration(
        //     image: DecorationImage(
        //       image: AssetImage('assets/images/back.jpg'),
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            title: Text("Filter"),
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 20),
                  child: Text(
                    "Categories",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.blockSizeHorizontal * 5),
                  ),
                ),
                Container(
                  width: SizeConfig.screenWidth,
                  child: StreamBuilder<CateModel>(
                    stream: allcate.allcateStream,
                    builder: (context, AsyncSnapshot<CateModel> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CupertinoActivityIndicator());
                      }
                      List<Categories> allRestaurent =
                          snapshot.data.categories != null
                              ? snapshot.data.categories
                              : [];
                      return allRestaurent.length > 0
                          ? ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: allRestaurent.length,
                              //scrollDirection: Axis.horizontal,
                              // itemBuilder: (context, int index) => Column(
                              //   children: <Widget>[
                              //     Container(
                              //       // padding: EdgeInsets.only(top: 10),
                              //       child: Material(
                              //         color: index % 2 == 0
                              //             ? Color(0XFF062C3C)
                              //             : Color(0XFF003E4F),
                              //         child: Center(
                              //           child: widgetCatedata(allRestaurent[index]),
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              itemBuilder: (context, int index) {
                                return //Text(allcategory.coursesList[index].firstName[0]);
                                    widgetCatedata(allRestaurent[index]);
                              },

                              // {
                              //   return InkWell(
                              //     onTap: () {},
                              //     child:
                              //   );
                              // },
                            )
                          : Center(
                              child: Text(
                                "Don't have any restaurants now",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 20),
                  child: Text(
                    "Rating",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.blockSizeHorizontal * 5),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 25),
                  child: RatingBar.builder(
                    // initialRating: restRatings != 'none'
                    //     ? double.parse(restRatings)
                    //     : 0.0,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 25,
                    ignoreGestures: false,
                    unratedColor: Colors.grey,
                    itemBuilder: (context, _) =>
                        Icon(Icons.star, color: Color(0xFF1E3C72)),
                    onRatingUpdate: (rating) {
                      rat = rating.toString();
                      print(rating);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Center(
                    child: CupertinoButton(
                      onPressed: () async {
                        if (array.length > 0 && rat != null) {
                          print(array);
                          print(rat);
                          try {
                            String url =
                                baseUrl()+'filter';

                            final headers = {
                              "Accept": "application/json",
                              "Content-Type":
                                  "application/x-www-form-urlencoded"
                            };

                            final form = [];

                            for (var value in array) {
                              form.add("category[]=$value");
                            }
                            form.add("rating=$rat");

                            final body = form.join('&');

                            final response = await http.post(Uri.parse(url),
                                headers: headers, body: body);
                            print(json.decode(response.body));

                            if (response.statusCode == 200) {
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                                   preferences.remove('filter');
                              Map data = json.decode(response.body.toString());
                              String user =
                                  jsonEncode(FilterModel.fromJson(data));
                              preferences.setString('filter', user);
                              //  print(json.decode(response.body));

                
                                 
                              array.clear();
                              setState(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FilterRes()),
                                );
                              });

                              return json.decode(response.body);
                            }

                            return null;
                          } catch (exception) {
                            print(exception);

                            return null;
                          }
                        } else {
                          Toast.show("Select categories or Rating to continue",
                              context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM);
                        }
                      },
                      color: Color(0xFF1E3C72),
                      borderRadius: new BorderRadius.circular(30.0),
                      child: new Text(
                        "Apply Filters",
                        textAlign: TextAlign.center,
                        style: new TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget widgetCatedata(Categories categories) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            width: MediaQuery.of(context).size.width * 0.75,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  padding: const EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 10,
                        // offset: Offset(0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Center(
                      child: new Image.network(categories.icon, width: 20)),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Text(
                    categories.cName,
                    style:
                        TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 4),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
          array.contains(categories.id)
              ? Expanded(
                  child: Checkbox(
                    value: categories.dataV = true,
                    onChanged: (bool newValue) {
                      setState(() {
                        array.remove(categories.id);
                      });
                    },
                  ),
                )
              : Expanded(
                  child: Checkbox(
                    value: categories.dataV = false,
                    onChanged: (bool newValue) {
                      setState(() {
                        array.add(categories.id);
                      });
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
