// import 'package:awesome_loader/awesome_loader.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_pro/carousel_pro.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:happy_hearts_pet_care_services/block/favourite_bloc.dart';
// import 'package:happy_hearts_pet_care_services/block/get_rest_review.dart';
// import 'package:happy_hearts_pet_care_services/block/like_bloc.dart';
// import 'package:happy_hearts_pet_care_services/constant/global.dart';
// import 'package:happy_hearts_pet_care_services/constant/sizeconfig.dart';
// import 'package:happy_hearts_pet_care_services/images/images.dart';
// import 'package:happy_hearts_pet_care_services/models/favourite_restaurent_modal.dart';
// import 'package:happy_hearts_pet_care_services/models/get_review.dart';

// import 'package:happy_hearts_pet_care_services/provider/favourite_api.dart';
// import 'package:happy_hearts_pet_care_services/provider/like_api.dart';
// import 'package:happy_hearts_pet_care_services/provider/unlike_api.dart';
// import 'package:happy_hearts_pet_care_services/screens/ratingscreen.dart';

// // import 'package:vegan_vibez/src/model/favourite_restaurent_modal.dart';

// // ignore: must_be_immutable
// class GateRestReview extends StatefulWidget {
//   // final Restaurants restaurants;
//   final String restID;
//   final String restName;
//   final String restDesc;
//   final String resNameU;
//   final String resWebsite;
//   final String restImage;
//   final String resPhone;
//   final String resAddress;
//   final String restRatings;
//   final List images;
//   String likeStatus;

//   GateRestReview({
//     this.restID,
//     this.restName,
//     this.restDesc,
//     this.resNameU,
//     this.resWebsite,
//     this.restImage,
//     this.resPhone,
//     this.resAddress,
//     this.restRatings,
//     this.images,
//     this.likeStatus,
//   });
//   @override
//   _GateRestReviewState createState() => _GateRestReviewState(
//         restID: restID,
//         restName: restName,
//         restDesc: restDesc,
//         resNameU: resNameU,
//         resWebsite: resWebsite,
//         restImage: restImage,
//         resPhone: resPhone,
//         resAddress: resAddress,
//         restRatings: restRatings,
//         images: images,
//         likeStatus: likeStatus,
//       );
// }

// class _GateRestReviewState extends State<GateRestReview> {
//   final String restID;
//   final String restName;
//   final String restDesc;
//   final String resNameU;
//   final String resWebsite;
//   final String restImage;
//   final String resPhone;
//   final String resAddress;
//   final List images;
//   final String restRatings;
//   String likeStatus;

//   _GateRestReviewState({
//     this.restID,
//     this.restName,
//     this.restDesc,
//     this.resNameU,
//     this.resWebsite,
//     this.restImage,
//     this.resPhone,
//     this.resAddress,
//     this.restRatings,
//     this.images,
//     this.likeStatus,
//   });

