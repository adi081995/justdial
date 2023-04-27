import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nlytical/constant/global.dart';
import 'package:nlytical/constant/sizeconfig.dart';
import 'package:nlytical/screens/model/profile_model.dart';
//import 'package:intl/intl.dart';

// ignore: must_be_immutable
class MyReviews extends StatefulWidget {
  List<Review> allRestaurent;
  MyReviews({this.allRestaurent});
  @override
  _MyReviewsState createState() => _MyReviewsState();
}

class _MyReviewsState extends State<MyReviews> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: appColorGreen,
          elevation: 2,
          title: Text(
            'My Reviews',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: false,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: _userInfo());
  }

  Widget _userInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
          color: Colors.white,
          height: SizeConfig.screenHeight,
          width: SizeConfig.screenWidth,
          child: widget.allRestaurent.length > 0
              ? ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.allRestaurent.length,
                  itemBuilder: (context, int index) {
                    return //Text(allcategory.coursesList[index].firstName[0]);
                        Column(
                      children: [
                        reviewData(widget.allRestaurent[index]),
                        Padding(
                          padding: const EdgeInsets.only(left: 80, bottom: 20),
                          child: Divider(
                            thickness: 1,
                          ),
                        )
                      ],
                    );
                  },
                )
              : Center(
                  child: Text(
                    "Don't have any restaurants now",
                    style: TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )),
    );
  }

  Widget reviewData(Review review) {
    return Container(
      // height: SizeConfig.screenHeight,
      // width: SizeConfig.screenWidth,
      color: Colors.white,
      child: Container(
        // margin: EdgeInsets.all(10.0),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: review.revResImage != null
                          ? Image.network(
                              review.revResImage,
                              height: 70.0,
                              width: 70.0,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/nature.jpg',
                              height: 70.0,
                              width: 70.0,
                              fit: BoxFit.cover,
                            )),
                  Container(width: 10.0),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Container(height: 10.0),
                        Text(
                          review.revRes,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: SizeConfig.blockSizeHorizontal * 4),
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeHorizontal * 1,
                        ),
                        Text(
                          review.revDate.toString(),
                          // DateFormat('dd MMM yyyy,').format(
                          //     DateTime.fromMillisecondsSinceEpoch(int.parse(
                          //   review.revDate,
                          // ))),
                          style: TextStyle(
                            color: Color(0xFF1E3C72),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeHorizontal * 3,
                        ),
                        RatingBar.builder(
                          initialRating: review.revStars != 'none'
                              ? double.parse(review.revStars)
                              : 0.0,
                          minRating: 0,
                          direction: Axis.horizontal,
                          // allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 15,
                          ignoreGestures: true,
                          unratedColor: Colors.grey,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Color(0xFF1E3C72),
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeHorizontal * 2,
                        ),
                        Text(
                          review.revText,
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w700,
                          ),
                          // maxLines: 2,
                          overflow: TextOverflow.clip,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
