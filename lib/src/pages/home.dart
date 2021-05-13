import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:sparedo_partner/src/elements/CustomAppbar.dart';
import 'package:sparedo_partner/src/elements/DrawerWidget.dart';
import 'package:sparedo_partner/src/pages/detailsPage.dart';
import 'package:sparedo_partner/src/pages/login.dart';

import '../../base_url.dart';
import '../controllers/home_controller.dart';

class HomeWidget extends StatefulWidget {
    final GlobalKey<ScaffoldState> parentScaffoldKey;
    HomeWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends StateMVC<HomeWidget> {
  HomeController _con;

//  Set<List> savedWords = Set<List>();
  final Geolocator geolocator = Geolocator();
  final _amountController = TextEditingController();
  final _rDaysController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey _scaffoldKey = new GlobalKey();
  Position _currentPosition;
  String _currentAddress = "", bookinIdR;
  String selectedBooking = '';
  int respon;
  String UserId;

  int Loginchk;
  bool isSwitched = false;

  Position currentLocation;
  _HomeWidgetState() : super(HomeController()) {
    _con = controller;
  }

  final LocalStorage storage = new LocalStorage("");
  List bookingList = List();
  List addBook = List();
  final ScrollController _scrollController = ScrollController();

  Future LoginCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.get('user_id'));
    print(prefs.get('user_password'));
    final userId = (prefs.get('user_id'));

