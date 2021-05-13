import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sparedo_partner/src/elements/BlockButtonWidget.dart';

import '../helpers/app_config.dart' as config;

class OtpScreen extends StatefulWidget {
  final String phone;
  OtpScreen(this.phone);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

final _formKey = GlobalKey<FormState>();
bool hasError = false;
String currentText = "";

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

var onTapRecognizer;

TextEditingController textEditingController = TextEditingController();

class _OtpScreenState extends State<OtpScreen> {
  List userList;
  // Future otpverifyFunc() async {
  //   var response = await http.post(BaseUrl.otpVerify +
  //       'phone=' +
  //       widget.phone +
  //       '&' +
  //       'otp=' +
  //       currentText);
  //   json.decode(response.body);
  //   var jsonBody = response.body;
  //   var data = json.decode(jsonBody);
  //
  //   setState(() {
  //     data = data;
  //     // this.LoginList = data['data'];
  //     // print('listtttt');
  //     // print(this.LoginList);
  //   });
  //   this.userList = data['data'];
  //   print('listtttt');
  //   print(this.userList);
  //   print('statusCode : ' + response.statusCode.toString());
  //
  //   if (response.statusCode == 200) {
  //     Navigator.of(context).pushReplacementNamed('/Pages', arguments: 1);
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     prefs.setString('user_id', userList[0]['id'].toString());
  //     prefs.setString('user_name', userList[0]['name'].toString());
  //     prefs.setString('user_email', userList[0]['phone'].toString());
  //     print(userList[0]['name'].toString());
  //     print(userList[0]['name'].toString());
  //     print(userList[0]['name'].toString());
  //
  //     print('response body : ${response.body}');
  //     try {
  //       json.decode(response.body);
  //       print('trying to decode  Respose Body result is : success');
  //     } catch (Ex) {
  //       print("Exepition with json decode : $Ex");
  //     }
  //   }
  //   if (response.statusCode == 401) {
  //     CoolAlert.show(
  //       context: context,
  //       type: CoolAlertType.error,
  //       text: "Invalid OTP",
  //       backgroundColor: Theme.of(context).accentColor,
  //     );
  //     print('response body : ${response.body}');
  //
  //     try {
  //       json.decode(response.body);
  //       print('trying to decode  Respose Body result is : success');
  //     } catch (Ex) {
  //       print("Exepition with json decode : $Ex");
  //     }
  //   }
  //   return response;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Positioned(
            top: 0,
            child: Container(
              width: config.App(context).appWidth(100),
              height: config.App(context).appHeight(37),
              decoration: BoxDecoration(color: Colors.black),
            ),
          ),
          Positioned(
            top: config.App(context).appHeight(22) - 120,
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
            top: config.App(context).appHeight(37) - 120,
            child: Container(
              width: config.App(context).appWidth(77),
              height: config.App(context).appHeight(37),
              child: Text(
                'Enter OTP',
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .merge(TextStyle(color: Theme.of(context).primaryColor)),
              ),
            ),
          ),
          Positioned(
            top: config.App(context).appHeight(37) - 50,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
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
              padding:
                  EdgeInsets.only(top: 50, right: 27, left: 27, bottom: 30),
              width: config.App(context).appWidth(88),
//              height: config.App(context).appHeight(55),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 20),
                        child: PinCodeTextField(
                          appContext: context,
                          // pastedTextStyle: TextStyle(
                          //   color: Colors.green.shade600,
                          //   fontWeight: FontWeight.bold,
                          // ),
                          length: 4,

                          blinkWhenObscuring: true,
                          animationType: AnimationType.fade,
                          enablePinAutofill: true,
                          validator: (v) {
                            if (v.length < 4) {
                              return "Enter Valid Otp";
                            } else {
                              return null;
                            }
                          },
                          pinTheme: PinTheme(
                            disabledColor: Colors.white,
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(5),
                            fieldHeight: 50,
                            fieldWidth: 40,
                            selectedFillColor: Colors.white,
                            inactiveFillColor: Colors.white,
                            activeFillColor:
                                hasError ? Colors.orange : Colors.white,
                          ),
                          cursorColor: Colors.black,
                          animationDuration: Duration(milliseconds: 300),
                          backgroundColor: Colors.white,
                          enableActiveFill: true,
                          //  errorAnimationController: errorController,
                          //   controller: textEditingController,
                          keyboardType: TextInputType.number,
                          boxShadows: [
                            BoxShadow(
                              offset: Offset(0, 1),
                              color: Colors.black12,
                              blurRadius: 10,
                            )
                          ],
                          onCompleted: (v) {
                            print("Completed");
                          },
                          // onTap: () {
                          //   print("Pressed");
                          // },
                          onChanged: (value) {
                            print(value);
                            setState(() {
                              currentText = value;
                            });
                          },
                          beforeTextPaste: (text) {
                            print("Allowing to paste $text");
                            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                            //but you can show anything you want here, like your pop up saying wrong paste format or etc
                            return true;
                          },
                        )),
                    SizedBox(height: 30),
                    BlockButtonWidget(
                      text: Text(
                        'Submit',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        //  otpverifyFunc();
                        print('otp' + currentText);
                        //   print(_usernamecontroller.text);
                        //     print(_passwordcontroller.text);
                        //   _formKey.currentState.validate() ? LoginFunc() : null;

                        //   _con.login();
                      },
                    ),

