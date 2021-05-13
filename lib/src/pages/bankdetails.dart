import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:sparedo_partner/src/elements/BlockButtonWidget.dart';

import '../../base_url.dart';

class BankDetails extends StatefulWidget {
  @override
  _BankDetailsState createState() => _BankDetailsState();
}

bool _isEditingText = false;
TextEditingController _editingController;
String initialText = "Initial Text";
GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController _accountName = TextEditingController();
final TextEditingController _accountNumber = TextEditingController();
final TextEditingController _IFSC = TextEditingController();
final TextEditingController _accountType = TextEditingController();
final TextEditingController _googlepay = TextEditingController();
final TextEditingController _phonepay = TextEditingController();
final TextEditingController _remarks = TextEditingController();

class _BankDetailsState extends State<BankDetails> {
  String UserId;
  List bankList = List();
  Future getbankdetails() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.get('user_id'));
    var userId = (prefs.get('user_id'));
    UserId = userId;
    var response = await http.get(BaseUrl.bankLoad + 'seller_id=' + UserId);
    var jsonBody = response.body;

    var data = json.decode(jsonBody);
    setState(() {
      data = data;

      print(data);
    });

    this.bankList = data['data'];
    print('bankList');
    print(bankList);
    print(this.bankList);
  }

  Future savebank() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.get('user_id'));
    var userId = (prefs.get('user_id'));
    UserId = userId;
    EasyLoading.show(
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.black,
        status: 'loading...',
        indicator: SpinKitThreeBounce(
          color: Theme.of(context).accentColor,
        ));
    var response = await http.post(BaseUrl.bankSave +
        'seller_id=' +
        UserId +
        '&' +
        'account_number=' +
        _accountNumber.text +
        '&' +
        'account_name=' +
        _accountName.text +
        '&' +
        'ifsc_code=' +
        _IFSC.text +
        '&' +
        'account_type=' +
        _accountType.text +
        '&' +
        'google_pay=' +
        _googlepay.text +
        '&' +
        'phone_pe=' +
        _phonepay.text +
        '&' +
        'remarks=' +
        _remarks.text);
    json.decode(response.body);

    setState(() {
      print(response);
      print(response);
    });
    print('statusCode : ' + response.statusCode.toString());

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      Navigator.of(context).pushNamed('/Pages', arguments: 1);
      Fluttertoast.showToast(
          msg: "Bank Details Updated Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
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
    if (response.statusCode == 401) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: "Something Went Wrong",
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

  @override
  void initState() {
    _editingController = TextEditingController(text: initialText);
    getbankdetails();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _editingController.dispose();
    // _accountNumber.dispose();
    // _accountName.dispose();
    // _phonepay.dispose();
    // _googlepay.dispose();
    // _accountType.dispose();
    // _IFSC.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.0.w),
          child: Form(
            key: _formKey,
            child: Container(
                height: 80.0.h,
                child: bankList.length > 0
                    ? ListView.builder(
                        itemCount: bankList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 68.0.h,
                            child: ListView(
                              children: [
                                Container(
                                  height: 7.0.h,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Bank Details',
                                        style: TextStyle(
                                            fontSize: 15.0.sp, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                //  _editTitleTextField(),
                                TextFormField(
                                  controller: _accountName..text = bankList[index]['account_name'],
                                  validator: MultiValidator([
                                    RequiredValidator(errorText: "Account Name is required"),
                                    // PhoneNumberValidator()
                                  ]),
                                  cursorColor: Theme.of(context).accentColor,
                                  decoration: InputDecoration(
                                    // prefixIcon: Icon(Icons.shopping_bag),
                                    labelText: 'Account Name',
                                    labelStyle: TextStyle(color: Colors.black87),
                                    contentPadding: EdgeInsets.only(left: 20),
                                    hintText: '',
                                    hintStyle: TextStyle(color: Theme.of(context).focusColor),

                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Theme.of(context).focusColor)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black87)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey)),
                                  ),
                                ),
                                SizedBox(
                                  height: 2.5.h,
                                ),
                                TextFormField(
                                  controller: _accountNumber
                                    ..text = bankList[index]['account_number'],
                                  validator: MultiValidator([
                                    RequiredValidator(errorText: "Account Number is required"),
                                    // PhoneNumberValidator()
                                  ]),
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                  ],
                                  cursorColor: Theme.of(context).accentColor,
                                  decoration: InputDecoration(
                                    // prefixIcon: Icon(Icons.shopping_bag),
                                    labelText: 'Account Number',
                                    labelStyle: TextStyle(color: Colors.black87),
                                    contentPadding: EdgeInsets.only(left: 20),
                                    hintText: '',
                                    hintStyle: TextStyle(color: Theme.of(context).focusColor),

                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Theme.of(context).focusColor)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black87)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey)),
                                  ),
                                ),
                                SizedBox(
                                  height: 2.5.h,
                                ),
                                TextFormField(
                                  controller: _accountNumber
                                    ..text = bankList[index]['account_number'],
                                  validator: (val) {
                                    if (val.isEmpty) return 'Empty';
                                    if (val != _accountNumber.text) return 'Not Match';
                                    return null;
                                  },
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                  ],
                                  cursorColor: Theme.of(context).accentColor,
                                  decoration: InputDecoration(
                                    // prefixIcon: Icon(Icons.shopping_bag),
                                    labelText: 'Re-Enter Account Number',
                                    labelStyle: TextStyle(color: Colors.black87),
                                    contentPadding: EdgeInsets.only(left: 20),
                                    hintText: '',
                                    hintStyle: TextStyle(color: Theme.of(context).focusColor),

                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Theme.of(context).focusColor)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black87)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey)),
                                  ),
                                ),
                                SizedBox(
                                  height: 2.5.h,
                                ),
                                TextFormField(
                                  controller: _IFSC..text = bankList[index]['ifsc_code'],
                                  validator: MultiValidator([
                                    RequiredValidator(errorText: "IFSC Code is required"),
                                    // PhoneNumberValidator()
                                  ]),
                                  keyboardType: TextInputType.text,
                                  // inputFormatters: <TextInputFormatter>[
                                  //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                  // ],
                                  cursorColor: Theme.of(context).accentColor,
                                  decoration: InputDecoration(
                                    // prefixIcon: Icon(Icons.shopping_bag),
                                    labelText: 'IFSC Code',
                                    labelStyle: TextStyle(color: Colors.black87),
                                    contentPadding: EdgeInsets.only(left: 20),
                                    hintText: '',
                                    hintStyle: TextStyle(color: Theme.of(context).focusColor),

                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Theme.of(context).focusColor)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black87)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey)),
                                  ),
                                ),
                                SizedBox(
                                  height: 2.5.h,
                                ),
                                TextFormField(
                                  controller: _accountType..text = bankList[index]['account_type'],
                                  validator: MultiValidator([
                                    RequiredValidator(errorText: "Account Type is required"),
                                    // PhoneNumberValidator()
                                  ]),
                                  keyboardType: TextInputType.text,
                                  // inputFormatters: <TextInputFormatter>[
                                  //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                  // ],
                                  cursorColor: Theme.of(context).accentColor,
                                  decoration: InputDecoration(
                                    // prefixIcon: Icon(Icons.shopping_bag),
                                    labelText: 'Account Type',
                                    labelStyle: TextStyle(color: Colors.black87),
                                    contentPadding: EdgeInsets.only(left: 20),
                                    hintText: '',
                                    hintStyle: TextStyle(color: Theme.of(context).focusColor),

                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Theme.of(context).focusColor)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black87)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey)),
                                  ),
                                ),
                                SizedBox(
                                  height: 2.5.h,
                                ),
                                TextFormField(
                                  controller: _googlepay..text = bankList[index]['google_pay'],
                                  validator: MultiValidator([
                                    RequiredValidator(errorText: "Google Pay Number is required"),
                                    // PhoneNumberValidator()
                                  ]),
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                  ],
                                  cursorColor: Theme.of(context).accentColor,
                                  decoration: InputDecoration(
                                    // prefixIcon: Icon(Icons.shopping_bag),
                                    labelText: 'Google Pay Number',
                                    labelStyle: TextStyle(color: Colors.black87),
                                    contentPadding: EdgeInsets.only(left: 20),
                                    hintText: '',
                                    hintStyle: TextStyle(color: Theme.of(context).focusColor),

                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Theme.of(context).focusColor)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black87)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey)),
                                  ),
                                ),
                                SizedBox(
                                  height: 2.5.h,
                                ),
                                TextFormField(
                                  controller: _phonepay..text = bankList[index]['phone_pe'],
                                  validator: MultiValidator([
                                    RequiredValidator(errorText: "PhonePe is required"),
                                    // PhoneNumberValidator()
                                  ]),
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                  ],
                                  cursorColor: Theme.of(context).accentColor,
                                  decoration: InputDecoration(
                                    // prefixIcon: Icon(Icons.shopping_bag),
                                    labelText: 'PhonePe Number',
                                    labelStyle: TextStyle(color: Colors.black87),
                                    contentPadding: EdgeInsets.only(left: 20),
                                    hintText: '',
                                    hintStyle: TextStyle(color: Theme.of(context).focusColor),

                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Theme.of(context).focusColor)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black87)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey)),
                                  ),
                                ),
                                SizedBox(
                                  height: 2.5.h,
                                ),
                                TextFormField(
                                  controller: _remarks..text = bankList[index]['remarks'],
                                  validator: MultiValidator([
                                    RequiredValidator(errorText: "Remarks is required"),
                                    // PhoneNumberValidator()
                                  ]),
                                  keyboardType: TextInputType.text,
                                  // inputFormatters: <TextInputFormatter>[
                                  //   FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                  // ],
                                  cursorColor: Theme.of(context).accentColor,
                                  decoration: InputDecoration(
                                    // prefixIcon: Icon(Icons.shopping_bag),
                                    labelText: 'Remarks',
                                    labelStyle: TextStyle(color: Colors.black87),
                                    contentPadding: EdgeInsets.only(left: 20),
                                    hintText: '',
                                    hintStyle: TextStyle(color: Theme.of(context).focusColor),

                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Theme.of(context).focusColor)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black87)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey)),
                                  ),
                                ),
                                SizedBox(
                                  height: 4.5.h,
                                ),
                                BlockButtonWidget(
                                  text: Text(
                                    '          Submit          ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.7),
                                  ),
                                  color: Theme.of(context).accentColor,
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      savebank();
                                    }
                                    // Navigator.push(
                                    //     context, MaterialPageRoute(builder: (context) => BankDetails()));
                                  },
                                ),
                                SizedBox(
                                  height: 3.5.h,
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : Center(
                        child: SpinKitThreeBounce(
                          color: Theme.of(context).accentColor,
                        ),
                      )),
          ),
        ),
      ),
    );
  }

  Widget _editTitleTextField() {
    if (_isEditingText)
      return Center(
        child: TextField(
          onSubmitted: (newValue) {
            setState(() {
              initialText = newValue;
              _isEditingText = false;
            });
          },
          autofocus: true,
          controller: _editingController,
        ),
      );
    return InkWell(
        onTap: () {
          setState(() {
            _isEditingText = true;
          });
        },
        child: Text(
          initialText,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
          ),
        ));
  }
}
