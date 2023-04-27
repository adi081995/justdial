import 'dart:convert';
import 'package:awesome_loader/awesome_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nlytical/block/get_rest_review.dart';
import 'package:nlytical/constant/global.dart';
import 'package:nlytical/models/get_review.dart';
import 'package:nlytical/screens/model/detail_modal.dart';
import 'package:toast/toast.dart';

// ignore: must_be_immutable
class RateRiview extends StatefulWidget {
  Restaurant restaurants;
  List<Review> review;
  Function refresh;

  RateRiview({this.restaurants, this.review, this.refresh});
  @override
  _RestaurentDescState createState() => _RestaurentDescState();
}

class _RestaurentDescState extends State<RateRiview> {
  final _reviewController = TextEditingController();
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: appColorWhite,
        body: _designProfile(context),
      ),
    );
  }

  Widget _designProfile(BuildContext context) {
    return ListView(
      children: <Widget>[
        Stack(
          children: [
            _poster2(context),
            _customAppbar(),
          ],
        ),
        _userDetailContainer(context),
      ],
    );
  }

  Widget _customAppbar() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
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
    );
  }

  Widget _userDetailContainer(BuildContext context) {
    return Align(
      // alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                left: 20.0,
                right: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  nameandlike(context),
                  Container(
                    height: 10,
                  ),
                  widgetText(),
                  SizedBox(height: 20),
                  ratingbar(),
                  SizedBox(height: 20),
                  textReview(),
                  Container(height: 20),
                  addYourReview(),
                  Container(
                    height: 25,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textReview() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: ReviewtextField(
        controller: _reviewController,
        textInputAction: TextInputAction.done,
        maxLines: 4,
        hintText: 'Write your review...',
      ),
    );
  }

  Widget ratingbar() {
    return Center(
      child: Container(
        child: RatingBar.builder(
          initialRating: 2.5,
          minRating: 0,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 40,
          unratedColor: Colors.grey,
          itemBuilder: (context, _) => Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              child: Icon(Icons.star, color: Color(0xFF1E3C72))),
          onRatingUpdate: (rating) {
            print(rating);
            setState(() {
              rateValue = rating;
            });
          },
        ),
      ),
    );
  }

  Widget _poster2(BuildContext context) {
    Widget carousel = widget.restaurants.allImage.length == 0
        ? Center(child: CircularProgressIndicator())
        : Carousel(
            images: widget.restaurants.allImage.map((it) {
              return ClipRRect(
                // borderRadius: new BorderRadius.only(
                //   bottomLeft: const Radius.circular(40.0),
                //   bottomRight: const Radius.circular(40.0),
                // ),
                child: Container(
                  child: CachedNetworkImage(
                    imageUrl: it,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
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
                        margin: EdgeInsets.all(35.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(appColorGreen),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }).toList(),
            showIndicator: true,
            dotBgColor: Colors.transparent,
            borderRadius: false,
            autoplay: false,
            dotSize: 5.0,
            dotSpacing: 15.0,
          );

    return SizedBox(
        height: 400, width: MediaQuery.of(context).size.width, child: carousel);
  }

  double rateValue = 2.5;

  Widget widgetText() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'How was your',
                style: TextStyle(
                    letterSpacing: 1,
                    color: Color(0xFF1E3C72),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'experience with this place?',
                style: TextStyle(
                    letterSpacing: 1,
                    color: Color(0xFF1E3C72),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget nameandlike(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 15, top: 10),
      child: Text(
        widget.restaurants.resName,
        style: TextStyle(
            fontSize: 18, color: appColorGreen, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget addYourReview() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          height: 55,
          width: 150,
           // ignore: deprecated_member_use
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            color: Color(0xFF1E3C72),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Text(
                      "Send",
                      style: TextStyle(
                          fontSize: 17,
                          fontStyle: FontStyle.normal,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              if (_reviewController.text.length > 0 && rateValue != null) {
                addReviewApiCall();
              } else {
                Toast.show("Write Review or Select Rating ", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget restreview(BuildContext context) {
    return Center(
      child: Container(
        child: SizedBox(
          height: 230,
          child: StreamBuilder<GetRestReview>(
            stream: getRestRreviewBloc.favouriteStream,
            builder: (context, AsyncSnapshot<GetRestReview> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: AwesomeLoader(
                    color: appColorWhite,
                    loaderType: 4,
                  ),
                );
              }
              List<RestReview> review =
                  snapshot.data.review != null ? snapshot.data.review : [];
              return review.length > 0
                  ? ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: review.length,
                      //scrollDirection: Axis.horizontal,
                      itemBuilder: (context, int index) {
                        return InkWell(
                          onTap: () {},
                          child: widgetCard(review[index]),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        "Don't have any review now",
                        style: TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }

  Widget widgetCard(RestReview review) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0)),
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(50.0)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: SvgPicture.asset('assets/images/profile.svg'),
                  ),
                ),
              ),
              Container(width: 10.0),
              Flexible(
                fit: FlexFit.loose,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(height: 10.0),
                    Text(
                      review.revUser,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    RatingBar.builder(
                      initialRating: review.revStars != 'none'
                          ? double.parse(review.revStars)
                          : 0.0,
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 10,
                      ignoreGestures: true,
                      unratedColor: Colors.grey,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.white,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                    Text(
                      review.revText,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                    ),
                    // Text(
                    //   dateformate,
                    //   style: TextStyle(fontSize: 12),
                    // ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  addReviewApiCall() async {
    try {
      Map<String, String> headers = {
        'content-type': 'application/x-www-form-urlencoded',
      };
      var map = new Map<String, dynamic>();
      map['user_id'] = userID;
      map['res_id'] = widget.restaurants.resId;
      map['ratings'] = rateValue.toString();
      map['text'] = _reviewController.text;

      final response = await client.post(Uri.parse(baseUrl() + "give_review"),
          headers: headers, body: map);

      var dic = json.decode(response.body);
      if (dic["status"] == 1) {
        Toast.show("Your review has been added!", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

        Navigator.pop(context);
        widget.refresh();
      } else {
        Toast.show("Something went wrong", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    } on Exception {
      Toast.show("No Internet connection", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      throw Exception('No Internet connection');
    }
  }
}
