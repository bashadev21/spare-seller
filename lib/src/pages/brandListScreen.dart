import 'dart:convert';

import 'package:animated_widgets/widgets/translation_animated.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sparedo_partner/base_url.dart';
import 'package:sparedo_partner/src/pages/BookingForm.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/category.dart';
import 'login.dart';

class BrandList extends StatefulWidget {
  @override
  _BrandListState createState() => _BrandListState();
}

Category category;
double marginLeft;

class _BrandListState extends State<BrandList> {
  List brandsList = List();
  String UserId;
  final LocalStorage storage = new LocalStorage("");
  // Future getBrands() async {
  //   final LocalStorage storage = new LocalStorage("");
  //   var selected_category = storage.getItem('category_id');
  //   // var selected_brand=storage.setItem('brand_id', brandsList[index]['name']);
  //   // categoryName=storage.getItem('category_name');
  //
  //   var response =
  //       await http.get(BaseUrl.brands + 'category_id=' + selected_category);
  //   var jsonBody = response.body;
  //   var data = json.decode(jsonBody);
  //   setState(() {
  //     data = data;
  //   });
  //
  //   this.brandsList = data['data'];
  //   print('branddddddddddddddddList');
  //   print(this.brandsList);
  // }

  @override
  void initState() {
 //   getBrands();
    LoginCheck();
//    _clearvalue();
    super.initState();
  }

  Future refresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
     // getBrands();
    });
  }

  int Loginchk;
  Future LoginCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.get('user_id'));
    print(prefs.get('user_password'));
    final userId = (prefs.get('user_id'));

    UserId = userId;
    var response = await http.get(BaseUrl.logCheck +
        'user_id=' +
        UserId +
        '&' +
        'password=' +
        prefs.get('user_password'));
    json.decode(response.body);
    var jsonBody = response.body;
    var data = json.decode(jsonBody);
    setState(() {
      data = data;
      print(data);
    });
    this.Loginchk = data['data'];
    if (this.Loginchk == 1) {
      print('Logdd in');
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('user_id');
      prefs.remove('user_password');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginWidget()));
    }

    print('listttttda');
    print(this.Loginchk);

    print('statusCodew : ' + response.statusCode.toString());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          primary: false,
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).primaryColor,
            ),
          ),
          title: Text(
            'Chooose Brand',
            style: Theme.of(context).textTheme.headline6.merge(TextStyle(
                letterSpacing: 1.3, color: Theme.of(context).primaryColor)),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: refresh,
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: [0.1, 0.9],
                      colors: [
                        Colors.white,
                        Colors.white,
                      ],
                    ),
                  ),
                  height: MediaQuery.of(context).size.height * 0.875,
                  child: brandsList.length > 0
                      ? GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemCount: brandsList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: InkWell(
                                onTap: () {
                                  var selected_category = storage.setItem(
                                      'brand_id',
                                      brandsList[index]['id'].toString());

                                  // print(brnad);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BookingForm()));
                                },
                                child: TranslationAnimatedWidget.tween(
                                  duration: Duration(milliseconds: 150),
                                  translationDisabled: Offset(0, 400),
                                  translationEnabled: Offset(0, 0),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    // child: Card(
                                    //   color: Colors.grey[300],
                                    //   elevation: 10,
                                    //   shadowColor: Colors.grey[50],
                                    //   child: Column(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.center,
                                    //     children: [
                                    //       CachedNetworkImage(
                                    //         imageUrl:
                                    //             '${BaseUrl.brandImage}${brandsList[index]['image']}',
                                    //         placeholder: (context, url) =>
                                    //             Image.asset(
                                    //           'assets/img/loading.gif',
                                    //           height: MediaQuery.of(context)
                                    //                   .size
                                    //                   .height *
                                    //               0.2,
                                    //           width: MediaQuery.of(context)
                                    //                   .size
                                    //                   .width *
                                    //               0.2,
                                    //           fit: BoxFit.cover,
                                    //         ),
                                    //       ),
                                    //       Text(
                                    //         brandsList[index]['name']
                                    //                 .toUpperCase() ??
                                    //             '',
                                    //         style: TextStyle(fontSize: 15),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                  ),
                                ),
                              ),
                            );
                            // return ListTile(
                            //   title: Text(brandsList[index]['name']),
                            //   leading: Image.network('http://192.168.1.147:8080/sparedo_partner/public/assets/brand/${brandsList[index]['image']}'),
                            // );
                          })
                      : Center(
                          child: CircularProgressIndicator(),
                        ))
            ],
          ),
        ),
      ),
    );
  }
}
