import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:sparedo_partner/src/elements/BlockButtonWidget.dart';
import 'package:sparedo_partner/src/pages/pages.dart';

import '../../base_url.dart';
import 'signup.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  List LoginList;

  List Loginchk;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernamecontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  String UserId;

  Future LoginFunc() async {
    EasyLoading.show(
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.black,
        status: 'loading...',
        indicator: SpinKitThreeBounce(
          color: Theme.of(context).accentColor,
        ));
    var response = await http.post(BaseUrl.login +
        'email=' +
        _usernamecontroller.text +
        '&' +
        'password=' +
        _passwordcontroller.text);
    json.decode(response.body);
    var jsonBody = response.body;
    var data = json.decode(jsonBody);
    setState(() {
      data = data;
    });
    this.LoginList = data['data'];
    print('listtttt');
    print(this.LoginList);
    if (response.statusCode == 200) {
      data['data'] != null
          ? Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PagesWidget(
                  currentTab: 1,
                ),
              ))
          : null;
      if (data['data'] == null) {
        EasyLoading.dismiss();
        Fluttertoast.showToast(
            msg: "Waiting For Admin Approval",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.red[500],
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        EasyLoading.dismiss();
        print('resonse $LoginList');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user_id', LoginList[0]['id'].toString());
        prefs.setString('user_name', LoginList[0]['name'].toString());
        prefs.setString('user_email', LoginList[0]['email'].toString());
        prefs.setString('user_shop', LoginList[0]['shopname'].toString());
        prefs.setString('user_phone', LoginList[0]['phone'].toString());
        prefs.setString('user_city', LoginList[0]['city'].toString());

        prefs.setString('user_password', _passwordcontroller.text);

        Navigator.of(context).pushReplacementNamed('/Pages', arguments: 1);

        Fluttertoast.showToast(
            msg: "Welcome",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      if (response.statusCode == 401) {
        EasyLoading.dismiss();
        print('noooooooooooo');
        Fluttertoast.showToast(
            msg: "Invalid Credentials",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }

    setState(() {
      print(response);
      print(response);
    });
    print('statusCode : ' + response.statusCode.toString());
  }

  bool _obscureText = true;

  String _password;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Positioned(
            top: 0,
            child: Container(
              width: _width,
              height: _height * 0.42,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(120)),
              ),
            ),
          ),
          Positioned(
              bottom: 3.0.h,
              child: FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpWidget()));
                },
                child: Row(
                  children: [
                    Text("Don't have an acount?", style: TextStyle(color: Colors.black87)),
                    Text(" Register",
                        style: TextStyle(
                            color: Theme.of(context).accentColor, fontWeight: FontWeight.w600)),
                  ],
                ),
              )),
          Positioned(
            top: 23.0.h,
            child: Container(
              width: 84.0.w,
              height: 37.0.h,
              child: Text(
                'Lets Start with Login!',
                style: Theme.of(context).textTheme.headline2.merge(TextStyle(color: Colors.white)),
              ),
            ),
          ),
          Positioned(
            top: 6.0.h,
            child: Container(
                width: 54.0.w,
                height: 37.0.h,
                child: Column(
                  children: [
                    Image.asset('assets/img/2.png', height: 100, width: 150),
                  ],
                )),
          ),
          Positioned(
            top: 30.0.h,
            child: Container(
              height: 50.0.h,
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
                horizontal: 20,
              ),
              padding: EdgeInsets.only(top: 50, right: 27, left: 27, bottom: 10),
              width: 88.0.w,
//              height: config.App(context).appHeight(55),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _usernamecontroller,
                      validator: MultiValidator([
                        RequiredValidator(errorText: "Email is required"),
                        EmailValidator(errorText: "Enter a valid email")
                      ]),
                      //   onSaved: (input) => _con.user.email = input,

                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.black87),
                        contentPadding: EdgeInsets.all(12),
                        hintText: 'Enter Your Email',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: Icon(Icons.mail, color: Theme.of(context).accentColor),
                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
                        focusedBorder:
                            OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
                        enabledBorder:
                            OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
                      ),
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _passwordcontroller,
                      // onSaved: (input) => _con.user.password = input,
                      validator: MultiValidator([
                        RequiredValidator(errorText: "password is required"),
                      ]),
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.black87),
                        contentPadding: EdgeInsets.all(12),
                        hintText: '•••••••••',
                        hintStyle: TextStyle(color: Colors.grey[300]),
                        prefixIcon: Icon(Icons.lock, color: Theme.of(context).accentColor),
                        suffixIcon: IconButton(
                          onPressed: _toggle,
                          color: Colors.grey,
                          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                        ),
                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
                        focusedBorder:
                            OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
                        enabledBorder:
                            OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
                      ),
                    ),
                    SizedBox(height: 30),
                    BlockButtonWidget(
                      text: Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600, letterSpacing: 0.7),
                      ),
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        print(_usernamecontroller.text);
                        print(_passwordcontroller.text);
                        _formKey.currentState.validate() ? LoginFunc() : null;
                        //   Navigator.pushReplacement(context,
                        //     MaterialPageRoute(builder: (context) => Home()));
                      },
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