                    // TextFormField(
                    //   controller: _usernamecontroller,
                    //
                    //   maxLength: 10,
                    //   keyboardType: TextInputType.phone,
                    //   validator: MultiValidator([
                    //     RequiredValidator(errorText: "Phone Number Required"),
                    //     EmailValidator(errorText: "Enter Valid Phone Number")
                    //   ]),
                    //   //   onSaved: (input) => _con.user.email = input,
                    //
                    //   decoration: InputDecoration(
                    //     counterText: '',
                    //     labelText: 'Phone',
                    //     labelStyle:
                    //         TextStyle(color: Theme.of(context).accentColor),
                    //     contentPadding: EdgeInsets.all(12),
                    //     hintText: '',
                    //     prefixText: '+91',
                    //     hintStyle: TextStyle(
                    //         color: Theme.of(context)
                    //             .focusColor
                    //             .withOpacity(0.7)),
                    //     prefixIcon: Icon(Icons.phone,
                    //         color: Theme.of(context).accentColor),
                    //     border: OutlineInputBorder(
                    //         borderSide: BorderSide(
                    //             color: Theme.of(context)
                    //                 .focusColor
                    //                 .withOpacity(0.2))),
                    //     focusedBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(
                    //             color: Theme.of(context)
                    //                 .focusColor
                    //                 .withOpacity(0.5))),
                    //     enabledBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(
                    //             color: Theme.of(context)
                    //                 .focusColor
                    //                 .withOpacity(0.2))),
                    //   ),
                    // ),
                    // SizedBox(height: 30),
                    // TextFormField(
                    //   keyboardType: TextInputType.text,
                    //   controller: _passwordcontroller,
                    //   // onSaved: (input) => _con.user.password = input,
                    //   validator: MultiValidator([
                    //     RequiredValidator(errorText: "password is required"),
                    //   ]),
                    //   obscureText: _con.hidePassword,
                    //   decoration: InputDecoration(
                    //     labelText: S.of(context).password,
                    //     labelStyle:
                    //         TextStyle(color: Theme.of(context).accentColor),
                    //     contentPadding: EdgeInsets.all(12),
                    //     hintText: '••••••••••••',
                    //     hintStyle: TextStyle(
                    //         color: Theme.of(context)
                    //             .focusColor
                    //             .withOpacity(0.7)),
                    //     prefixIcon: Icon(Icons.lock_outline,
                    //         color: Theme.of(context).accentColor),
                    //     suffixIcon: IconButton(
                    //       onPressed: () {
                    //         setState(() {
                    //           _con.hidePassword = !_con.hidePassword;
                    //         });
                    //       },
                    //       color: Theme.of(context).focusColor,
                    //       icon: Icon(_con.hidePassword
                    //           ? Icons.visibility
                    //           : Icons.visibility_off),
                    //     ),
                    //     border: OutlineInputBorder(
                    //         borderSide: BorderSide(
                    //             color: Theme.of(context)
                    //                 .focusColor
                    //                 .withOpacity(0.2))),
                    //     focusedBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(
                    //             color: Theme.of(context)
                    //                 .focusColor
                    //                 .withOpacity(0.5))),
                    //     enabledBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(
                    //             color: Theme.of(context)
                    //                 .focusColor
                    //                 .withOpacity(0.2))),
                    //   ),
                    // ),

                    // FlatButton(
                    //   onPressed: () {
                    //     Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
                    //   },
                    //   shape: StadiumBorder(),
                    //   textColor: Theme.of(context).hintColor,
                    //   child: Text(S.of(context).skip),
                    //   padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                    // ),
//                      SizedBox(height: 10),
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
