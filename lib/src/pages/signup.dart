import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

import '../../base_url.dart';
import '../controllers/user_controller.dart';
import '../elements/BlockButtonWidget.dart';
import '../helpers/app_config.dart' as config;
import '../helpers/helper.dart';
import 'login.dart';

class PhoneNumberValidator extends TextFieldValidator {
  PhoneNumberValidator({String errorText = 'Enter a valid phone number'}) : super(errorText);

  @override
  bool get ignoreEmptyValues => true;

  @override
  bool isValid(String value) {
    // return true if the value is valid according the your condition
    return hasMatch(r'^(?:[+0]9)?[0-9]{10}$', value);
  }
}

class SignUpWidget extends StatefulWidget {
  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends StateMVC<SignUpWidget> {
  UserController _con;

  _SignUpWidgetState() : super(UserController()) {
    _con = controller;
  }
  bool agree = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernamecontroller = TextEditingController();
  final TextEditingController _shopnamecontroller = TextEditingController();
  final TextEditingController _phonecontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _citynamecontroller = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  String location;

  String termsList, SelectedLocation, SelectedDistict, SelectedStatId, city, district, model;

  List locationList = List();
  List districtList = List();
  List cityList = List();
  Future getLocation() async {
    var response = await http.get(BaseUrl.locations);
    var jsonBody = response.body;

    var data = json.decode(jsonBody);
    setState(() {
      data = data;
      print(data);
    });

    this.locationList = data['data'];
    print('location');
    print('locoooooo' + location);
    print(this.locationList);
  }

  void getCityId(locationId) {
    location = locationId;
    print('yeeeeeeeeeeeeeeeeeeeeee' + locationId);
  }

  Future getCity(districtId) async {
    SelectedDistict = districtId;
    var response = await http
        .get(BaseUrl.city + 'location_id=' + SelectedStatId + '&' + 'district_id=' + districtId);
    var jsonBody = response.body;

    var data = json.decode(jsonBody);
    setState(() {
      data = data;
      print(data);
    });

    this.cityList = data['data'];
    print('City');
    print(this.cityList);
  }

  Future getDistrict(stateId) async {
    SelectedStatId = stateId;
    var response = await http.get(BaseUrl.district + 'location_id=' + stateId);
    var jsonBody = response.body;

    var data = json.decode(jsonBody);
    setState(() {
      data = data;
      print(data);
    });

    this.districtList = data['data'];
    print('District');
    print(this.districtList);
  }

  Future getterms() async {
    var response = await http.get(BaseUrl.terms);
    var jsonBody = response.body;

    var data = json.decode(jsonBody);
    setState(() {
      data = data;

      print(data);
    });

    this.termsList = data['data'] + data['message'];
    print('location');
    print(termsList);
    print(this.termsList);
  }

  void getYearId(yearId) {
    SelectedLocation = yearId;
    print('yeeeeeeeeeeeeeeeeeeeeee' + yearId);
  }

  Future registerFunc() async {
    EasyLoading.show(
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.black,
        status: 'loading...',
        indicator: SpinKitThreeBounce(
          color: Theme.of(context).accentColor,
        ));
    var response = await http.post(BaseUrl.register +
        'name=' +
        _usernamecontroller.text +
        '&' +
        'shopname=' +
        _shopnamecontroller.text +
        '&' +
        'phone=' +
        _phonecontroller.text +
        '&' +
        'email=' +
        _emailcontroller.text +
        '&' +
        'city=' +
        SelectedStatId +
        '&' +
        'password=' +
        'sparedo@123' +
        '&' +
        'state=' +
        location +
        '&' +
        'district=' +
        SelectedDistict);
    json.decode(response.body);

    setState(() {
      print(response);
      print(response);
    });
    print('statusCode : ' + response.statusCode.toString());

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          backgroundColor: Colors.white,
          text: "Thank you for Registering Admin will contact you soon",
          onConfirmBtnTap: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginWidget()));
          });

      print('response body : ${response.body}');
      try {
        json.decode(response.body);
        print('trying to decode  Respose Body result is : success');
      } catch (Ex) {
        print("Exepition with json decode : $Ex");
      }
    }
    if (response.statusCode == 401) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: "User Already Exist",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

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

  void getLocationId(locationId) {
    location = locationId;
    print(locationId);
  }

  @override
  void initState() {
    getLocation();
    getterms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper.of(context).onWillPop,
      child: Scaffold(
        key: _con.scaffoldKey,
        resizeToAvoidBottomPadding: false,
        body: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Positioned(
              top: 0,
              child: Container(
                width: config.App(context).appWidth(100),
                height: config.App(context).appHeight(35.5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(70.0.sp)),
                    color: Colors.black),
              ),
            ),
            Positioned(
              top: config.App(context).appHeight(19) - 120,
              child: Container(
                  width: config.App(context).appWidth(64),
                  height: config.App(context).appHeight(37),
                  child: Column(
                    children: [
                      Image.asset('assets/img/2.png', height: 100, width: 150),
                    ],
                  )),
            ),
            Positioned(
              top: config.App(context).appHeight(30.0) - 120,
              child: Container(
                width: config.App(context).appWidth(84),
                height: config.App(context).appHeight(29.5),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    leading: IconButton(
                        onPressed: () {
                          // Navigator.pushReplacement(
                          //     context,
                          //     PageTransition(
                          //         duration: Duration(milliseconds: 400),
                          //         type: PageTransitionType.leftToRightWithFade,
                          //         child: LoginWidget()));
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        )),
                    title: Text(
                      '      Registration',
                      style: Theme.of(context)
                          .textTheme
                          .headline2
                          .merge(TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: config.App(context).appHeight(29.5) - 50,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 50,
                        color: Theme.of(context).hintColor.withOpacity(0.2),
                      )
                    ]),
                margin: EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 27),
                width: config.App(context).appWidth(88),
//              height: config.App(context).appHeight(55),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: config.App(context).appWidth(85),
                        height: config.App(context).appHeight(70.5),
                        child: KeyboardAvoider(
                          autoScroll: true,
                          child: ListView(
                            controller: _scrollController,
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.text,
                                controller: _usernamecontroller,
                                validator: RequiredValidator(errorText: "username is required"),
                                // validator: (input) => input.length < 3 ? S.of(context).should_be_more_than_3_letters : null,
                                decoration: InputDecoration(
                                  labelText: 'Full Name',
                                  labelStyle: TextStyle(color: Colors.black87),
                                  contentPadding: EdgeInsets.all(12),
                                  hintText: 'Enter Your Name',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  prefixIcon:
                                      Icon(Icons.person, color: Theme.of(context).accentColor),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black87)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black87)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black87)),
                                ),
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                controller: _shopnamecontroller,
                                keyboardType: TextInputType.text,
                                validator: RequiredValidator(errorText: "shopname is required"),
                                decoration: InputDecoration(
                                  labelText: 'Shop Name',
                                  hintText: 'Enter Your Shop Name',
                                  labelStyle: TextStyle(color: Colors.black87),
                                  contentPadding: EdgeInsets.all(12),
                                  hintStyle: TextStyle(
                                      color: Theme.of(context).focusColor.withOpacity(0.7)),
                                  prefixIcon: Icon(Icons.shopping_bag_rounded,
                                      color: Theme.of(context).accentColor),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black87)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black87)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black87)),
                                ),
                              ),
                              SizedBox(height: 20),

                              //   decoration: BoxDecoration(
                              //     border: Border.all(
                              //         color: Theme.of(context).accentColor,
                              //         width: 0.8),
                              //   ),
                              //   selectedColor: Theme.of(context).accentColor,
                              //   key: _multiSelectKey,
                              //   initialChildSize: 0.7,
                              //   maxChildSize: 0.95,
                              //   title: Text("Select City"),
                              //   buttonText: Text("Select City"),
                              //   items: _items,
                              //   initialValue: [],
                              //   searchable: true,
                              //   validator: (values) {
                              //     if (values == null || values.isEmpty) {
                              //       return "Required";
                              //     }
                              //     List<String> names =
                              //         values.map((e) => e.name).toList();
                              //     if (names.contains("Frog")) {
                              //       return "Frogs are weird!";
                              //     }
                              //     return null;
                              //   },
                              //   onConfirm: (values) {
                              //     setState(() {
                              //       //  List _selectedAnimals3;
                              //       _selectedAnimals3 = values;
                              //       print(_selectedAnimals3[0].name);
                              //     });
                              //     _multiSelectKey.currentState.validate();
                              //   },
                              //   chipDisplay: MultiSelectChipDisplay(
                              //     onTap: (item) {
                              //       setState(() {
                              //         _selectedAnimals3.remove(item);
                              //       });
                              //       _multiSelectKey.currentState.validate();
                              //     },
                              //   ),
                              // ),
                              TextFormField(
                                controller: _phonecontroller,
                                maxLength: 10,
                                keyboardType: TextInputType.phone,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                ], // Only numbers can be entered // Only numbers can be entered
                                validator: MultiValidator([
                                  RequiredValidator(errorText: "Phone Number is required"),
                                  PhoneNumberValidator()
                                ]),
                                decoration: InputDecoration(
                                  counterText: '',
                                  prefixText: '+91 ',
                                  labelText: 'Phone',
                                  labelStyle: TextStyle(color: Colors.black87),
                                  contentPadding: EdgeInsets.only(left: 20),
                                  hintText: '',
                                  hintStyle: TextStyle(
                                      color: Theme.of(context).focusColor.withOpacity(0.7)),
                                  prefixIcon:
                                      Icon(Icons.call, color: Theme.of(context).accentColor),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black87)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black87)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black87)),
                                ),
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                controller: _emailcontroller,
                                keyboardType: TextInputType.emailAddress,
                                validator: MultiValidator([
                                  RequiredValidator(errorText: "Email is required"),
                                  EmailValidator(errorText: "Enter a valid email")
                                ]),
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(color: Colors.black87),
                                  contentPadding: EdgeInsets.all(12),
                                  hintText: 'Enter Your Email',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  prefixIcon:
                                      Icon(Icons.mail, color: Theme.of(context).accentColor),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black87)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black87)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black87)),
                                ),
                              ),
                              SizedBox(height: 20),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0.w),
                                child: DropdownButtonFormField(
                                  validator: (value) => value == null ? 'field required' : null,
                                  //   validator: RequiredValidator(errorText: "Choose Model"),
                                  decoration: new InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black87, width: 1.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black87, width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black87, width: 1.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black87, width: 1.0),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black87, width: 1.0),
                                    ),
                                    contentPadding:
                                        EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                  ),
                                  value: model,

                                  hint: Text(
                                    'Select State',
                                    style: TextStyle(fontSize: 11.0.sp),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  items: locationList.map((list2) {
                                    return DropdownMenuItem(
                                      child: Text(list2['name'].toString()),
                                      value: list2['id'].toString(),
                                    );
                                  })?.toList(),
                                  onChanged: (value3) {
                                    setState(() {
                                      //  getVariant(value3);
                                      getDistrict(value3);
                                    });
                                  },
                                ),
                              ),
                              SizedBox(height: 2.5.h),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0.w),
                                child: DropdownButtonFormField(
                                  validator: (value) => value == null ? 'field required' : null,
                                  //   validator: RequiredValidator(errorText: "Choose Model"),
                                  decoration: new InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black87, width: 1.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black87, width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black87, width: 1.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black87, width: 1.0),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black87, width: 1.0),
                                    ),
                                    contentPadding:
                                        EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                  ),
                                  value: district,

                                  hint: Text(
                                    'Select District',
                                    style: TextStyle(fontSize: 11.0.sp),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  items: districtList.map((list2) {
                                    return DropdownMenuItem(
                                      child: Text(list2['name'].toString()),
                                      value: list2['id'].toString(),
                                    );
                                  })?.toList(),
                                  onChanged: (value3) {
                                    setState(() {
                                      //  getVariant(value3);
                                      getCity(value3);
                                    });
                                  },
                                ),
                              ),
                              SizedBox(height: 2.5.h),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0.w),
                                child: DropdownButtonFormField(
                                  validator: (value) => value == null ? 'field required' : null,
                                  //   validator: RequiredValidator(errorText: "Choose Model"),
                                  decoration: new InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black87, width: 1.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black87, width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black87, width: 1.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black87, width: 1.0),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black87, width: 1.0),
                                    ),
                                    contentPadding:
                                        EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                  ),
                                  value: city,

                                  hint: Text(
                                    'Select City',
                                    style: TextStyle(fontSize: 11.0.sp),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  items: cityList.map((list2) {
                                    return DropdownMenuItem(
                                      child: Text(list2['city'].toString()),
                                      value: list2['id'].toString(),
                                    );
                                  })?.toList(),
                                  onChanged: (value3) {
                                    setState(() {
                                      getCityId(value3);
                                    });
                                  },
                                ),
                              ),

                              // Theme(
                              //   data: Theme.of(context).copyWith(brightness: Brightness.dark),
                              //   child: DropdownSearch<UserModel>(
                              //     validator: (value) =>
                              //         value == null ? 'Location is required' : null,
                              //     searchBoxDecoration: InputDecoration(
                              //         prefixIcon:
                              //             Icon(Icons.search, color: Theme.of(context).accentColor),
                              //         border: OutlineInputBorder(
                              //             borderRadius: new BorderRadius.circular(5.0),
                              //             borderSide: BorderSide(color: Colors.pinkAccent)),
                              //         focusedBorder: OutlineInputBorder(),
                              //         contentPadding: EdgeInsets.all(12),
                              //         labelText: "Search location",
                              //         labelStyle: TextStyle(color: Colors.black87)),
                              //     showSearchBox: true,
                              //     mode: Mode.BOTTOM_SHEET,
                              //     dropdownSearchDecoration: InputDecoration(
                              //       hintText: 'Select Location',
                              //       hintStyle: TextStyle(color: Colors.black87),
                              //       border: OutlineInputBorder(
                              //           borderSide: BorderSide(color: Colors.black87)),
                              //       isDense: true,
                              //       // border: OutlineInputBorder(
                              //       //     borderSide: BorderSide(color: Colors.black87)),
                              //       disabledBorder: OutlineInputBorder(
                              //           borderSide: BorderSide(color: Colors.black87)),
                              //       focusedBorder: OutlineInputBorder(
                              //           borderSide: BorderSide(color: Colors.black87)),
                              //       enabledBorder: OutlineInputBorder(
                              //           borderSide: BorderSide(color: Colors.black87)),
                              //
                              //       contentPadding: EdgeInsets.all(12),
                              //       prefixIcon: Icon(Icons.location_on,
                              //           size: 25, color: Theme.of(context).accentColor),
                              //     ),
                              //     onFind: (String filter) async {
                              //       var response = await Dio().get(
                              //         BaseUrl.locations,
                              //         queryParameters: {"filter": filter},
                              //       );
                              //
                              //       var models = UserModel.fromJsonList(response.data['data']);
                              //
                              //       return models;
                              //     },
                              //     onChanged: (UserModel data) {
                              //       setState(() {
                              //         getYearId(data.id);
                              //       });
                              //       print(data.id);
                              //     },
                              //     popupTitle: Container(
                              //       height: 50,
                              //       decoration: BoxDecoration(
                              //         color: Theme.of(context).accentColor,
                              //         borderRadius: BorderRadius.only(
                              //           topLeft: Radius.circular(20),
                              //           topRight: Radius.circular(20),
                              //         ),
                              //       ),
                              //       child: Center(
                              //         child: Text(
                              //           'Location',
                              //           style: TextStyle(
                              //             fontSize: 24,
                              //             fontWeight: FontWeight.bold,
                              //             color: Colors.white,
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //     popupShape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.only(
                              //         topLeft: Radius.circular(24),
                              //         topRight: Radius.circular(24),
                              //       ),
                              //     ),
                              //   ),
                              // ),

                              SizedBox(
                                height: 2.0.h,
                              ),

                              Row(
                                children: [
                                  Checkbox(
                                    value: agree,
                                    onChanged: (value) {
                                      setState(() {
                                        agree = value;
                                      });
                                    },
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      _showMyDialog();
                                    },
                                    child: Text(
                                      'Accept Terms & Conditions',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 11.0.sp, color: Colors.black87),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              BlockButtonWidget(
                                text: Text(
                                  'Register',
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.7),
                                ),
                                color: Theme.of(context).accentColor,
                                onPressed: () {
                                  _formKey.currentState.validate()
                                      ? agree
                                          ? registerFunc()
                                          : Fluttertoast.showToast(
                                              msg: "You should read Terms & Conditions",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.TOP,
                                              backgroundColor: Colors.red[400],
                                              textColor: Colors.white,
                                              fontSize: 16.0,
                                            )
                                      : null;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              FlatButton(
                                child: Text(
                                  'Back to Login',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10.0.sp,
                                      color: Colors.black87),
                                ),
                                onPressed: () {
                                  // print(_usernamecontroller.text);
                                  // print(_phonecontroller.text);
                                  // print(_shopnamecontroller.text);
                                  // print(SelectedLocation);
                                  // print(SelectedStatId);
                                  // print(SelectedDistict);
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          duration: Duration(milliseconds: 400),
                                          type: PageTransitionType.leftToRightWithFade,
                                          child: LoginWidget()));
                                },
                              )
                            ],
                          ),
                        ),
                      ),