//   final _reviewController = TextEditingController();
//   void initState() {
//     // RestReviewApi().restReviewApi(restID);
//     getRestRreviewBloc.favouriteSink(restID);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // profileBloc.profileSink(userID);
//     return Container(
//       decoration: BoxDecoration(
//         color: Color(0XFF003F4F),
//       ),
//       child: Scaffold(
//         extendBodyBehindAppBar: true,
//         appBar: AppBar(
//           backgroundColor: Color(0XFF1A5361),
//           elevation: 0,
//           // title: Text("Hello Appbar"),
//           leading: GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => FullScreenDrawer()),
//               );
//             },
//             child: Container(
//                 height: 100,
//                 width: 100,
//                 child: Image.asset(
//                   'assets/images/menuicon.png',
//                 )),
//           ),
//           actions: <Widget>[
//             Padding(
//                 padding: EdgeInsets.only(right: 20.0),
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Icon(
//                     Icons.arrow_back,
//                     color: Colors.white,
//                   ),
//                 )),
//           ],
//         ),
//         body: _designProfile(context),
//       ),
//     );
//   }

//   Widget _designProfile(BuildContext context) {
//     return Container(
//       color: Colors.black,
//       child: Container(
//         child: ListView(
//           children: <Widget>[
//             Stack(
//               children: <Widget>[
//                 _userDetailContainer(context),
//                 // _poster(context),
//                 _poster2(context),
//                 like(context),
//               ],
//             ),

//             // _userImage(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _userDetailContainer(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Color(0XFF003F4F),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.only(
//               top: 400.0,
//               left: 20.0,
//               right: 20.0,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 nameandlike(context),
//                 Container(
//                   height: 5,
//                 ),
//                 yelloCardForReview(context),

//                 SizedBox(height: 10),

//                 // widgetText(),
//                 // SizedBox(height: 20),
//                 // ratingbar(),
//                 // SizedBox(height: 20),
//                 // textReview(),
//                 // Container(height: 20),
//                 // addYourReview(context),
//                 // Container(
//                 //   height: 25,
//                 // ),
//                 SizedBox(height: 25),
//               ],
//             ),
//           ),
//           Container(
//             width: double.infinity,
//             height: 55,
//             color: Color(0xFFF28F51),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.only(left: 35),
//                       child: Text(
//                         'Reviews',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             letterSpacing: 1.0),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.only(left: 35),
//                       child: Text(
//                         'المراجعات',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 10,
//                             fontWeight: FontWeight.bold,
//                             letterSpacing: 1.0),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Flexible(fit: FlexFit.loose, child: restreview(context)),
//           addYourReview(context),
//         ],
//       ),
//     );
//   }

//   Widget yelloCardForReview(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 20.0, left: 15, right: 15),
//       child: Container(
//         height: 35,
//         // margin: EdgeInsets.only(top: 20.0),
//         width: MediaQuery.of(context).size.width - 150,

//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             Container(
//               child: Row(
//                 children: <Widget>[
//                   RatingBar(
//                     initialRating:
//                         restRatings != 'none' ? double.parse(restRatings) : 0.0,
//                     minRating: 0,
//                     direction: Axis.horizontal,
//                     allowHalfRating: true,
//                     itemCount: 5,
//                     itemSize: 16,
//                     ignoreGestures: true,
//                     unratedColor: Colors.grey,
//                     itemBuilder: (context, _) => Icon(
//                       Icons.star,
//                       color: Colors.white,
//                     ),
//                     onRatingUpdate: (rating) {
//                       print(rating);
//                     },
//                   ),

//                   Padding(
//                     padding: const EdgeInsets.only(left: 7),
//                     child: Text(
//                       restRatings,
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                   // Text("(45)")
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget addYourReview(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 20, bottom: 40),
//       child: Align(
//         alignment: Alignment.topCenter,
//         child: SizedBox(
//           height: 60,
//           width: 170,
//           child: RaisedButton(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//             color: Color(0XFF106C6F),
//             child: Row(
//               children: <Widget>[
//                 Expanded(
//                   child: Center(
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 2),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text(
//                             'Rate This',
//                             style: TextStyle(
//                                 fontSize: 17,
//                                 fontStyle: FontStyle.normal,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white),
//                           ),
//                           Text(
//                             'قيم هذا',
//                             style: TextStyle(
//                                 fontSize: 15,
//                                 fontStyle: FontStyle.normal,
//                                 color: Colors.white,
//                                 fontFamily: 'arabic'),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Icon(
//                   Icons.star_border,
//                   color: Colors.white,
//                   size: 30.0,
//                 ),
//               ],
//             ),
//             onPressed: () {
//               // addReview();
//               // showMessageDialog();
//               Navigator.push(
//                 context,
//                 CupertinoPageRoute(
//                   builder: (context) => RateRiview(
//                     likeStatus:
//                         likedRestaurent.contains(widget.restID) ? 'yes' : 'no',
//                     restID: widget.restID,
//                     restName: widget.restName,
//                     restDesc: widget.restDesc,
//                     resNameU: widget.resNameU,
//                     resWebsite: widget.resWebsite,
//                     restImage: widget.restImage,
//                     resPhone: widget.resPhone,
//                     resAddress: widget.resAddress,
//                     restRatings: widget.restRatings,
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget textReview() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 20.0, right: 20.0),
//       child: ReviewtextField(
//         controller: _reviewController,
//         textInputAction: TextInputAction.done,
//         maxLines: 4,
//         hintText: 'Write your review...',
//       ),
//     );
//   }

