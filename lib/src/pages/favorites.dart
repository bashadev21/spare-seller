import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sparedo_partner/base_url.dart';
import 'package:sparedo_partner/src/elements/CustomAppbar.dart';
import 'package:sparedo_partner/src/elements/DrawerWidget.dart';

import 'bankdetails.dart';
import 'profiletab.dart';

class Brands {
  String name;
  int id;

  Brands({this.name, this.id});

  Brands.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    return data;
  }
}

TabController _tabController;

class ProFileScreen extends StatefulWidget {
  @override
  _ProFileScreenState createState() => _ProFileScreenState();
}

Map<String, bool> values = {
  'Sunday': false,
  'Monday': false,
  'Tuesday': false,
  'Wednesday': false,
  'Thursday': false,
  'Friday': false,
};

var tmpArray = [];

getCheckboxItems() {
  values.forEach((key, value) {
    if (value == true) {
      tmpArray.add(key);
    }
  });

  // Printing all selected items on Terminal screen.
  print(tmpArray);
  // Here you will get all your selected Checkbox items.

  // Clear array after use.
  tmpArray.clear();
}

class _ProFileScreenState extends State<ProFileScreen> with SingleTickerProviderStateMixin {
  DateTime selectedTime = DateTime.now();
  TimeOfDay _time = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay _time1 = TimeOfDay(hour: 00, minute: 00);
  void _selectTime() async {
    final TimeOfDay newTime = await showTimePicker(
      confirmText: 'Ok',
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: _time,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.grey,
            accentColor: Theme.of(context).accentColor,
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).accentColor,
            ),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }
  }

  void _selectTime1() async {
    final TimeOfDay newTime = await showTimePicker(
      confirmText: 'Ok',
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: _time1,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.grey,
            accentColor: Theme.of(context).accentColor,
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).accentColor,
            ),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );
    if (newTime != null) {
      setState(() {
        _time1 = newTime;
      });
    }
  }

  final myController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // @override
  // void dispose() {
  //   // Clean up the controller when the widget is removed from the
  //   // widget tree.
  //   //  myController.dispose();
  //   super.dispose();
  // }
  List CategoryList = List();
  Future getCategory() async {
    var response = await http.get(BaseUrl.category);
    var jsonBody = response.body;

    var data = json.decode(jsonBody);
    setState(() {
      data = data;
      print(data);
    });

    this.CategoryList = data['data'];
    print('Category');

    print(this.CategoryList);
  }

  @override
  void initState() {
    getCategory();
    getCategoryId([1]);
    _tabController = new TabController(length: 2, vsync: this);

    super.initState();
  }

  List brandsList = List();
  var concatenate = StringBuffer();
  bool valuefirst = false;
  var userStatus = List<bool>();
  Future getCategoryId(List value3) async {
    // displays 'onetwothree'

    var response = await http.get(BaseUrl.brands + 'category=' + value3[0].toString());
    var jsonBody = response.body;
    print(value3[0]);

    var data = json.decode(jsonBody);

    setState(() {
      data = data;
      print(data);
    });

    this.brandsList = data['data'];
    print('brandsList');
    userStatus.add(false);

    print(this.brandsList);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: BaseAppBar(
            title: Text('title'),
            appBar: AppBar(),
            // widgets: <Widget>[Icon(Icons.more_vert)],
          ),
          drawer: DrawerWidget(),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(
                      25.0,
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    // give the indicator a decoration (color and border radius)
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        25.0,
                      ),
                      color: Theme.of(context).accentColor,
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    tabs: [
                      // first tab [you can add an icon using the icon property]
                      Tab(
                        text: 'Profile',
                      ),

                      // second tab [you can add an icon using the icon property]
                      Tab(
                        text: 'Bank Details',
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [Container(child: ProfileTab()), BankDetails()],
                  controller: _tabController,
                ),
              ),
            ],
          ),
          // body: Form(
          //   key: _formKey,
          //   child: CategoryList.length > 0
          //       ? SingleChildScrollView(
          //           child: Padding(
          //             padding: EdgeInsets.symmetric(horizontal: 6.0.w),
          //             child: Column(
          //               children: [
          //                 Container(
          //                   height: 7.0.h,
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     children: [
          //                       Text(
          //                         'Profile',
          //                         style: TextStyle(fontSize: 15.0.sp, fontWeight: FontWeight.w600),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //                 FormBuilderFilterChip(
          //                   validator: (text) {
          //                     if (text == null || text.isEmpty) {
          //                       return 'field required';
          //                     }
          //                     return null;
          //                   },
          //                   showCheckmark: false,
          //                   selectedColor: Theme.of(context).accentColor,
          //                   name: 'filter_chip',
          //                   onChanged: (value3) {
          //                     setState(() {
          //                       print(value3);
          //
          //                       getCategoryId(value3);
          //                     });
          //                   },
          //                   decoration: InputDecoration(
          //                     labelText: 'Deal With',
          //                     // labelText: 'Deal With',
          //                     contentPadding: EdgeInsets.all(8),
          //                     labelStyle: TextStyle(color: Colors.black87, fontSize: 15.0.sp),
          //                     border: OutlineInputBorder(
          //                         borderSide: BorderSide(color: Theme.of(context).focusColor)),
          //                   ),
          //                   spacing: 5.0.sp,
          //                   options: [
          //                     FormBuilderFieldOption(
          //                         value: CategoryList[0]['id'],
          //                         child: Padding(
          //                           padding: const EdgeInsets.all(4.0),
          //                           child: Text('Car'),
          //                         )),
          //                     FormBuilderFieldOption(
          //                         value: CategoryList[1]['id'],
          //                         child: Padding(
          //                           padding: const EdgeInsets.all(4.0),
          //                           child: Text('Bike'),
          //                         )),
          //                   ],
          //                 ),
          //                 SizedBox(
          //                   height: 3.0.h,
          //                 ),
          //                 brandsList.length == null ||
          //                         userStatus.length == null ||
          //                         brandsList.length & userStatus.length == null
          //                     ? Container()
          //                     : Container(
          //                         height: 46.0.h,
          //                         child: ListView.builder(
          //                             itemCount: brandsList.length & userStatus.length,
          //                             itemBuilder: (context, index) {
          //                               return SingleChildScrollView(
          //                                 child: Column(
          //                                   children: [
          //                                     CheckboxListTile(
          //                                       title: Text('${brandsList[index]['name']}'),
          //                                       subtitle: Text('${brandsList[index]['id']}'),
          //
          //                                       // tristate: false,//
          //                                       value: userStatus[index],
          //                                       controlAffinity: ListTileControlAffinity.leading,
          //                                       activeColor: Theme.of(context).accentColor,
          //                                       checkColor: Colors.white,
          //                                       onChanged: (bool value) {
          //                                         setState(() {
          //                                           !userStatus[index] == true
          //                                               ? tmpArray.add(brandsList[index]['id'])
          //                                               : null;
          //
          //                                           print(brandsList[index]['id']);
          //                                           userStatus[index] = !userStatus[index];
          //                                         });
          //                                       },
          //                                     )
          //                                   ],
          //                                 ),
          //                               );
          //                             }),
          //                       ),
          //                 SizedBox(
          //                   height: 3.0.h,
          //                 ),
          //                 TextFormField(
          //                   controller: myController,
          //                   //   inputFormatters: [Te],
          //                   cursorColor: Theme.of(context).accentColor,
          //
          //                   //  maxLength: 10,
          //                   keyboardType: TextInputType.name,
          //
          //                   validator: MultiValidator([
          //                     RequiredValidator(errorText: "Name is required"),
          //                     // PhoneNumberValidator()
          //                   ]),
          //                   decoration: InputDecoration(
          //                     counterText: '',
          //                     // prefixText: '+91 ',
          //                     labelText: 'Name',
          //                     labelStyle: TextStyle(color: Colors.black87),
          //                     contentPadding: EdgeInsets.only(left: 20),
          //                     hintText: '',
          //                     hintStyle: TextStyle(color: Theme.of(context).focusColor),
          //                     prefixIcon: Icon(Icons.person, color: Theme.of(context).accentColor),
          //                     border: OutlineInputBorder(
          //                         borderSide: BorderSide(color: Theme.of(context).focusColor)),
          //                     focusedBorder:
          //                         OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
          //                     enabledBorder:
          //                         OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          //                   ),
          //                 ),
          //
          //                 SizedBox(
          //                   height: 3.0.h,
          //                 ),
          //                 TextFormField(
          //                   //   inputFormatters: [Te],
          //                   cursorColor: Theme.of(context).accentColor,
          //
          //                   //  maxLength: 10,
          //                   keyboardType: TextInputType.name,
          //
          //                   validator: MultiValidator([
          //                     RequiredValidator(errorText: "Location is required"),
          //                     // PhoneNumberValidator()
          //                   ]),
          //                   decoration: InputDecoration(
          //                     counterText: '',
          //                     // prefixText: '+91 ',
          //                     labelText: 'Location',
          //                     labelStyle: TextStyle(color: Colors.black87),
          //                     contentPadding: EdgeInsets.only(left: 20),
          //                     hintText: '',
          //                     hintStyle: TextStyle(color: Theme.of(context).focusColor),
          //                     prefixIcon: Icon(Icons.location_on_rounded,
          //                         color: Theme.of(context).accentColor),
          //                     border: OutlineInputBorder(
          //                         borderSide: BorderSide(color: Theme.of(context).focusColor)),
          //                     focusedBorder:
          //                         OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
          //                     enabledBorder:
          //                         OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          //                   ),
          //                 ),
          //
          //                 SizedBox(
          //                   height: 3.0.h,
          //                 ),
          //                 TextFormField(
          //                   //   inputFormatters: [Te],
          //                   cursorColor: Theme.of(context).accentColor,
          //
          //                   //  maxLength: 10,
          //                   keyboardType: TextInputType.name,
          //
          //                   validator: MultiValidator([
          //                     RequiredValidator(errorText: "Shop Name is required"),
          //                     // PhoneNumberValidator()
          //                   ]),
          //                   decoration: InputDecoration(
          //                     counterText: '',
          //                     // prefixText: '+91 ',
          //                     labelText: 'Shop Name',
          //                     labelStyle: TextStyle(color: Colors.black87),
          //                     contentPadding: EdgeInsets.only(left: 20),
          //                     hintText: '',
          //                     hintStyle: TextStyle(color: Theme.of(context).focusColor),
          //                     prefixIcon:
          //                         Icon(Icons.shopping_bag, color: Theme.of(context).accentColor),
          //                     border: OutlineInputBorder(
          //                         borderSide: BorderSide(color: Theme.of(context).focusColor)),
          //                     focusedBorder:
          //                         OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
          //                     enabledBorder:
          //                         OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          //                   ),
          //                 ),
          //
          //                 SizedBox(
          //                   height: 3.0.h,
          //                 ),
          //                 TextFormField(
          //                   //   inputFormatters: [Te],
          //                   cursorColor: Theme.of(context).accentColor,
          //
          //                   maxLength: 10,
          //
          //                   validator: MultiValidator([
          //                     RequiredValidator(errorText: "Number is required"),
          //                     PhoneNumberValidator()
          //                   ]),
          //                   keyboardType: TextInputType.phone,
          //                   inputFormatters: <TextInputFormatter>[
          //                     FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          //                   ],
          //                   decoration: InputDecoration(
          //                     counterText: '',
          //                     prefixText: '+91 ',
          //                     labelText: 'Contact Number',
          //                     labelStyle: TextStyle(color: Colors.black87),
          //                     contentPadding: EdgeInsets.only(left: 20),
          //                     hintText: '',
          //                     hintStyle: TextStyle(color: Theme.of(context).focusColor),
          //                     prefixIcon: Icon(Icons.phone, color: Theme.of(context).accentColor),
          //                     border: OutlineInputBorder(
          //                         borderSide: BorderSide(color: Theme.of(context).focusColor)),
          //                     focusedBorder:
          //                         OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
          //                     enabledBorder:
          //                         OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          //                   ),
          //                 ),
          //
          //                 SizedBox(
          //                   height: 3.0.h,
          //                 ),
          //                 TextFormField(
          //                   //   inputFormatters: [Te],
          //                   cursorColor: Theme.of(context).accentColor,
          //
          //                   maxLength: 10,
          //                   keyboardType: TextInputType.phone,
          //                   inputFormatters: <TextInputFormatter>[
          //                     FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          //                   ],
          //
          //                   validator: MultiValidator([
          //                     RequiredValidator(errorText: "Number is required"),
          //                     PhoneNumberValidator()
          //                   ]),
          //                   decoration: InputDecoration(
          //                     counterText: '',
          //                     prefixText: '+91 ',
          //                     labelText: 'Alternate Number',
          //                     labelStyle: TextStyle(color: Colors.black87),
          //                     contentPadding: EdgeInsets.only(left: 20),
          //                     hintText: '',
          //                     hintStyle: TextStyle(color: Theme.of(context).focusColor),
          //                     prefixIcon: Icon(Icons.phone, color: Theme.of(context).accentColor),
          //                     border: OutlineInputBorder(
          //                         borderSide: BorderSide(color: Theme.of(context).focusColor)),
          //                     focusedBorder:
          //                         OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
          //                     enabledBorder:
          //                         OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          //                   ),
          //                 ),
          //
          //                 SizedBox(
          //                   height: 3.0.h,
          //                 ),
          //                 TextFormField(
          //                   //   inputFormatters: [Te],
          //                   cursorColor: Theme.of(context).accentColor,
          //
          //                   // maxLength: 10,
          //                   keyboardType: TextInputType.phone,
          //                   inputFormatters: <TextInputFormatter>[
          //                     FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          //                   ],
          //
          //                   validator: MultiValidator([
          //                     RequiredValidator(errorText: "Number is required"),
          //                     // PhoneNumberValidator()
          //                   ]),
          //                   decoration: InputDecoration(
          //                     counterText: '',
          //                     prefixText: '044 ',
          //                     labelText: 'Landline Number',
          //                     labelStyle: TextStyle(color: Colors.black87),
          //                     contentPadding: EdgeInsets.only(left: 20),
          //                     hintText: '',
          //                     hintStyle: TextStyle(color: Theme.of(context).focusColor),
          //                     prefixIcon: Icon(Icons.contact_phone_rounded,
          //                         color: Theme.of(context).accentColor),
          //                     border: OutlineInputBorder(
          //                         borderSide: BorderSide(color: Theme.of(context).focusColor)),
          //                     focusedBorder:
          //                         OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
          //                     enabledBorder:
          //                         OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          //                   ),
          //                 ),
          //
          //                 SizedBox(
          //                   height: 3.0.h,
          //                 ),
          //                 new TextFormField(
          //                   validator: MultiValidator([
          //                     RequiredValidator(errorText: "Address  is required"),
          //                     // PhoneNumberValidator()
          //                   ]),
          //                   maxLines: 3,
          //                   decoration: new InputDecoration(
          //                     labelText: 'Address',
          //                     border: OutlineInputBorder(
          //                         borderSide: BorderSide(color: Theme.of(context).focusColor)),
          //                     focusedBorder:
          //                         OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
          //                     enabledBorder:
          //                         OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          //                   ),
          //                 ),
          //
          //                 SizedBox(
          //                   height: 3.0.h,
          //                 ),
          //                 // Container(
          //                 //   height: 8.0.h,
          //                 //   child: Row(
          //                 //     children: [
          //                 //       Flexible(
          //                 //         flex: 1,
          //                 //         fit: FlexFit.tight,
          //                 //         child: Padding(
          //                 //           padding: const EdgeInsets.symmetric(horizontal: 5),
          //                 //           child: Container(
          //                 //             child: TextFormField(
          //                 //               decoration: InputDecoration(
          //                 //                 prefixIcon: Icon(Icons.phone),
          //                 //                 labelText: 'Contact Number',
          //                 //               ),
          //                 //             ),
          //                 //           ),
          //                 //         ),
          //                 //       ),
          //                 //       Flexible(
          //                 //         flex: 1,
          //                 //         fit: FlexFit.tight,
          //                 //         child: Padding(
          //                 //           padding: const EdgeInsets.symmetric(horizontal: 5),
          //                 //           child: Container(
          //                 //             child: TextFormField(
          //                 //               decoration: InputDecoration(
          //                 //                 prefixIcon: Icon(Icons.phone),
          //                 //                 labelText: 'Alternate Number',
          //                 //               ),
          //                 //             ),
          //                 //           ),
          //                 //         ),
          //                 //       )
          //                 //     ],
          //                 //   ),
          //                 // ),
          //                 // Padding(
          //                 //   padding: const EdgeInsets.all(0.5),
          //                 //   child: SizedBox(
          //                 //     height: 2.0.h,
          //                 //   ),
          //                 // ),
          //
          //                 // Container(
          //                 //   height: 8.0.h,
          //                 //   child: TextFormField(
          //                 //     decoration: InputDecoration(
          //                 //       prefixIcon: Icon(Icons.contact_phone_rounded),
          //                 //       labelText: 'Landline Number',
          //                 //     ),
          //                 //   ),
          //                 // ),
          //                 // Padding(
          //                 //   padding: const EdgeInsets.all(0.5),
          //                 //   child: SizedBox(
          //                 //     height: 2.0.h,
          //                 //   ),
          //                 // ),
          //                 // new TextFormField(
          //                 //   maxLines: 3,
          //                 //   decoration: new InputDecoration(
          //                 //     border:
          //                 //         new OutlineInputBorder(borderSide: new BorderSide(color: Colors.teal)),
          //                 //     hintText: 'Description',
          //                 //   ),
          //                 // ),
          //                 // Padding(
          //                 //   padding: const EdgeInsets.all(0.5),
          //                 //   child: SizedBox(
          //                 //     height: 2.0.h,
          //                 //   ),
          //                 // ),
          //                 Container(
          //                   height: 6.0.h,
          //                   child: Row(
          //                     children: [
          //                       Flexible(
          //                         flex: 1,
          //                         fit: FlexFit.tight,
          //                         child: Padding(
          //                           padding: const EdgeInsets.symmetric(horizontal: 5),
          //                           child: Container(
          //                               child: Text(
          //                             'Business Percentage',
          //                             style: TextStyle(fontSize: 10.0.sp),
          //                             maxLines: 2,
          //                           )),
          //                         ),
          //                       ),
          //                       Flexible(
          //                         flex: 2,
          //                         fit: FlexFit.tight,
          //                         child: Padding(
          //                           padding: const EdgeInsets.symmetric(horizontal: 5),
          //                           child: Container(
          //                               child: Padding(
          //                             padding: const EdgeInsets.symmetric(horizontal: 50),
          //                             child: Container(
          //                               child: Center(
          //                                   child: Text(
          //                                 '66%',
          //                                 style: TextStyle(fontSize: 12.0.sp),
          //                               )),
          //                               decoration: BoxDecoration(
          //                                   borderRadius: BorderRadius.circular(5),
          //                                   border: Border.all(color: Colors.grey)),
          //                             ),
          //                           )),
          //                         ),
          //                       )
          //                     ],
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   height: 3.0.h,
          //                 ),
          //                 Container(
          //                   height: 6.0.h,
          //                   child: Row(
          //                     children: [
          //                       Flexible(
          //                         flex: 1,
          //                         fit: FlexFit.tight,
          //                         child: Padding(
          //                           padding: const EdgeInsets.symmetric(horizontal: 5),
          //                           child: Container(
          //                               child: Text(
          //                             'Working Hours',
          //                             style: TextStyle(fontSize: 10.0.sp),
          //                             maxLines: 2,
          //                           )),
          //                         ),
          //                       ),
          //                       Flexible(
          //                         flex: 2,
          //                         fit: FlexFit.tight,
          //                         child: Padding(
          //                           padding: const EdgeInsets.symmetric(horizontal: 5),
          //                           child: Container(
          //                               child: Padding(
          //                                   padding: EdgeInsets.symmetric(horizontal: 25.0.sp),
          //                                   child: Row(
          //                                     children: [
          //                                       Flexible(
          //                                         flex: 2,
          //                                         fit: FlexFit.tight,
          //                                         child: InkWell(
          //                                           onTap: _selectTime,
          //                                           child: Container(
          //                                             decoration: BoxDecoration(
          //                                                 borderRadius: BorderRadius.circular(5),
          //                                                 border: Border.all(color: Colors.grey)),
          //                                             child: Row(
          //                                               mainAxisAlignment: MainAxisAlignment.center,
          //                                               children: [
          //                                                 Center(
          //                                                     child: Text('${_time.format(context)}',
          //                                                         style:
          //                                                             TextStyle(fontSize: 10.0.sp)))
          //                                               ],
          //                                             ),
          //                                           ),
          //                                         ),
          //                                       ),
          //                                       Flexible(
          //                                         flex: 1,
          //                                         fit: FlexFit.tight,
          //                                         child: Container(
          //                                           child: Center(child: Text('to')),
          //                                         ),
          //                                       ),
          //                                       Flexible(
          //                                         flex: 2,
          //                                         fit: FlexFit.tight,
          //                                         child: InkWell(
          //                                           onTap: _selectTime1,
          //                                           child: Container(
          //                                             decoration: BoxDecoration(
          //                                                 borderRadius: BorderRadius.circular(5),
          //                                                 border: Border.all(color: Colors.grey)),
          //                                             child: Row(
          //                                               mainAxisAlignment: MainAxisAlignment.center,
          //                                               children: [
          //                                                 Center(
          //                                                     child:
          //                                                         Text('${_time1.format(context)}'))
          //                                               ],
          //                                             ),
          //                                           ),
          //                                         ),
          //                                       ),
          //                                     ],
          //                                   ))),
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   height: 3.0.h,
          //                 ),
          //                 Text(
          //                   'Working Days:',
          //                   style: TextStyle(fontSize: 12.0.sp, fontWeight: FontWeight.w500),
          //                 ),
          //
          //                 Container(
          //                   height: 50.0.h,
          //                   child: ListView(
          //                     physics: NeverScrollableScrollPhysics(),
          //                     children: values.keys.map((String key) {
          //                       return new CheckboxListTile(
          //                         title: new Text(key),
          //                         value: values[key],
          //                         activeColor: Theme.of(context).accentColor,
          //                         checkColor: Colors.white,
          //                         onChanged: (bool value) {
          //                           setState(() {
          //                             print(values[key]);
          //                             values[key] = value;
          //                             print(tmpArray);
          //                           });
          //                         },
          //                       );
          //                     }).toList(),
          //                   ),
          //                 ),
          //
          //                 SizedBox(
          //                   height: 3.0.h,
          //                 ),
          //                 BlockButtonWidget(
          //                   text: Text(
          //                     '             Next              ',
          //                     style: TextStyle(
          //                         color: Colors.black,
          //                         fontWeight: FontWeight.w600,
          //                         letterSpacing: 0.7),
          //                   ),
          //                   color: Theme.of(context).accentColor,
          //                   onPressed: () {
          //                     getCheckboxItems();
          //                     Navigator.push(
          //                         context, MaterialPageRoute(builder: (context) => BankDetails()));
          //
          //                     if (_formKey.currentState.validate()) {}
          //                   },
          //                 ),
          //                 SizedBox(
          //                   height: 3.0.h,
          //                 ),
          //               ],
          //             ),
          //           ),
          //         )
          //       : Center(
          //           child: SpinKitThreeBounce(
          //             color: Theme.of(context).accentColor,
          //           ),
          //         ),
          // ),
        ),
      ),
    );
  }

  String _timeFormated(TimeOfDay time) {
    if (time == null) return "--:--";
    return "${time.hour}:${time.minute}";
  }
}