//                      FlatButton(
//                        onPressed: () {
//                          Navigator.of(context).pushNamed('/MobileVerification');
//                        },
//                        padding: EdgeInsets.symmetric(vertical: 14),
//                        color: Theme.of(context).accentColor.withOpacity(0.1),
//                        shape: StadiumBorder(),
//                        child: Text(
//                          'Register with Google',
//                          textAlign: TextAlign.start,
//                          style: TextStyle(
//                            color: Theme.of(context).accentColor,
//                          ),
//                        ),
//                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Positioned(
            //   bottom: 2.0.h,
            //   child: FlatButton(
            //     onPressed: () {
            //       Navigator.pushReplacement(
            //           context,
            //           PageTransition(
            //               duration: Duration(milliseconds: 400),
            //               type: PageTransitionType.leftToRightWithFade,
            //               child: LoginWidget()));
            //     },
            //     textColor: Theme.of(context).accentColor,
            //     child: Text('Back to Login',
            //         style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Terms & Conditions'),
          content: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: ListView(
                children: <Widget>[
                  termsList == null
                      ? Padding(
                          padding: const EdgeInsets.only(left: 50, right: 50),
                          child: Container(
                              height: 5.0.h,
                              width: 5.0.w,
                              child: SpinKitThreeBounce(
                                color: Theme.of(context).accentColor,
                              )),
                        )
                      : Html(data: termsList)
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Accept',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                setState(() {
                  agree = true;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