//   Widget ratingbar() {
//     return Center(
//       child: Container(
//         child: RatingBar(
//           initialRating: 2.5,
//           minRating: 0,
//           direction: Axis.horizontal,
//           allowHalfRating: true,
//           itemCount: 5,
//           itemSize: 40,
//           itemBuilder: (context, _) => Container(
//               margin: EdgeInsets.symmetric(horizontal: 5.0),
//               child: Icon(Icons.star, color: Color(0xFFF28F51))),
//           onRatingUpdate: (rating) {
//             print(rating);
//             setState(() {
//               rateValue = rating;
//             });
//           },
//         ),
//       ),
//     );
//   }

//   Widget _poster2(BuildContext context) {
//     Widget carousel = images == null
//         ? CircularProgressIndicator()
//         : Carousel(
//             images: images.map((it) {
//               return ClipRRect(
//                 borderRadius: new BorderRadius.only(
//                   bottomLeft: const Radius.circular(40.0),
//                   bottomRight: const Radius.circular(40.0),
//                 ),
//                 child: Container(
//                   child: CachedNetworkImage(
//                     imageUrl: it,
//                     imageBuilder: (context, imageProvider) => Container(
//                       decoration: BoxDecoration(
//                         borderRadius: new BorderRadius.only(
//                           bottomLeft: const Radius.circular(40.0),
//                           bottomRight: const Radius.circular(40.0),
//                         ),
//                         image: DecorationImage(
//                           image: imageProvider,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     placeholder: (context, url) => Center(
//                       child: Container(
//                         margin: EdgeInsets.all(35.0),
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2.0,
//                           valueColor:
//                               new AlwaysStoppedAnimation<Color>(appColorGreen),
//                         ),
//                       ),
//                     ),
//                     errorWidget: (context, url, error) => Icon(Icons.error),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               );
//             }).toList(),
//             showIndicator: true,
//             dotBgColor: Colors.transparent,
//             borderRadius: false,
//             autoplay: false,
//             dotSize: 5.0,
//             dotSpacing: 15.0,
//           );

//     return SizedBox(
//         height: SizeConfig.safeBlockVertical * 48,
//         width: MediaQuery.of(context).size.width,
//         child: carousel

//         // Carousel(
//         //   images: [
//         // ClipRRect(
//         //   borderRadius: new BorderRadius.only(
//         //     bottomLeft: const Radius.circular(40.0),
//         //     bottomRight: const Radius.circular(40.0),
//         //   ),
//         //   // width: MediaQuery.of(context).size.width,

//         //   child: Container(
//         //     child: CachedNetworkImage(
//         //       imageUrl: restImage,
//         //       imageBuilder: (context, imageProvider) => Container(
//         //         decoration: BoxDecoration(
//         //           borderRadius: new BorderRadius.only(
//         //             bottomLeft: const Radius.circular(40.0),
//         //             bottomRight: const Radius.circular(40.0),
//         //           ),
//         //           image: DecorationImage(
//         //             image: imageProvider,
//         //             fit: BoxFit.cover,
//         //           ),
//         //         ),
//         //       ),
//         //       placeholder: (context, url) => Center(
//         //         child: Container(
//         //           margin: EdgeInsets.all(35.0),
//         //           child: CircularProgressIndicator(
//         //             strokeWidth: 2.0,
//         //             valueColor:
//         //                 new AlwaysStoppedAnimation<Color>(appColorGreen),
//         //           ),
//         //         ),
//         //       ),
//         //       errorWidget: (context, url, error) => Icon(Icons.error),
//         //       fit: BoxFit.cover,
//         //     ),
//         //   ),
//         // ),

