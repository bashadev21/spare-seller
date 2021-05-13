import 'dart:convert';

import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:sparedo_partner/src/elements/BlockButtonWidget.dart';

import '../../base_url.dart';

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

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
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
var brands = [];
getCheckboxItems1() {
  // Printing all selected items on Terminal screen.
  print(brands);
  // Here you will get all your selected Checkbox items.

  // Clear array after use.
  // brands.clear();
}

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

class _ProfileTabState extends State<ProfileTab> with SingleTickerProviderStateMixin {
  String termsList, SelectedLocation, SelectedDistict, SelectedStatId, city, district, model;
  String location;
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

  void getYearId(yearId) {
    SelectedLocation = yearId;
    print('yeeeeeeeeeeeeeeeeeeeeee' + yearId);
  }

  GroupController controller = GroupController();
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

  List wdaysListt = List();
  List ProfildeDetails = List();
  Future getprofiledetails() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.get('user_id'));
    var userId = (prefs.get('user_id'));
    UserId = userId;
    var response = await http.get(BaseUrl.profileLoad + 'seller_id=' + UserId);
    var jsonBody = response.body;

    var data = json.decode(jsonBody);
    setState(() {
      data = data;

      print(data);
    });

    this.ProfildeDetails = data['data'];
    // this.wdaysListt = data['data']['working_days'];
    print('bankList');
    print(ProfildeDetails);
    // print(wdaysListt);
    print('hhhhhhh');
    // print(this.wdaysListt);
    print(this.ProfildeDetails);
  }

  TabController _tabController;
  @override
  void initState() {
    getLocation();
    getCategory();
    getprofiledetails();

    _tabController = new TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _shopNameController.dispose();
    _contactNumberController.dispose();
    _alternateNumberController.dispose();
    _landLineNumberController.dispose();
    _addressController.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _alternateNumberController = TextEditingController();
  final TextEditingController _landLineNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String Wdays;
  List brandsList = List();

  var concatenate = StringBuffer();
  bool valuefirst = false;
  var userStatus = List<bool>();
  String UserId;
  Future profileSave() async {
    EasyLoading.show(
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.black,
        status: 'Updating...',
        indicator: SpinKitThreeBounce(
          color: Theme.of(context).accentColor,
        ));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.get('user_id'));
    print(prefs.get('user_password'));
    final userId = (prefs.get('user_id'));
    UserId = userId;
    print('category' + '${CatgoryId}');
    print('category' + '${CatgoryId}');
    print('category' + '${CatgoryId}');
    print('category' + '${CatgoryId}');
    print('brands' + '${brands}');
    print('UserId' + '${UserId}');
    print('from' + '${_time.format(context)}');
    print('to' + '${_time1.format(context)}');
    print('alt_number' + _alternateNumberController.text);
    print('landline_number' + _landLineNumberController.text);
    print('to' + _shopNameController.text);
    print(Wdays1);
    //  print('radiooo' + '${fuel}');

    final uri = Uri.parse(BaseUrl.profileSave);
    var request = http.MultipartRequest('POST', uri);
    request.fields['alt_number'] = _alternateNumberController.text;
    request.fields['landline_number'] = _landLineNumberController.text;
    request.fields['business_percentage'] = '45';
    request.fields['wfrom'] = '${_time.format(context)}';
    request.fields['wto'] = '${_time1.format(context)}';
    request.fields['working_days'] = json.encode(Wdays1);

    request.fields['deals_with'] = json.encode(CatgoryId);
    request.fields['b ds);
    request.fields['seller_id'] = UserId;
    request.fields['name'] = _nameController.text;
    request.fields['shopname'] = _shopNameController.text;
    request.fields['city'] = SelectedStatId;
    request.fields['state'] = location;
    request.fields['district'] = SelectedDistict;
    request.fields['address'] = _addressController.text;
    request.fields['phone'] = _contactNumberController.text;
    //request.fields['images[]'] = json.encode(imagearray);
    //print('imagesssssssssssssssssssssssss' + '${json.encode(imagearray)}');

    // print(_current?.path);

    // var pic = await http.MultipartFile.fromPath('images', json.encode(imagearray));
    // print('frstttttt');
    //
    // request.files.add(pic);

    var response = await request.send();

    setState(() {
      print('statusCode : ' + response.statusCode.toString());
      print(response);
    });
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: "Profile Updated Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      print('sucesssss');
      //Navigator.of(context).pushNamed('/Pages', arguments: 1);
      return print("Sucesss");
    } else {
      return LinearProgressIndicator();
    }
  }

  GroupController switchController = GroupController(
    isMultipleSelection: true,
  );
  List CatgoryId;

  Future getCategoryId(List value3) async {
    // displays 'onetwothree'
    CatgoryId = value3;

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

  String Wdayss;

  @override
  Widget build(BuildContext context) {
    print('ggggggggggg');
    print(Wdayss);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: CategoryList.length > 0
            ? Container(
                height: 80.0.h,
                child: ListView.builder(
                    itemCount: ProfildeDetails.length,
                    itemBuilder: (context, index) {
                      print('hhhh');
                      print(ProfildeDetails[index]['working_days']);
                      Wdayss = ProfildeDetails[index]['working_days'];

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.0.w),
                        child: Column(
                          children: [
                            Container(
                              height: 7.0.h,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Profile',
                                    style:
                                        TextStyle(fontSize: 15.0.sp, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            FormBuilderFilterChip(
                              //  initialValue: [CategoryList[0]['id']],
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'field required';
                                }
                                return null;
                              },
                              showCheckmark: false,
                              selectedColor: Theme.of(context).accentColor,
                              name: 'filter_chip',
                              onChanged: (value3) {
                                setState(() {
                                  print(value3);
                                  getCategoryId(value3);
                                  // _showDialog();
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Deal With',
                                // labelText: 'Deal With',
                                contentPadding: EdgeInsets.all(8),
                                labelStyle: TextStyle(color: Colors.black87, fontSize: 15.0.sp),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).focusColor)),
                              ),
                              spacing: 5.0.sp,
                              options: [
                                FormBuilderFieldOption(
                                    value: CategoryList[0]['id'],
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text('Car'),
                                    )),
                                FormBuilderFieldOption(
                                    value: CategoryList[1]['id'],
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text('Bike'),
                                    )),
                              ],
                            ),

                            SizedBox(
                              height: 3.0.h,
                            ),
                            Container(
                              height: brandsList.length > 0 ? 25.0.h : 0.0.h,
                              child: ListView.builder(
                                  itemCount: brandsList.length & userStatus.length,
                                  itemBuilder: (context, index) {
                                    return SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          // SimpleGroupedCheckbox<int>(
                                          //   controller: switchController,
                                          //   itemsTitle: brandsList[index]['name'],
                                          //   values: brandsList[index]['id'],
                                          //
                                          //   //  textStyle: TextStyle(fontSize: 16),
                                          //   activeColor: Theme.of(context).accentColor,
                                          //   onItemSelected: (values) {
                                          //     print(values);
                                          //     Wdays1 = values;
                                          //     getWdays(values);
                                          //   },
                                          // ),
                                          CheckboxListTile(
                                            title: Text('${brandsList[index]['name']}'),
                                            subtitle: Text('${brandsList[index]['id']}'),

                                            // tristate: false,//
                                            value: userStatus[index],
                                            controlAffinity: ListTileControlAffinity.leading,
                                            activeColor: Theme.of(context).accentColor,
                                            checkColor: Colors.white,
                                            onChanged: (bool value) {
                                              setState(() {
                                                !userStatus[index] == true
                                                    ? brands.add(brandsList[index]['id'])
                                                    : null;

                                                print(brandsList[index]['id']);
                                                userStatus[index] = !userStatus[index];
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                            ),

                            TextFormField(
                              controller: _nameController..text = ProfildeDetails[index]['name'],
                              //   inputFormatters: [Te],
                              cursorColor: Theme.of(context).accentColor,

                              //  maxLength: 10,
                              keyboardType: TextInputType.name,

                              validator: MultiValidator([
                                RequiredValidator(errorText: "Name is required"),
                                // PhoneNumberValidator()
                              ]),
                              decoration: InputDecoration(
                                counterText: '',
                                // prefixText: '+91 ',
                                labelText: 'Name',
                                labelStyle: TextStyle(color: Colors.black87, fontSize: 12.0.sp),
                                contentPadding: EdgeInsets.only(left: 20),
                                hintText: '',
                                hintStyle: TextStyle(color: Theme.of(context).focusColor),
                                prefixIcon:
                                    Icon(Icons.person, color: Theme.of(context).accentColor),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).focusColor)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black87)),
                                enabledBorder:
                                    OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                              ),
                            ),

                            SizedBox(
                              height: 3.0.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0.w),
                              child: DropdownButtonFormField(
                                validator: (value) => value == null ? 'field required' : null,
                                //   validator: RequiredValidator(errorText: "Choose Model"),
                                decoration: new InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                  ),
                                  contentPadding:
                                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                ),
                                value: model,

                                hint: Text(
                                  ProfildeDetails[index]['state_name'],
                                  style: TextStyle(fontSize: 12.0.sp, color: Colors.black87),
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
                                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                  ),
                                  contentPadding:
                                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                ),
                                value: district,

                                hint: Text(
                                  ProfildeDetails[index]['district_name'],
                                  style: TextStyle(fontSize: 12.0.sp, color: Colors.black87),
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
                                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                  ),
                                  contentPadding:
                                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                ),
                                value: city,

                                hint: Text(
                                  ProfildeDetails[index]['city_name'] ?? '',
                                  style: TextStyle(fontSize: 12.0.sp, color: Colors.black87),
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
                            SizedBox(
                              height: 3.0.h,
                            ),

                            // TextFormField(
                            //   //   inputFormatters: [Te],
                            //   cursorColor: Theme.of(context).accentColor,
                            //
                            //   //  maxLength: 10,
                            //   keyboardType: TextInputType.name,
                            //
                            //   validator: MultiValidator([
                            //     RequiredValidator(errorText: "Location is required"),
                            //     // PhoneNumberValidator()
                            //   ]),
                            //   decoration: InputDecoration(
                            //     counterText: '',
                            //     // prefixText: '+91 ',
                            //     labelText: 'Location',
                            //     labelStyle: TextStyle(color: Colors.black87),
                            //     contentPadding: EdgeInsets.only(left: 20),
                            //     hintText: '',
                            //     hintStyle: TextStyle(color: Theme.of(context).focusColor),
                            //     prefixIcon:
                            //         Icon(Icons.location_on_rounded, color: Theme.of(context).accentColor),
                            //     border: OutlineInputBorder(
                            //         borderSide: BorderSide(color: Theme.of(context).focusColor)),
                            //     focusedBorder:
                            //         OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
                            //     enabledBorder:
                            //         OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                            //   ),
                            // ),

                            TextFormField(
                              controller: _shopNameController
                                ..text = ProfildeDetails[index]['shopname'] ?? '',
                              //   inputFormatters: [Te],
                              cursorColor: Theme.of(context).accentColor,

                              //  maxLength: 10,
                              keyboardType: TextInputType.name,

                              validator: MultiValidator([
                                RequiredValidator(errorText: "Shop Name is required"),
                                // PhoneNumberValidator()
                              ]),
                              decoration: InputDecoration(
                                counterText: '',
                                // prefixText: '+91 ',
                                labelText: 'Shop Name',
                                labelStyle: TextStyle(color: Colors.black87, fontSize: 12.0.sp),
                                contentPadding: EdgeInsets.only(left: 20),
                                hintText: '',
                                hintStyle: TextStyle(color: Theme.of(context).focusColor),
                                prefixIcon:
                                    Icon(Icons.shopping_bag, color: Theme.of(context).accentColor),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).focusColor)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black87)),
                                enabledBorder:
                                    OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                              ),
                            ),

                            SizedBox(
                              height: 3.0.h,
                            ),
                            TextFormField(
                              controller: _contactNumberController
                                ..text = ProfildeDetails[index]['phone'],
                              //   inputFormatters: [Te],
                              cursorColor: Theme.of(context).accentColor,

                              maxLength: 10,

                              validator: MultiValidator([
                                RequiredValidator(errorText: "Number is required"),
                                PhoneNumberValidator()
                              ]),
                              keyboardType: TextInputType.phone,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                              ],
                              decoration: InputDecoration(
                                counterText: '',
                                prefixText: '+91 ',
                                labelText: 'Contact Number',
                                labelStyle: TextStyle(color: Colors.black87, fontSize: 12.0.sp),
                                contentPadding: EdgeInsets.only(left: 20),
                                hintText: '',
                                hintStyle: TextStyle(color: Theme.of(context).focusColor),
                                prefixIcon: Icon(Icons.phone, color: Theme.of(context).accentColor),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).focusColor)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black87)),
                                enabledBorder:
                                    OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                              ),
                            ),

                            SizedBox(
                              height: 3.0.h,
                            ),
                            TextFormField(
                              controller: _alternateNumberController
                                ..text = ProfildeDetails[index]['alt_number'],
                              //   inputFormatters: [Te],
                              cursorColor: Theme.of(context).accentColor,

                              maxLength: 10,
                              keyboardType: TextInputType.phone,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                              ],

                              validator: MultiValidator([
                                RequiredValidator(errorText: "Number is required"),
                                PhoneNumberValidator()
                              ]),
                              decoration: InputDecoration(
                                counterText: '',
                                prefixText: '+91 ',
                                labelText: 'Alternate Number',
                                labelStyle: TextStyle(color: Colors.black87, fontSize: 12.0.sp),
                                contentPadding: EdgeInsets.only(left: 20),
                                hintText: '',
                                hintStyle: TextStyle(color: Theme.of(context).focusColor),
                                prefixIcon: Icon(Icons.phone, color: Theme.of(context).accentColor),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).focusColor)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black87)),
                                enabledBorder:
                                    OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                              ),
                            ),

                            SizedBox(
                              height: 3.0.h,
                            ),
                            TextFormField(
                              controller: _landLineNumberController
                                ..text = ProfildeDetails[index]['landline_number'],
                              //   inputFormatters: [Te],
                              cursorColor: Theme.of(context).accentColor,

                              // maxLength: 10,
                              keyboardType: TextInputType.phone,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                              ],

                              validator: MultiValidator([
                                RequiredValidator(errorText: "Number is required"),
                                // PhoneNumberValidator()
                              ]),
                              decoration: InputDecoration(
                                counterText: '',
                                prefixText: '044 ',
                                labelText: 'Landline Number',
                                labelStyle: TextStyle(color: Colors.black87, fontSize: 12.0.sp),
                                contentPadding: EdgeInsets.only(left: 20),
                                hintText: '',
                                hintStyle: TextStyle(color: Theme.of(context).focusColor),
                                prefixIcon: Icon(Icons.contact_phone_rounded,
                                    color: Theme.of(context).accentColor),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).focusColor)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black87)),
                                enabledBorder:
                                    OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                              ),
                            ),

                            SizedBox(
                              height: 3.0.h,
                            ),
                            new TextFormField(
                              controller: _addressController
                                ..text = ProfildeDetails[index]['address'],
                              validator: MultiValidator([
                                RequiredValidator(errorText: "Address  is required"),
                                // PhoneNumberValidator()
                              ]),
                              maxLines: 3,
                              decoration: new InputDecoration(
                                labelText: 'Address',
                                labelStyle: TextStyle(color: Colors.black87, fontSize: 12.0.sp),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).focusColor)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black87)),
                                enabledBorder:
                                    OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                              ),
                            ),

                            SizedBox(
                              height: 3.0.h,
                            ),
                            // Container(
                            //   height: 8.0.h,
                            //   child: Row(
                            //     children: [
                            //       Flexible(
                            //         flex: 1,
                            //         fit: FlexFit.tight,
                            //         child: Padding(
                            //           padding: const EdgeInsets.symmetric(horizontal: 5),
                            //           child: Container(
                            //             child: TextFormField(
                            //               decoration: InputDecoration(
                            //                 prefixIcon: Icon(Icons.phone),
                            //                 labelText: 'Contact Number',
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //       Flexible(
                            //         flex: 1,
                            //         fit: FlexFit.tight,
                            //         child: Padding(
                            //           padding: const EdgeInsets.symmetric(horizontal: 5),
                            //           child: Container(
                            //             child: TextFormField(
                            //               decoration: InputDecoration(
                            //                 prefixIcon: Icon(Icons.phone),
                            //                 labelText: 'Alternate Number',
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //       )
                            //     ],
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.all(0.5),
                            //   child: SizedBox(
                            //     height: 2.0.h,
                            //   ),
                            // ),

                            // Container(
                            //   height: 8.0.h,
                            //   child: TextFormField(
                            //     decoration: InputDecoration(
                            //       prefixIcon: Icon(Icons.contact_phone_rounded),
                            //       labelText: 'Landline Number',
                            //     ),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.all(0.5),
                            //   child: SizedBox(
                            //     height: 2.0.h,
                            //   ),
                            // ),
                            // new TextFormField(
                            //   maxLines: 3,
                            //   decoration: new InputDecoration(
                            //     border:
                            //         new OutlineInputBorder(borderSide: new BorderSide(color: Colors.teal)),
                            //     hintText: 'Description',
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.all(0.5),
                            //   child: SizedBox(
                            //     height: 2.0.h,
                            //   ),
                            // ),
                            Container(
                              height: 6.0.h,
                              child: Row(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      child: Container(
                                          child: Text(
                                        'Business Percentage',
                                        style: TextStyle(fontSize: 12.0.sp, color: Colors.black87),
                                        maxLines: 2,
                                      )),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 2,
                                    fit: FlexFit.tight,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      child: Container(
                                          child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 50),
                                        child: Container(
                                          child: Center(
                                              child: Text(
                                            ProfildeDetails[index]['business_percentage']
                                                .toString(),
                                            style: TextStyle(fontSize: 12.0.sp),
                                          )),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              border: Border.all(color: Colors.grey)),
                                        ),
                                      )),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 3.0.h,
                            ),
                            Container(
                              height: 6.0.h,
                              child: Row(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      child: Container(
                                          child: Text(
                                        'Working Hours',
                                        style: TextStyle(fontSize: 12.0.sp),
                                        maxLines: 2,
                                      )),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 2,
                                    fit: FlexFit.tight,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      child: Container(
                                          child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 25.0.sp),
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    flex: 2,
                                                    fit: FlexFit.tight,
                                                    child: InkWell(
                                                      onTap: _selectTime,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(color: Colors.grey)),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment.center,
                                                          children: [
                                                            Center(
                                                                child: ProfildeDetails[index]
                                                                            ['wfrom'] ==
                                                                        null
                                                                    ? Text(
                                                                        '${_time.format(context)}',
                                                                        style: TextStyle(
                                                                            fontSize: 10.0.sp))
                                                                    : Text(
                                                                        ProfildeDetails[index]
                                                                                ['wfrom']
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            fontSize: 10.0.sp)))
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    flex: 1,
                                                    fit: FlexFit.tight,
                                                    child: Container(
                                                      child: Center(child: Text('to')),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    flex: 2,
                                                    fit: FlexFit.tight,
                                                    child: InkWell(
                                                      onTap: _selectTime1,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
                                                            border: Border.all(color: Colors.grey)),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment.center,
                                                          children: [
                                                            Center(
                                                                child: ProfildeDetails[index]
                                                                            ['wto'] ==
                                                                        null
                                                                    ? Text(
                                                                        '${_time1.format(context)}',
                                                                        style: TextStyle(
                                                                            fontSize: 10.0.sp))
                                                                    : Text(
                                                                        ProfildeDetails[index]
                                                                                ['wto']
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            fontSize: 10.0.sp)))
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 3.0.h,
                            ),
                            Text(
                              'Working Days:',
                              style: TextStyle(fontSize: 12.0.sp, fontWeight: FontWeight.w500),
                            ),
                            SimpleGroupedCheckbox<int>(
                              controller: switchController,
                              disableItems: ProfildeDetails[index]['working_days'],
                              itemsTitle: [
                                'Sunday',
                                'Monday',
                                'Tuesday',
                                'Wednesday',
                                'Thursday',
                                'Friday',
                                'Saturday'
                              ],
                              values: [1, 2, 3, 4, 5, 6, 7],
                              //  textStyle: TextStyle(fontSize: 16),
                              activeColor: Theme.of(context).accentColor,
                              onItemSelected: (values) {
                                print(values);
                                Wdays1 = values;
                                getWdays(values);
                              },
                            ),

                            // Container(
                            //   height: 50.0.h,
                            //   child: ListView(
                            //     physics: NeverScrollableScrollPhysics(),
                            //     children: values.keys.map((String key) {
                            //       return new CheckboxListTile(
                            //         title: new Text(key),
                            //         value: values[key],
                            //         activeColor: Theme.of(context).accentColor,
                            //         checkColor: Colors.white,
                            //         onChanged: (bool value) {
                            //           setState(() {
                            //             print(values[key]);
                            //             values[key] = value;
                            //             print(tmpArray);
                            //           });
                            //         },
                            //       );
                            //     }).toList(),
                            //   ),
                            // ),

                            SizedBox(
                              height: 3.0.h,
                            ),
                            BlockButtonWidget(
                              text: Text(
                                '             Submit              ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.7),
                              ),
                              color: Theme.of(context).accentColor,
                              onPressed: () {
                                print('ffff');
                                print(Wdays1);
                                print('ffff');
                                getCheckboxItems();
                                getCheckboxItems1();

                                // Navigator.push(
                                //     context, MaterialPageRoute(builder: (context) => BankDetails()));

                                if (_formKey.currentState.validate()) {
                                  profileSave();
                                }
                              },
                            ),
                            SizedBox(
                              height: 3.0.h,
                            ),
                          ],
                        ),
                      );
                    }),
              )
            : Center(
                child: SpinKitThreeBounce(
                  color: Theme.of(context).accentColor,
                ),
              ),
      ),
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          // StatefulBuilder
          builder: (context, setState) {
            return Dialog(
              child: Container(
                height: 46.0.h,
                child: ListView.builder(
                    itemCount: brandsList.length & userStatus.length,
                    itemBuilder: (context, index) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            CheckboxListTile(
                              title: Text('${brandsList[index]['name']}'),
                              subtitle: Text('${brandsList[index]['id']}'),

                              // tristate: false,//
                              value: userStatus[index],
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: Theme.of(context).accentColor,
                              checkColor: Colors.white,
                              onChanged: (bool value) {
                                setState(() {
                                  !userStatus[index] == true
                                      ? brands.add(brandsList[index]['id'])
                                      : null;

                                  print(brandsList[index]['id']);
                                  userStatus[index] = !userStatus[index];
                                });
                              },
                            )
                          ],
                        ),
                      );
                    }),
              ),
            );
          },
        );
      },
    );
  }

  void getWdays(List values) {
    Wdays1 = values;
  }

  List Wdays1 = [];
}