    UserId = userId;
    var response = await http.get(
        BaseUrl.logCheck + 'user_id=' + UserId + '&' + 'password=' + prefs.get('user_password'));
    json.decode(response.body);
    var jsonBody = response.body;
    var data = json.decode(jsonBody);
    setState(() {
      data = data;
      //     print(data);
    });
    this.Loginchk = data['data'];
    if (this.Loginchk == 1) {
      print('Logdd in');
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('user_id');
      prefs.remove('user_password');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginWidget()));
    }

    // print('listttttda');
    // print(this.Loginchk);
    //
    // print('statusCodew : ' + response.statusCode.toString());
  }

  Future getbookings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.get('user_id'));
    print(prefs.get('user_password'));
    final userId = (prefs.get('user_id'));
    UserId = userId;

    var response = await http.get(BaseUrl.get_buyer + 'user_id=' + UserId);
    print(UserId);

    var jsonBody = response.body;
    var data = json.decode(jsonBody);
    setState(() {
      data = data;
    });

    this.bookingList = data['data'];
    print(this.bookingList);
    if (response.statusCode == 200) {
      print('response body : ${response.body}');
      try {
        json.decode(response.body);
        print('trying to decode  Respose Body result is : success');
      } catch (Ex) {
        print("Exepition with json decode : $Ex");
      }
    }

    if (response.statusCode == 400) {
      respon = response.statusCode;
      Center(child: Text('No Records Found'));

      print('response body : ${response.body}');
      try {
        json.decode(response.body);
        print('trying to decode  Respose Body result is : success');
      } catch (Ex) {
        print("Exepition with json decode : $Ex");
      }
    }
    return response;
  }

  Future BidBook() async {
    // var bookiId= bookingList[index]['id'].toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.getString('user_id');
    setState(() {
      var current_user = (prefs.getString('user_id') ?? '');
      UserId = prefs.getString('user_id');
    });
    var response = await http.post(BaseUrl.save_qoute +
        'seller_id=' +
        UserId +
        '&' +
        'amount=' +
        _amountController.text +
        '&' +
        'return_days=' +
        _rDaysController.text +
        '&' +
        'booking_id=' +
        selectedBooking);
    json.decode(response.body);

    setState(() {
      print(response);
    });
    print('statusCodee : ' + response.statusCode.toString());

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Text('heloo');
          Navigator.pop(context);
        },
      );
      qouteAdded();

      respon = response.statusCode;

      print('response body : ${response.body}');
      try {
        json.decode(response.body);
        print('trying to decode  Respose Body result is : success');
      } catch (Ex) {
        print("Exepition with json decode : $Ex");
      }
    }
    return response;
  }

  void clearText() {
    _amountController.clear();
    _rDaysController.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    displd();
    super.initState();
    getbookings();

    LoginCheck();
  }

  Future refresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      getbookings();
    });
  }

  displd() {
    setState(() {
      addBook.add(selectedBooking);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        // appBar: PreferredSize(
        //     preferredSize: const Size.fromHeight(60), child: CustomAppBar()),
        // drawer: CustomDrawer(),
        appBar: BaseAppBar(
          title: Text('title'),
          appBar: AppBar(),
          // widgets: <Widget>[Icon(Icons.more_vert)],
        ),
        drawer: DrawerWidget(),
        // appBar: AppBar(
        //   leading: new IconButton(
        //     icon: new Icon(Icons.sort, color: Theme.of(context).primaryColor),
        //     onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        //   ),
        //   automaticallyImplyLeading: false,
        //   backgroundColor: Colors.black,
        //   elevation: 0,
        //   centerTitle: true,
        //   // title: ValueListenableBuilder(
        //   //   valueListenable: settingsRepo.setting,
        //   //   builder: (context, value, child) {
        //   //     return Text(
        //   //       value.appName ?? S.of(context).home,
        //   //       style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        //   //     );
        //   //   },
        //   // ),
        //   title: Image.asset(
        //     'assets/img/2.png',
        //     height: MediaQuery.of(context).size.height * 0.5,
        //     width: MediaQuery.of(context).size.width * 0.5,
        //   ),
        //
        //   actions: <Widget>[
        //     Switch(
        //       value: isSwitched,
        //       onChanged: (value) {
        //         setState(() {
        //           isSwitched = value;
        //           print(isSwitched);
        //         });
        //       },
        //       activeTrackColor: Colors.lightGreenAccent,
        //       activeColor: Colors.green,
        //       inactiveTrackColor: Colors.red,
        //     ),
        //   ],
        // ),
        body: RefreshIndicator(
          onRefresh: refresh,
          child: Container(
              child: ListView(
            children: [
              Container(
                height: 8.0.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Buyer Bookings',
                      style: TextStyle(fontSize: 15.0.sp, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Container(
                  height: MediaQuery.of(context).size.height * 0.707,
                  child: bookingList.length > 0
                      ? ListView.builder(
                          itemCount: bookingList.length,
                          physics:
                              new BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    new BoxShadow(
                                      color: Colors.black38,
                                      offset: Offset(0, 3),
                                      blurRadius: 10.0,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                height: 30.0.h,
                                width: 90.0.w,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Container(
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 19.0.h,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(6.0.sp),
                                                child: ClipRect(
                                                  child: Banner(
                                                    message:
                                                        bookingList[index]['id'].toString() ?? '',
                                                    location: BannerLocation.topStart,
                                                    color: Colors.white,
                                                    textStyle: TextStyle(
                                                      color: Colors.black87,
                                                    ),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(10)),
                                                      width: 30.0.w,
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(5.0.sp),
                                                        child: bookingList[index]['image'] == null
                                                            ? Container(
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color: Colors.black87)),
                                                                child: Image.asset(
                                                                    'assets/img/no image.jpg'))
                                                            : CachedNetworkImage(
                                                                imageUrl: BaseUrl.voice +
                                                                    'assets/booking_images/${bookingList[index]['id']}/${bookingList[index]['image']}',
                                                                // fit: BoxFit.cover,
                                                                placeholder: (context, url) =>
                                                                    Image.asset(
                                                                  'assets/img/loading.gif',
                                                                  height: MediaQuery.of(context)
                                                                          .size
                                                                          .height *
                                                                      0.2,
                                                                  width: MediaQuery.of(context)
                                                                          .size
                                                                          .width *
                                                                      0.2,
                                                                  fit: BoxFit.cover,
                                                                ),
                                                              ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 53.0.w,
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Buyer Name',
                                                          style: TextStyle(
                                                              color: Colors.grey, fontSize: 8.0.sp),
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          bookingList[index]['buyer_name']
                                                                  .toString() ??
                                                              '',
                                                          style: TextStyle(
                                                              color: Colors.black87,
                                                              fontSize: 12.0.sp),
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Flexible(
                                                          flex: 1,
                                                          fit: FlexFit.tight,
                                                          child: Container(
                                                            height: 13.0.h,
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 1.0.h,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      "Category",
                                                                      style: TextStyle(
                                                                          color: Colors.grey,
                                                                          fontSize: 8.0.sp),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      bookingList[index]['category']
                                                                              .toString() ??
                                                                          '',
                                                                      style: TextStyle(
                                                                          color: Colors.black87,
                                                                          fontSize: 12.0.sp),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 1.0.h,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment.center,
                                                                  children: [
                                                                    InkWell(
                                                                      onTap: () {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder:
                                                                                    (context) =>
                                                                                        DeatilsPage(
                                                                                          bookingList[
                                                                                                  index]
                                                                                              [
                                                                                              'id'],
                                                                                        )));
                                                                      },
                                                                      child: Container(
                                                                        decoration: BoxDecoration(
                                                                            color: Colors.black,
                                                                            borderRadius:
                                                                                BorderRadius
                                                                                    .circular(6)),
                                                                        height: 5.0.h,
                                                                        width: 22.0.w,
                                                                        child: Center(
                                                                            child: Text(
                                                                          'Details',
                                                                          style: TextStyle(
                                                                              color:
                                                                                  Theme.of(context)
                                                                                      .accentColor),
                                                                        )),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Flexible(
                                                          flex: 1,
                                                          fit: FlexFit.tight,
                                                          child: Container(
                                                            height: 13.0.h,
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment.end,
                                                              children: [
                                                                bookingList[index]['hide_status'] ==
                                                                        0
                                                                    ? InkWell(
                                                                        onTap: () {
                                                                          selectedBooking =
                                                                              bookingList[index]
                                                                                      ['id']
                                                                                  .toString();

                                                                          _showMyDialog();
                                                                        },
                                                                        splashColor: Colors.grey,
                                                                        child: Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          children: [
                                                                            Container(
                                                                              decoration:
                                                                                  BoxDecoration(
                                                                                color: Theme.of(
                                                                                        context)
                                                                                    .accentColor,
                                                                                borderRadius:
                                                                                    BorderRadius
                                                                                        .circular(
                                                                                            5),
                                                                              ),
                                                                              height: 5.0.h,
                                                                              width: 22.0.w,
                                                                              child: Center(
                                                                                  child: Text(
                                                                                'Bid',
                                                                                style: TextStyle(
                                                                                    color: Colors
                                                                                        .black87,
                                                                                    fontWeight:
                                                                                        FontWeight
                                                                                            .w600),
                                                                              )),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 0.8.h,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    : InkWell(
                                                                        onTap: null,
                                                                        child: Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(
                                                                                  right: 0),
                                                                          child: Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment
                                                                                    .end,
                                                                            children: [
                                                                              Column(
                                                                                mainAxisAlignment:
                                                                                    MainAxisAlignment
                                                                                        .end,
                                                                                children: [
                                                                                  Container(
                                                                                    decoration:
                                                                                        BoxDecoration(
                                                                                      color: Colors
                                                                                              .grey[
                                                                                          500],
                                                                                      borderRadius:
                                                                                          BorderRadius
                                                                                              .circular(
                                                                                                  5),
                                                                                    ),
                                                                                    height: 5.0.h,
                                                                                    width: 22.0.w,
                                                                                    child: Center(
                                                                                        child: Text(
                                                                                      'Done',
                                                                                      style: TextStyle(
                                                                                          color: Colors
                                                                                              .white,
                                                                                          fontWeight:
                                                                                              FontWeight
                                                                                                  .w600),
                                                                                    )),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 0.8.h,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                SizedBox(
                                                                  height: 1.2.h,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 7.0.h,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            'Location',
                                                            style: TextStyle(
                                                                color: Colors.grey,
                                                                fontSize: 10.0.sp),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Text(
                                                      bookingList[index]['location_name']
                                                              .toString() ??
                                                          '',
                                                      style: TextStyle(
                                                          color: Colors.black87, fontSize: 12.0.sp),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          })
                      : Center(child: SpinKitThreeBounce(color: Theme.of(context).accentColor))),
              // Container(
              //     height: MediaQuery.of(context).size.height * 0.707,
              //     child: bookingList.length > 0
              //         ? ListView.builder(
              //             physics:
              //                 new BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              //             itemCount: bookingList.length,
              //             itemBuilder: (context, index) {
              //               return Padding(
              //                 padding: const EdgeInsets.all(8.0),
              //                 child: Container(
              //                     height: 26.0.h,
              //                     width: 90.0.w,
              //                     decoration: BoxDecoration(boxShadow: [
              //                       new BoxShadow(
              //                         color: Colors.black38,
              //                         offset: Offset(0, 3),
              //                         blurRadius: 10.0,
              //                       ),
              //                     ], color: Colors.white, borderRadius: BorderRadius.circular(6)),
              //                     child: Padding(
              //                       padding: const EdgeInsets.all(8.0),
              //                       child: Container(
              //                         color: Colors.white,
              //                         child: Row(
              //                           children: [
              //                             Flexible(
              //                                 flex: 1,
              //                                 fit: FlexFit.tight,
              //                                 child: Container(
              //                                   decoration: BoxDecoration(
              //                                     color: Colors.grey[200],
              //                                     borderRadius: BorderRadius.circular(5),
              //                                   ),
              //                                   child: ClipRRect(
              //                                     borderRadius: BorderRadius.circular(5.0),
              //                                     child: bookingList[index]['image'] == null
              //                                         ? Container(
              //                                             child: Image.asset(
              //                                                 'assets/img/no image.jpg'))
              //                                         : CachedNetworkImage(
              //                                             imageUrl: BaseUrl.voice +
              //                                                 'assets/booking_images/${bookingList[index]['id']}/${bookingList[index]['image']}',
              //                                             // fit: BoxFit.cover,
              //                                             placeholder: (context, url) =>
              //                                                 Image.asset(
              //                                               'assets/img/loading.gif',
              //                                               height:
              //                                                   MediaQuery.of(context).size.height *
              //                                                       0.2,
              //                                               width:
              //                                                   MediaQuery.of(context).size.width *
              //                                                       0.2,
              //                                               fit: BoxFit.cover,
              //                                             ),
              //                                           ),
              //                                   ),
              //                                   height: MediaQuery.of(context).size.height * 0.16,
              //                                   width: MediaQuery.of(context).size.height * 0.15,
              //                                 )),
              //                             Flexible(
              //                               flex: 1,
              //                               fit: FlexFit.tight,
              //                               child: Padding(
              //                                 padding: const EdgeInsets.all(12.0),
              //                                 child: Container(
              //                                   child: Column(
              //                                     crossAxisAlignment: CrossAxisAlignment.start,
              //                                     children: [
              //                                       Text(
              //                                         'Booking ID',
              //                                         style: TextStyle(color: Colors.grey),
              //                                       ),
              //                                       Text(
              //                                         bookingList[index]['id'].toString() ?? '',
              //                                         style: TextStyle(fontWeight: FontWeight.w600),
              //                                       ),
              //                                       SizedBox(
              //                                         height: 2.0.h,
              //                                       ),
              //                                       Text(
              //                                         'Category',
              //                                         style: TextStyle(color: Colors.grey),
              //                                       ),
              //                                       Text(
              //                                         bookingList[index]['category'].toString() ??
              //                                             '',
              //                                         style: TextStyle(fontWeight: FontWeight.w600),
              //                                       ),
              //                                       SizedBox(
              //                                         height: 1.0.h,
              //                                       ),

              //                                     ],
              //                                   ),
              //                                 ),
              //                               ),
              //                             ),
              //                             Flexible(
              //                               flex: 1,
              //                               fit: FlexFit.tight,
              //                               child: Padding(
              //                                 padding: const EdgeInsets.all(12.0),
              //                                 child: Container(
              //                                   child: Column(
              //                                     crossAxisAlignment: CrossAxisAlignment.start,
              //                                     children: [
              //                                       Text(
              //                                         'Buyer Name',
              //                                         style: TextStyle(color: Colors.grey),
              //                                       ),
              //                                       Text(
              //                                         bookingList[index]['buyer_name'].toString() ??
              //                                             '',
              //                                         overflow: TextOverflow.ellipsis,
              //                                         style: TextStyle(fontWeight: FontWeight.w600),
              //                                       ),
              //                                       SizedBox(
              //                                         height: 2.0.h,
              //                                       ),
              //                                       Text(
              //                                         'Location',
              //                                         style: TextStyle(color: Colors.grey),
              //                                       ),
              //                                       Text(
              //                                         bookingList[index]['location_name']
              //                                                 .toString() ??
              //                                             '',
              //                                         style: TextStyle(fontWeight: FontWeight.w600),
              //                                       ),
              //                                       SizedBox(
              //                                         height: 1.0.h,
              //                                       ),
              //                                       InkWell(
              //                                           onTap: () {
              //                                             Navigator.push(
              //                                                 context,
              //                                                 MaterialPageRoute(
              //                                                     builder: (context) => DeatilsPage(
              //                                                           bookingList[index]['id'],
              //                                                         )));
              //                                           },
              //                                           child: Padding(
              //                                             padding: const EdgeInsets.only(right: 28),
              //                                             child: Container(
              //                                               decoration: BoxDecoration(
              //                                                 color: Colors.black,
              //                                                 borderRadius:
              //                                                     BorderRadius.circular(5),
              //                                               ),
              //                                               height:
              //                                                   MediaQuery.of(context).size.height *
              //                                                       0.040,
              //                                               width:
              //                                                   MediaQuery.of(context).size.height *
              //                                                       0.097,
              //                                               child: Center(
              //                                                   child: Text(
              //                                                 'Details',
              //                                                 style: TextStyle(
              //                                                     color:
              //                                                         Theme.of(context).accentColor,
              //                                                     fontWeight: FontWeight.w600),
              //                                               )),
              //                                             ),
              //                                           ))
              //                                     ],
              //                                   ),
              //                                 ),
              //                               ),
              //                             ),
              //                           ],
              //                         ),
              //                       ),
              //                     )),
              //               );
              //             })
              //         : Center(
              //             child: SpinKitThreeBounce(
              //               color: Theme.of(context).accentColor,
              //             ),
              //           )),
              SizedBox(
                height: 40,
              ),
            ],
          )),
          // child: Container(
          //   child: ListView(
          //     children: [
          //       Container(
          //         height: MediaQuery.of(context).size.height * 0.787,
          //         child: bookingList.length > 0
          //             ? ListView.builder(
          //                 itemCount: bookingList.length,
          //                 itemBuilder: (BuildContext context, int index) {
          //                   String word = bookingList[index]['id'].toString();
          //                   bool isSaved = addBook.contains(word);
          //                   return Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Container(
          //                       decoration: BoxDecoration(
          //                         boxShadow: [
          //                           //background color of box
          //                           BoxShadow(
          //                             color: Colors.black12,
          //
          //                             spreadRadius: 3.0, //extend the shadow
          //                           )
          //                         ],
          //                         color: Theme.of(context).primaryColor,
          //                         borderRadius: BorderRadius.circular(15),
          //                       ),
          //                       height: MediaQuery.of(context).size.height * 0.21,
          //                       child: Row(
          //                         children: [
          //                           Flexible(
          //                             flex: 4,
          //                             fit: FlexFit.tight,
          //                             child: Container(
          //                               decoration: BoxDecoration(
          //                                 color: Theme.of(context).primaryColor,
          //                                 borderRadius: BorderRadius.only(
          //                                     topLeft: Radius.circular(10.0),
          //                                     bottomLeft: Radius.circular(10.0)),
          //                               ),
          //                               child: Column(
          //                                 mainAxisAlignment: MainAxisAlignment.center,
          //                                 children: [
          //                                   Padding(
          //                                     padding: const EdgeInsets.only(bottom: 4.0),
          //                                     child: Row(
          //                                       mainAxisAlignment: MainAxisAlignment.center,
          //                                       children: [
          //                                         Text('Booking Id:'),
          //                                         Text(
          //                                           bookingList[index]['id'].toString(),
          //                                           style: TextStyle(fontWeight: FontWeight.w600),
          //                                         ),
          //                                       ],
          //                                     ),
          //                                   ),
          //                                   Container(
          //                                     decoration: BoxDecoration(
          //                                       boxShadow: [
          //                                         //background color of box
          //                                         BoxShadow(
          //                                           color: Colors.black12,
          //
          //                                           spreadRadius: 3.0, //extend the shadow
          //                                         )
          //                                       ],
          //                                       color: Theme.of(context).primaryColor,
          //                                       borderRadius: BorderRadius.circular(15),
          //                                     ),
          //                                     // child: Text(
          //                                     //    bookingList[index]['image']),
          //                                     child: Image.network(
          //                                         'https://sparesdo.com/public/assets/booking_images/${bookingList[index]['id']}/${bookingList[index]['image']}'),
          //                                     height: MediaQuery.of(context).size.height * 0.16,
          //                                     width: MediaQuery.of(context).size.height * 0.15,
          //                                   )
          //                                 ],
          //                               ),
          //                             ),
          //                           ),
          //                           Flexible(
          //                             flex: 5,
          //                             fit: FlexFit.tight,
          //                             child: Container(
          //                               color: Theme.of(context).primaryColor,
          //                               child: Column(
          //                                 crossAxisAlignment: CrossAxisAlignment.start,
          //                                 children: [
          //                                   SizedBox(
          //                                     height: MediaQuery.of(context).size.height * 0.020,
          //                                   ),
          //                                   // Text(
          //                                   //   bookingList[index]['brand'],
          //                                   //   style: TextStyle(
          //                                   //       fontSize: 17,
          //                                   //       fontWeight: FontWeight.w600),
          //                                   // ),
          //                                   Row(
          //                                     children: [
          //                                       SizedBox(
          //                                         width: MediaQuery.of(context).size.width * 0.05,
          //                                       ),
          //                                       Text('Name: '),
          //                                       Text(
          //                                         bookingList[index]['buyer_name'].toString(),
          //                                         overflow: TextOverflow.ellipsis,
          //                                         style: TextStyle(
          //                                             fontSize: 15, fontWeight: FontWeight.w600),
          //                                       ),
          //                                     ],
          //                                   ),
          //                                   Row(
          //                                     children: [
          //                                       SizedBox(
          //                                         width: MediaQuery.of(context).size.width * 0.05,
          //                                       ),
          //                                       Text(
          //                                         bookingList[index]['brand'],
          //                                         style: TextStyle(
          //                                             fontSize: 17, fontWeight: FontWeight.w600),
          //                                       ),
          //                                     ],
          //                                   ),
          //                                   Row(
          //                                     children: [
          //                                       SizedBox(
          //                                         width: MediaQuery.of(context).size.width * 0.05,
          //                                       ),
          //                                       Text(
          //                                         bookingList[index]['model'],
          //                                         style: TextStyle(
          //                                             fontSize: 14, color: Colors.grey[600]),
          //                                       ),
          //                                     ],
          //                                   ),
          //                                   // SizedBox(
          //                                   //   height: MediaQuery.of(context)
          //                                   //           .size
          //                                   //           .height *
          //                                   //       0.020,
          //                                   // ),
          //                                   Row(
          //                                     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //                                     children: [
          //                                       Text('variant:'),
          //                                       Text(
          //                                         bookingList[index]['variant'],
          //                                         style: TextStyle(fontWeight: FontWeight.w500),
          //                                       ),
          //                                     ],
          //                                   ),
          //                                   Row(
          //                                     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //                                     children: [
          //                                       Text('year:  '),
          //                                       Text(
          //                                         bookingList[index]['year'],
          //                                         style: TextStyle(fontWeight: FontWeight.w500),
          //                                       ),
          //                                     ],
          //                                   ),
          //                                   Row(
          //                                     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //                                     children: [
          //                                       Text(' fuel:'),
          //                                       Text(
          //                                         bookingList[index]['fuel'],
          //                                         style: TextStyle(fontWeight: FontWeight.w500),
          //                                       ),
          //                                     ],
          //                                   ),
          //                                 ],
          //                               ),
          //                             ),
          //                           ),
          //                           Flexible(
          //                             flex: 3,
          //                             fit: FlexFit.tight,
          //                             child: Container(
          //                               decoration: BoxDecoration(
          //                                 color: Theme.of(context).primaryColor,
          //                                 borderRadius: BorderRadius.only(
          //                                     topRight: Radius.circular(10.0),
          //                                     bottomRight: Radius.circular(10.0)),
          //                               ),
          //                               child: Column(
          //                                 mainAxisAlignment: MainAxisAlignment.center,
          //                                 children: [
          //                                   // isSaved
          //                                   //     ? Icon(Icons.calendar_today)
          //                                   //     : Icon(Icons.add),
          //
          //                                   bookingList[index]['hide_status'] == 0
          //                                       ? InkWell(
          //                                           onTap: () {
          //                                             selectedBooking =
          //                                                 bookingList[index]['id'].toString();
          //
          //                                             _showMyDialog();
          //                                           },
          //                                           child: Container(
          //                                             decoration: BoxDecoration(
          //                                               color: Theme.of(context).accentColor,
          //                                               borderRadius: BorderRadius.circular(20),
          //                                             ),
          //                                             height: MediaQuery.of(context).size.height *
          //                                                 0.045,
          //                                             width:
          //                                                 MediaQuery.of(context).size.height * 0.12,
          //                                             child: Center(
          //                                                 child: Text(
          //                                               'Bid',
          //                                               style: TextStyle(
          //                                                   color: Colors.white,
          //                                                   fontWeight: FontWeight.w600),
          //                                             )),
          //                                           ))
          //                                       : InkWell(
          //                                           onTap: null,
          //                                           child: Container(
          //                                             decoration: BoxDecoration(
          //                                               color: Colors.grey[400],
          //                                               borderRadius: BorderRadius.circular(20),
          //                                             ),
          //                                             height: MediaQuery.of(context).size.height *
          //                                                 0.045,
          //                                             width:
          //                                                 MediaQuery.of(context).size.height * 0.12,
          //                                             child: Center(
          //                                                 child: Text(
          //                                               'Done',
          //                                               style: TextStyle(
          //                                                   color: Colors.white,
          //                                                   fontWeight: FontWeight.w600),
          //                                             )),
          //                                           )),
          //
          //                                   SizedBox(
          //                                     height: MediaQuery.of(context).size.height * 0.03,
          //                                   ),
          //                                   InkWell(
          //                                     onTap: () {
          //                                       // Navigator.push(
          //                                       //     context,
          //                                       //     MaterialPageRoute(
          //                                       //         builder: (context) =>
          //                                       //             DeatilsPage(
          //                                       //               bookingList[index]
          //                                       //               ['id'],
          //                                       //             )));
          //                                     },
          //                                     child: Container(
          //                                       decoration: BoxDecoration(
          //                                         color: Theme.of(context).accentColor,
          //                                         borderRadius: BorderRadius.circular(20),
          //                                       ),
          //                                       height: MediaQuery.of(context).size.height * 0.045,
          //                                       width: MediaQuery.of(context).size.height * 0.12,
          //                                       child: Center(
          //                                           child: Text(
          //                                         'Details',
          //                                         style: TextStyle(
          //                                             color: Colors.white,
          //                                             fontWeight: FontWeight.w600),
          //                                       )),
          //                                     ),
          //                                   ),
          //                                 ],
          //                               ),
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                   );
          //                 })
          //             : Center(
          //                 child: CircularProgressIndicator(),
          //               ),
          //       ),
          //     ],
          //   ),
          // ),
        ),
      ),
    );
  }
// void getCurrentLocation() async {
//   Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high);
//   // SharedPreferences prefs = await SharedPreferences.getInstance();
//   // await prefs.get(_currentAddress);
//
//   setState(() {
//     _currentPosition = position;
//     // print("Hi, Your location is ${_currentPosition}");
//   });
//   final coordinates = new Coordinates(position.latitude, position.longitude);
//
//   var addresses =
//   await Geocoder.local.findAddressesFromCoordinates(coordinates);
//   var first = addresses.first;
//   // print("${first.featureName} : ${first.addressLine}");
//   print("Your current address is -   ${first.addressLine}");
//
//   setState(() {
//   //   _currentAddress = "${first.featureName}, ${first.addressLine}";
//     _currentAddress = " ${first.locality}, ${first.adminArea}";
//
//   });
// }

  _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Container(
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    height: MediaQuery.of(context).size.height * 0.40,
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: Form(
                      key: _formKey,
                      child: KeyboardAvoider(
                        autoScroll: true,
                        child: ListView(
                          controller: _scrollController,
                          children: [
                            Container(
                              child: Center(
                                  child: Text(
                                'Bid',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20, color: Colors.white),
                              )),
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15), topLeft: Radius.circular(15)),
                              ),
                              height: MediaQuery.of(context).size.height * 0.08,
                            ),
                            Container(
                              height: 31.0.h,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30),
                                    child: TextFormField(
                                      keyboardType: TextInputType.phone,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                      ],
                                      validator: RequiredValidator(errorText: "Amount is required"),
                                      // obscureText: _con.hidePassword,
                                      //  onSaved: (input) => _con.user.password = input,
                                      //  validator: (input) => input.length < 6 ? S.of(context).should_be_more_than_6_letters : null,
                                      controller: _amountController,
                                      decoration: InputDecoration(
                                        counterText: '',
                                        prefixText: 'Rs.',

                                        labelText: 'Amount',

                                        labelStyle: TextStyle(color: Colors.black87),
                                        contentPadding: EdgeInsets.all(12),
                                        //  hintText: S.of(context).john_doe,
                                        hintStyle: TextStyle(
                                            color: Theme.of(context).focusColor.withOpacity(0.7)),
                                        prefixIcon: Icon(Icons.monetization_on,
                                            color: Theme.of(context).accentColor),
                                        //   border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black87)),
                                        // enabledBorder:
                                        //     OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30),
                                    child: TextFormField(
                                      controller: _rDaysController,
                                      maxLength: 10,
                                      //  initialValue: '${widget.userphone}' ?? '',
                                      keyboardType: TextInputType.phone,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                      ],
                                      validator: RequiredValidator(errorText: "Days is required"),
                                      //validator: RequiredValidator(errorText: "username is required"),
                                      // validator: (input) => input.length < 3 ? S.of(context).should_be_more_than_3_letters : null,
                                      decoration: InputDecoration(
                                        counterText: '',

                                        labelText: 'Return Days',

                                        labelStyle: TextStyle(color: Colors.black87),
                                        contentPadding: EdgeInsets.all(12),
                                        //  hintText: S.of(context).john_doe,
                                        hintStyle: TextStyle(
                                            color: Theme.of(context).focusColor.withOpacity(0.7)),
                                        prefixIcon: Icon(Icons.calendar_today,
                                            color: Theme.of(context).accentColor),
                                        //   border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black87)),
                                        // enabledBorder:
                                        //     OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 2.0.h),

                                  // Row(
                                  //   children: [
                                  //     Flexible(
                                  //       flex: 1,
                                  //       child: Padding(
                                  //         padding: const EdgeInsets.all(3.0),
                                  //         child: Container(
                                  //           height: 10.0.h,
                                  //           child: Padding(
                                  //             padding: const EdgeInsets.symmetric(
                                  //                 horizontal: 10, vertical: 0),
                                  //             child: TextFormField(
                                  //               keyboardType: TextInputType.number,
                                  //               validator: RequiredValidator(
                                  //                   errorText: "Amount is required"),
                                  //               // obscureText: _con.hidePassword,
                                  //               //  onSaved: (input) => _con.user.password = input,
                                  //               //  validator: (input) => input.length < 6 ? S.of(context).should_be_more_than_6_letters : null,
                                  //               controller: _amountController,
                                  //               decoration: InputDecoration(
                                  //                 counterText: '',
                                  //                 prefixText: 'Rs.',
                                  //
                                  //                 labelText: 'Amount',
                                  //
                                  //                 labelStyle: TextStyle(color: Colors.black87),
                                  //                 contentPadding: EdgeInsets.all(12),
                                  //                 //  hintText: S.of(context).john_doe,
                                  //                 hintStyle: TextStyle(
                                  //                     color: Theme.of(context)
                                  //                         .focusColor
                                  //                         .withOpacity(0.7)),
                                  //                 prefixIcon: Icon(Icons.monetization_on,
                                  //                     color: Theme.of(context).accentColor),
                                  //                 //   border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
                                  //                 focusedBorder: UnderlineInputBorder(
                                  //                     borderSide:
                                  //                         BorderSide(color: Colors.black87)),
                                  //                 // enabledBorder:
                                  //                 //     OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     Flexible(
                                  //       flex: 1,
                                  //       child: Padding(
                                  //         padding: const EdgeInsets.all(3.0),
                                  //         child: Container(
                                  //           height: 10.0.h,
                                  //           child: Padding(
                                  //             padding: const EdgeInsets.symmetric(
                                  //                 horizontal: 10, vertical: 0),
                                  //             child: TextFormField(
                                  //               controller: _rDaysController,
                                  //               maxLength: 10,
                                  //               //  initialValue: '${widget.userphone}' ?? '',
                                  //               keyboardType: TextInputType.number,
                                  //               validator: RequiredValidator(
                                  //                   errorText: "Days is required"),
                                  //               //validator: RequiredValidator(errorText: "username is required"),
                                  //               // validator: (input) => input.length < 3 ? S.of(context).should_be_more_than_3_letters : null,
                                  //               decoration: InputDecoration(
                                  //                 counterText: '',
                                  //
                                  //                 labelText: 'Return Days',
                                  //
                                  //                 labelStyle: TextStyle(color: Colors.black87),
                                  //                 contentPadding: EdgeInsets.all(12),
                                  //                 //  hintText: S.of(context).john_doe,
                                  //                 hintStyle: TextStyle(
                                  //                     color: Theme.of(context)
                                  //                         .focusColor
                                  //                         .withOpacity(0.7)),
                                  //                 prefixIcon: Icon(Icons.calendar_today,
                                  //                     color: Theme.of(context).accentColor),
                                  //                 //   border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
                                  //                 focusedBorder: UnderlineInputBorder(
                                  //                     borderSide:
                                  //                         BorderSide(color: Colors.black87)),
                                  //                 // enabledBorder:
                                  //                 //     OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                                  //               ),
                                  //             ),
                                  //             // child: TextFormField(
                                  //             //   keyboardType: TextInputType.number,
                                  //             //   validator: RequiredValidator(errorText: "Days is required"),
                                  //             //   // obscureText: _con.hidePassword,
                                  //             //   //  onSaved: (input) => _con.user.password = input,
                                  //             //   //  validator: (input) => input.length < 6 ? S.of(context).should_be_more_than_6_letters : null,
                                  //             //   controller: _rDaysController,
                                  //             //   decoration: InputDecoration(
                                  //             //     labelText: 'Return Days',
                                  //             //     labelStyle: TextStyle(color: Theme.of(context).accentColor),
                                  //             //     contentPadding: EdgeInsets.all(12),
                                  //             //     hintText: 'days',
                                  //             //     hintStyle: TextStyle(
                                  //             //         color: Theme.of(context).focusColor.withOpacity(0.7)),
                                  //             //     prefixIcon: Icon(Icons.calendar_today, color: Colors.grey[500]),
                                  //             //     // suffixIcon: IconButton(
                                  //             //     //   onPressed: () {
                                  //             //     //     setState(() {
                                  //             //     //       _con.hidePassword = !_con.hidePassword;
                                  //             //     //     });
                                  //             //     //   },
                                  //             //     //   color: Theme.of(context).focusColor,
                                  //             //     //   icon: Icon(_con.hidePassword ? Icons.visibility : Icons.visibility_off),
                                  //             //     // ),
                                  //             //     // border: OutlineInputBorder(
                                  //             //     //     borderSide: BorderSide(
                                  //             //     //         color: Theme.of(context).focusColor.withOpacity(0.2))),
                                  //             //     // focusedBorder: OutlineInputBorder(
                                  //             //     //     borderSide: BorderSide(
                                  //             //     //         color: Theme.of(context).accentColor.withOpacity(0.5))),
                                  //             //     // enabledBorder: OutlineInputBorder(
                                  //             //     //     borderSide: BorderSide(
                                  //             //     //         color: Theme.of(context).accentColor.withOpacity(0.2))),
                                  //             //   ),
                                  //             // ),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     )
                                  //   ],
                                  // ),
                                  SizedBox(
                                    height: 1.0.h,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RaisedButton(
                                        color: Theme.of(context).accentColor,
                                        shape: new RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.circular(5.0)),
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        onPressed: () {
                                          displd();
                                          _amountController.clear();
                                          _rDaysController.clear();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.07,
                                      ),
                                      RaisedButton(
                                        color: Colors.black,
                                        shape: new RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.circular(5.0)),
                                        child: Text(
                                          'Submit',
                                          style: TextStyle(color: Theme.of(context).accentColor),
                                        ),
                                        onPressed: () {
                                          _formKey.currentState.validate() ? BidBook() : null;

                                          print(UserId);

                                          print(selectedBooking);

                                          print(_amountController.text);
                                          print(_rDaysController.text);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            // actions: <Widget>[
            //   TextButton(
            //     child: Text(
            //       'Cancel',
            //       style: TextStyle(color: Colors.red),
            //     ),
            //     onPressed: () {
            //       displd();
            //       _amountController.clear();
            //       _rDaysController.clear();
            //       Navigator.of(context).pop();
            //     },
            //   ),
            //   TextButton(
            //     child: Text(
            //       'Confirm',
            //       style: TextStyle(color: Colors.green),
            //     ),
            //     onPressed: () {
            //       _formKey.currentState.validate() ? BidBook() : null;
            //
            //       print(UserId);
            //
            //       print(selectedBooking);
            //
            //       print(_amountController.text);
            //       print(_rDaysController.text);
            //     },
            //   ),
            // ],
          ),
        );
      },
    );
  }

  qouteAdded() {
    Fluttertoast.showToast(
        msg: "Bid Added Successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.of(context).pushReplacementNamed('/Pages', arguments: 1);
  }
}