//         //     /* image */

//         //     ClipRRect(
//         //       borderRadius: new BorderRadius.only(
//         //         bottomLeft: const Radius.circular(40.0),
//         //         bottomRight: const Radius.circular(40.0),
//         //       ),
//         //       // width: MediaQuery.of(context).size.width,

//         //       child: Container(
//         //         margin: EdgeInsets.symmetric(horizontal: 5.0),
//         //         child: CachedNetworkImage(
//         //           imageUrl: restImage,
//         //           imageBuilder: (context, imageProvider) => Container(
//         //             decoration: BoxDecoration(
//         //               borderRadius: new BorderRadius.only(
//         //                 bottomLeft: const Radius.circular(40.0),
//         //                 bottomRight: const Radius.circular(40.0),
//         //               ),
//         //               image: DecorationImage(
//         //                 image: imageProvider,
//         //                 fit: BoxFit.cover,
//         //               ),
//         //             ),
//         //           ),
//         //           placeholder: (context, url) => Center(
//         //             child: Container(
//         //               margin: EdgeInsets.all(35.0),
//         //               child: CircularProgressIndicator(
//         //                 strokeWidth: 2.0,
//         //                 valueColor:
//         //                     new AlwaysStoppedAnimation<Color>(appColorGreen),
//         //               ),
//         //             ),
//         //           ),
//         //           errorWidget: (context, url, error) => Icon(Icons.error),
//         //           fit: BoxFit.cover,
//         //         ),
//         //       ),
//         //     ),
//         //     // ExactAssetImage("assets/images/LaunchImage.jpg")
//         //   ],
//         //   showIndicator: true,

//         //   dotBgColor: Colors.transparent,
//         //   borderRadius: false,
//         //   autoplay: false,
//         //   dotSize: 5.0,
//         //   dotSpacing: 15.0,
//         //   // dotColor: Colors.lightGreenAccent,

//         //   // dotSize: 4.0,
//         //   // dotSpacing: 15.0,
//         //   // dotColor: Colors.lightGreenAccent,
//         //   // indicatorBgPadding: 5.0,
//         //   // dotBgColor: Colors.purple.withOpacity(0.5),
//         //   // borderRadius: true,
//         // ),
//         );

//     // CarouselSlider(
//     //   aspectRatio: 2.0,
//     //   onPageChanged: (index) {
//     //     setState(() {
//     //       _current = index;
//     //     });
//     //   },
//     //   height: 350.0,
//     //   items: [
//     //     restImage,
//     //     restImage,
//     //     restImage,
//     //     restImage,
//     //   ].map((i) {
//     //     return Builder(
//     //       builder: (BuildContext context) {
//     //         return ClipRRect(
//     //             borderRadius: new BorderRadius.only(
//     //               bottomLeft: const Radius.circular(40.0),
//     //               bottomRight: const Radius.circular(40.0),
//     //             ),
//     //             // width: MediaQuery.of(context).size.width,

//     //             child: Container(
//     //               margin: EdgeInsets.symmetric(horizontal: 5.0),
//     //               child: CachedNetworkImage(
//     //                 imageUrl: '$i',
//     //                 imageBuilder: (context, imageProvider) => Container(
//     //                   decoration: BoxDecoration(
//     //                     borderRadius: new BorderRadius.only(
//     //                       bottomLeft: const Radius.circular(40.0),
//     //                       bottomRight: const Radius.circular(40.0),
//     //                     ),
//     //                     image: DecorationImage(
//     //                       image: imageProvider,
//     //                       fit: BoxFit.cover,
//     //                     ),
//     //                   ),
//     //                 ),
//     //                 placeholder: (context, url) => Center(
//     //                   child: Container(
//     //                     margin: EdgeInsets.all(35.0),
//     //                     child: CircularProgressIndicator(
//     //                       strokeWidth: 2.0,
//     //                       valueColor:
//     //                           new AlwaysStoppedAnimation<Color>(appColorGreen),
//     //                     ),
//     //                   ),
//     //                 ),
//     //                 errorWidget: (context, url, error) => Icon(Icons.error),
//     //                 fit: BoxFit.cover,
//     //               ),
//     //             ));
//     //       },
//     //     );
//     //   }).toList(),
//     // );
//   }

