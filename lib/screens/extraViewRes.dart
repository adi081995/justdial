// import 'package:awesome_loader/awesome_loader.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:happy_hearts_pet_care_services/block/getRes_bloc.dart';
// import 'package:happy_hearts_pet_care_services/constant/global.dart';
// import 'package:happy_hearts_pet_care_services/models/getResModel.dart';
// import 'package:happy_hearts_pet_care_services/screens/restaurent_des.dart';
// import 'drawer.dart';

// class ViewRes extends StatefulWidget {
//   String id;
//   String name;
//   ViewRes({this.id, this.name});

//   @override
//   _HomeState createState() => _HomeState();
// }

// class _HomeState extends State<ViewRes> {
//   initState() {
//     super.initState();
//   }

//   dispose() {
//     super.dispose();
//   }

//   var scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   Widget build(BuildContext context) {
//     getResbloc.getResSink(widget.id);
//     return Container(
//       decoration: BoxDecoration(color: Colors.yellow),
//       child: Scaffold(
//         key: scaffoldKey,
//         appBar: AppBar(
//           backgroundColor: Color(0XFF1A5361),
//           elevation: 0,
//           title: Text(widget.name),
//           centerTitle: true,
//           leading: GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => FullScreenDrawer()),
//               );
//             },
//             child: Icon(
//               Icons.menu, // add custom icons also
//             ),
//           ),
//           actions: <Widget>[
//             Padding(
//                 padding: EdgeInsets.only(right: 20.0),
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: Icon(Icons.arrow_back),
//                 )),
//           ],
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             children: <Widget>[
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: <Widget>[
//                   Padding(
//                     padding:
//                         const EdgeInsets.only(left: 25, top: 15, bottom: 10),
//                     child: Text(
//                       'Discover',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               _cardwidget1(context),
//               SizedBox(
//                 height: 20,
//               ),
//               // _locationwidget(context),
//               SizedBox(
//                 height: 10,
//               ),
//               // SearchTextfield(),
//               SizedBox(
//                 height: 15,
//               ),
//               // _catewidget(context),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _cardwidget1(BuildContext context) {
//     return Container(
//         height: 300,
//         decoration: BoxDecoration(),
//         child: StreamBuilder<GetResModel>(
//             stream: getResbloc.getResStream,
//             builder: (context, AsyncSnapshot<GetResModel> snapshot) {
//               if (!snapshot.hasData) {
//                 return Center(
//                   child: AwesomeLoader(
//                     color: Colors.white,
//                     loaderType: 4,
//                   ),
//                 );
//               }
//               List<Restaurants1> res = snapshot.data.restaurants != null
//                   ? snapshot.data.restaurants
//                   : [];
//               return res.length > 0
//                   ? ListView.builder(
//                       itemCount: res.length,
//                       itemBuilder: (context, int index) {
//                         return InkWell(
//                           onTap: () {},
//                           child: _nearYouBuildItem(context, res[index]),
//                         );
//                       },
//                     )
//                   : Center(
//                       child: Text(
//                         "No item in this category ",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontStyle: FontStyle.normal,
//                         ),
//                       ),
//                     );
//             }));
//   }

//   Widget _nearYouBuildItem(BuildContext context, Restaurants1 restaurant) {
//     return Stack(
//       children: <Widget>[
//         GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               CupertinoPageRoute(
//                 builder: (context) => RestaurentDesc(
//                   likeStatus:
//                       likedRestaurent.contains(restaurant.resId) ? 'yes' : 'no',
//                   restID: restaurant.resId,
//                   restName: restaurant.resName,
//                   restDesc: restaurant.resDesc,
//                   restImage: restaurant.resImage.resImag0,
//                   resPhone: restaurant.resPhone,
//                   resAddress: restaurant.resAddress,
//                   restRatings: restaurant.resRatings,
//                 ),
//               ),
//             );
//           },
//           child: Padding(
//             padding: const EdgeInsets.only(left: 17, right: 17, top: 5),
//             child: Container(
//               margin: EdgeInsets.only(top: 10.0),
//               height: 120,
//               width: MediaQuery.of(context).size.width - 20,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.all(Radius.circular(10.0)),
//               ),
//               child: Row(
//                 children: <Widget>[
//                   _itemImage(context, restaurant),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: _itemDetail(context, restaurant),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _itemImage(BuildContext context, Restaurants1 restaurant) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 10.0, bottom: 10),
//       child: Container(
//         height: 90,
//         width: 90,
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: Colors.black,
//           ),
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(8.0),
//           child: CachedNetworkImage(
//             imageUrl: restaurant.resImage.resImag0,
//             imageBuilder: (context, imageProvider) => Container(
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: imageProvider,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             placeholder: (context, url) => Center(
//               child: Container(
//                 margin: EdgeInsets.all(35.0),
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2.0,
//                   valueColor: new AlwaysStoppedAnimation<Color>(appColorGreen),
//                 ),
//               ),
//             ),
//             errorWidget: (context, url, error) => Icon(Icons.error),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _itemDetail(BuildContext context, Restaurants1 restaurant) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 10.0, top: 10),
//       child: Container(
//         height: 120,
//         width: MediaQuery.of(context).size.width - 175,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             _itemNameAndLike(context, restaurant),
//             SizedBox(height: 5),
//             _ratingAndCount(context, restaurant),
//             SizedBox(height: 5),
//             // _openCloseStatus(context, restaurant),
//             _itemDescription(context, restaurant),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _itemNameAndLike(BuildContext context, Restaurants1 restaurant) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         Container(
//           width: MediaQuery.of(context).size.width - 235,
//           child: Text(
//             restaurant.resName,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               fontStyle: FontStyle.normal,
//               fontWeight: FontWeight.w700,
//               fontSize: 18,
//             ),
//           ),
//         ),
//         // Container(
//         //   // width: MediaQuery.of(context).size.width - 325,
//         //   child: Row(
//         //     children: <Widget>[
//         //       likedRestaurent.contains(restaurant.resId)
//         //           ? InkWell(
//         //               onTap: () {
//         //                 // likeBloc.likeSink(userID, restaurants.resId);
//         //               },
//         //               child: SvgPicture.asset(
//         //                 Images.heartfill,
//         //                 color: Colors.red,
//         //                 height: 20.0,
//         //                 width: 20.0,
//         //               ),
//         //             )
//         //           : InkWell(
//         //               onTap: () {
//         //                 // likeBloc.likeSink(userID, restaurants.resId);
//         //                 LikeApi()
//         //                     .likeApi(userID, restaurant.resId)
//         //                     .then((onValue) {
//         //                   likedRestaurent = [];
//         //                   FavouriteApi().favouriteApi(userID).then((favourite) {
//         //                     for (FavRestaurants data in favourite.restaurants) {
//         //                       setState(() {
//         //                         likedRestaurent.add(data.resId);
//         //                       });
//         //                     }
//         //                   });
//         //                 });
//         //               },
//         //               child: SvgPicture.asset(
//         //                 Images.heart,
//         //                 height: 20.0,
//         //                 width: 20.0,
//         //               ),
//         //             ),
//         //       Container(width: 5.0),
//         //     ],
//         //   ),
//         // ),
//       ],
//     );
//   }

//   Widget _ratingAndCount(BuildContext context, Restaurants1 restaurant) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 2.0),
//       child: Row(
//         children: <Widget>[
//           RatingBar(
//             initialRating: restaurant.resRatings != 'none'
//                 ? double.parse(restaurant.resRatings)
//                 : 0.0,
//             minRating: 0,
//             direction: Axis.horizontal,
//             allowHalfRating: true,
//             itemCount: 5,
//             itemSize: 18,
//             ignoreGestures: true,
//             itemBuilder: (context, _) => Icon(
//               Icons.star,
//               color: Colors.amber,
//             ),
//             onRatingUpdate: (rating) {
//               print(rating);
//             },
//           ),
//           // Text("(45)")
//         ],
//       ),
//     );
//   }

//   Widget _openCloseStatus(BuildContext context, Restaurants1 restaurant) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 10.0),
//       child: Row(
//         children: <Widget>[
//           Container(width: 5.0),
//           Text(
//             restaurant.resIsOpen,
//             style: TextStyle(fontStyle: FontStyle.normal, color: appColorGreen),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _itemDescription(BuildContext context, Restaurants1 restaurant) {
//     return Text(
//       restaurant.resDesc,
//       overflow: TextOverflow.ellipsis,
//       maxLines: 2,
//       style: TextStyle(
//         fontStyle: FontStyle.normal,
//       ),
//     );
//   }
// }