//   double rateValue = 2.5;

//   Widget widgetText() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 40),
//       child: Column(
//         children: <Widget>[
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text(
//                 'How was your',
//                 style: TextStyle(
//                     letterSpacing: 1,
//                     color: Color(0xFFF28F51),
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text(
//                 'experience with this place?',
//                 style: TextStyle(
//                     letterSpacing: 1,
//                     color: Color(0xFFF28F51),
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget like(BuildContext context) {
//     return Align(
//       alignment: Alignment.centerRight,
//       child: Padding(
//         padding: const EdgeInsets.only(top: 325, right: 40),
//         child: InkWell(
//           onTap: () {
//             likeBloc.likeSink(userID, restID);
//           },
//           child: likeStatus == 'no'
//               ? InkWell(
//                   onTap: () {
//                     Loader().showIndicator(context);
//                     LikeApi().likeApi(userID, restID).then((onValue) {
//                       favouriteBloc.favouriteSink(userID);
//                       likedRestaurent = [];
//                       FavouriteApi().favouriteApi(userID).then((favourite) {
//                         for (FavRestaurants data in favourite.restaurants) {
//                           setState(() {
//                             likedRestaurent.add(data.resId);
//                           });
//                         }
//                         likeStatus = 'yes';
//                         setState(() {});
//                         Loader().hideIndicator(context);
//                       });
//                     });
//                   },
//                   child: Container(
//                     height: 55,
//                     width: 55,
//                     decoration: BoxDecoration(
//                         shape: BoxShape.circle, color: Color(0xFF117174)),
//                     child: Stack(
//                       children: <Widget>[
//                         Center(
//                           child: SvgPicture.asset(
//                             Images.heart,
//                             height: 25,
//                             width: 25,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               : InkWell(
//                   onTap: () {
//                     Loader().showIndicator(context);
//                     UnlikeApi().unlikeApi(userID, restID).then((onValue) {
//                       favouriteBloc.favouriteSink(userID);
//                       likedRestaurent = [];
//                       FavouriteApi().favouriteApi(userID).then((favourite) {
//                         for (FavRestaurants data in favourite.restaurants) {
//                           setState(() {
//                             likedRestaurent.add(data.resId);
//                           });
//                         }
//                         likeStatus = 'no';
//                         setState(() {});
//                         Loader().hideIndicator(context);
//                       });
//                     });
//                   },
//                   child: Container(
//                     height: 55,
//                     width: 55,
//                     decoration: BoxDecoration(
//                         shape: BoxShape.circle, color: Color(0xFF117174)),
//                     child: Stack(
//                       children: <Widget>[
//                         Center(
//                           child: SvgPicture.asset(
//                             Images.heartfill,
//                             height: 25,
//                             width: 25,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }

//   Widget nameandlike(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 15, right: 15),
//       child: Column(
//         children: <Widget>[
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Container(
//                 width: MediaQuery.of(context).size.width - 120,
//                 // color: Colors.red,
//                 child: Text(
//                   restName,
//                   style: TextStyle(fontSize: 25, color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Container(
//                 width: MediaQuery.of(context).size.width - 120,
//                 // color: Colors.red,
//                 child: Text(
//                   resNameU,
//                   style: TextStyle(
//                       fontSize: 25, color: Colors.white, fontFamily: 'arabic'),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // Widget addYourReview(BuildContext context) {
//   //   return Padding(
//   //     padding: const EdgeInsets.only(top: 20),
//   //     child: Align(
//   //       alignment: Alignment.topCenter,
//   //       child: SizedBox(
//   //         height: 50,
//   //         width: 150,
//   //         child: RaisedButton(
//   //           shape: RoundedRectangleBorder(
//   //             borderRadius: BorderRadius.circular(10.0),
//   //           ),
//   //           color: Color(0xFFF28F51),
//   //           child: Row(
//   //             children: <Widget>[
//   //               Expanded(
//   //                 child: Center(
//   //                   child: Text(
//   //                     'Send',
//   //                     style: TextStyle(
//   //                         fontSize: 17,
//   //                         fontStyle: FontStyle.normal,
//   //                         color: Colors.white),
//   //                   ),
//   //                 ),
//   //               ),
//   //             ],
//   //           ),
//   //           onPressed: () {
//   //             Loader().showIndicator(context);
//   //             AddReviewApi()
//   //                 .addReviewApi(
//   //               userID,
//   //               restID,
//   //               rateValue.toString(),
//   //               _reviewController.text,
//   //             )
//   //                 .then((_) {
//   //               Loader().hideIndicator(context);
//   //               // Navigator.pop(context);
//   //             });
//   //             print(userID);
//   //           },
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }

//   Widget restreview(BuildContext context) {
//     return Center(
//       child: Container(
//         child: SizedBox(
//           // height: 230,
//           child: StreamBuilder<GetRestReview>(
//             stream: getRestRreviewBloc.favouriteStream,
//             builder: (context, AsyncSnapshot<GetRestReview> snapshot) {
//               if (!snapshot.hasData) {
//                 return Center(
//                   child: AwesomeLoader(
//                     color: appColorWhite,
//                     loaderType: 4,
//                   ),
//                 );
//               }
//               List<RestReview> review =
//                   snapshot.data.review != null ? snapshot.data.review : [];
//               return review.length > 0
//                   ? ListView.builder(
//                       scrollDirection: Axis.vertical,
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: review.length,
//                       //scrollDirection: Axis.horizontal,
//                       itemBuilder: (context, int index) {
//                         return InkWell(
//                           onTap: () {},
//                           child: widgetCard(review[index]),
//                         );
//                       },
//                     )
//                   : Center(
//                       child: Text(
//                         "Don't have any review now",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontStyle: FontStyle.italic,
//                         ),
//                       ),
//                     );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget widgetCard(RestReview review) {
//     return Container(
//       margin: EdgeInsets.all(10.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             // crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Card(
//                 elevation: 4.0,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(50.0)),
//                 child: Container(
//                   height: 50,
//                   width: 50,
//                   decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(50.0)),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(50.0),
//                     child: SvgPicture.asset('assets/images/profile.svg'),
//                   ),
//                 ),
//               ),
//               Container(width: 10.0),
//               Flexible(
//                 fit: FlexFit.loose,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Container(height: 10.0),
//                     Text(
//                       review.revUser,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     RatingBar(
//                       initialRating: review.revStars != 'none'
//                           ? double.parse(review.revStars)
//                           : 0.0,
//                       minRating: 0,
//                       direction: Axis.horizontal,
//                       allowHalfRating: true,
//                       itemCount: 5,
//                       itemSize: 10,
//                       ignoreGestures: true,
//                       unratedColor: Colors.grey,
//                       itemBuilder: (context, _) => Icon(
//                         Icons.star,
//                         color: Colors.white,
//                       ),
//                       onRatingUpdate: (rating) {
//                         print(rating);
//                       },
//                     ),
//                     Text(
//                       review.revText,
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w700,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.clip,
//                     ),
//                     // Text(
//                     //   dateformate,
//                     //   style: TextStyle(fontSize: 12),
//                     // ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
