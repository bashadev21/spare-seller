import 'dart:convert';
import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sparedo_partner/base_url.dart';
import 'package:sparedo_partner/src/elements/BlockButtonWidget.dart';
import 'package:sparedo_partner/src/pages/carScreen.dart';
import 'package:sparedo_partner/src/pages/login.dart';

class BookingForm extends StatefulWidget {
  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  int groupValue = -1;
  String brand, model, variant, year, selectedModelId, selectedBrandId, UserId, selectedvariant;
  final _formKey = GlobalKey<FormState>();
  List modelList = List();
  List variantList = List();
  List yearList = List();
  List fuelList = List();
  final TextEditingController _controller = TextEditingController();
  final LocalStorage storage = new LocalStorage("");
  // Future getModels() async {
  //   var brnad = storage.getItem('brand_id');
  //   var selected_category = storage.getItem('category_id');
  //   selectedBrandId = brand;
  //
  //   var response = await http.get(BaseUrl.models +
  //       'category_id=' +
  //       selected_category.toString() +
  //       '&' +
  //       'brand_id=' +
  //       brnad.toString());
  //   var jsonBody = response.body;
  //   var data = json.decode(jsonBody);
  //   setState(() {
  //     data = data;
  //   });
  //
  //   this.modelList = data['data'];
  //   print('listtttt');
  //   print(this.modelList);
  // }

  final picker = ImagePicker();
  File _image1;
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image1 = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  int Loginchk;
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
      print(data);
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

    print('listttttda');
    print(this.Loginchk);

    print('statusCodew : ' + response.statusCode.toString());
  }
  //
  // Future getVariant(modelId) async {
  //   var brnad = storage.getItem('brand_id');
  //   var selected_category = storage.getItem('category_id');
  //
  //   selectedModelId = modelId;
  //   var response = await http.get(BaseUrl.variants +
  //       'category_id=' +
  //       selected_category +
  //       '&' +
  //       'brand_id=' +
  //       brnad +
  //       '&' +
  //       'model_id=' +
  //       modelId);
  //   var jsonBody = response.body;
  //
  //   var data = json.decode(jsonBody);
  //   setState(() {
  //     data = data;
  //     print(data);
  //   });
  //
  //   this.variantList = data['data'];
  //   print('varienttttt');
  //   print(this.variantList);
  // }

  // Future getYear(variantId) async {
  //   var brnad = storage.getItem('brand_id');
  //   var selected_category = storage.getItem('category_id');
  //   print(selectedModelId);
  //   print(selectedModelId);
  //   print(selectedModelId);
  //   selectedvariant = variantId;
  //   print(variantId);
  //   var response = await http.get(BaseUrl.year +
  //       'category_id=' +
  //       selected_category +
  //       '&' +
  //       'brand_id=' +
  //       brnad +
  //       '&' +
  //       'model_id=' +
  //       selectedModelId +
  //       '&' +
  //       'variant_id=' +
  //       variantId);
  //   var jsonBody = response.body;
  //   var data = json.decode(jsonBody);
  //   setState(() {
  //     data = data;
  //     print(data);
  //   });
  //   print('yearrrrrrrrr');
  //   this.yearList = data['data'];
  //   print(this.yearList);
  // }

  void getYearId(yearId) {
    SelectedYearId = yearId;
    print('yeeeeeeeeeeeeeeeeeeeeee' + yearId);
  }

  bool _autovalidate = false;
  String selectedSalutation;
  String name;
  // Future getFuel() async {
  //   var response = await http.get(BaseUrl.fuel);
  //   var jsonBody = response.body;
  //   var data = json.decode(jsonBody);
  //   setState(() {
  //     data = data;
  //   });
  //
  //   this.fuelList = data['data'];
  //   print(this.fuelList);
  // }
  //
  // Future book() async {
  //   var brnad = storage.getItem('brand_id');
  //   var selected_category = storage.getItem('category_id');
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.getString('user_id');
  //   setState(() {
  //     var current_user = (prefs.getString('user_id') ?? '');
  //     UserId = prefs.getString('user_id');
  //     print(UserId);
  //   });
  //
  //   final uri = Uri.parse(BaseUrl.booking);
  //   var request = http.MultipartRequest('POST', uri);
  //   request.fields['category'] = selected_category;
  //   request.fields['brand'] = brnad;
  //   request.fields['model'] = selectedModelId;
  //   request.fields['variant'] = selectedvariant;
  //   request.fields['year'] = SelectedYearId;
  //   request.fields['buyer'] = UserId;
  //   request.fields['description'] = _controller.text;
  //   request.fields['fuel'] = groupValue.toString();
  //   var pic = await http.MultipartFile.fromPath('images', _image1.path);
  //   request.files.add(pic);
  //   var response = await request.send();
  //
  //   // var response=await http.post('http://192.168.1.147:8080/sparedo_partner/public/api/book?'+'category='+selected_category+'&'+'brand='+selectId+'&'+'model='+selectedModelId+'&'+'variant='+selectedvariant+'&'+'year='+SelectedYearId+'&'+'buyer='+UserId+'&'+'description='+_controller.text+'&'+'fuel='+groupValue.toString()+'&'+'images='+_image1);
  //
  //   setState(() {
  //     print(response);
  //   });
  //   if (response.statusCode == 200) {
  //     return BookingSuccess();
  //   } else {
  //     return LinearProgressIndicator();
  //   }
  // }

  @override
  void initState() {
    // getFuel();
    // getModels();
    LoginCheck();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
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
          'Spare Do Buyer',
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 1.3, color: Theme.of(context).primaryColor)),
        ),
      ),
      body: Container(
        color: Colors.grey[50],
        height: MediaQuery.of(context).size.height * 0.875,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Form(
            key: _formKey,
            autovalidate: _autovalidate,
            child: ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          stops: [0.1, 0.9],
                          colors: [
                            Colors.grey[300],
                            Colors.grey[300]
                            // Colors.yellow[800],
                            // Colors.yellow[700],
                            // Colors.yellow[600],
                            // Colors.yellow[400],
                          ],
                        ),
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context).focusColor.withOpacity(0.3),
                              offset: Offset(0, 2),
                              blurRadius: 7.0)
                        ]),
                    child: DropdownButtonFormField(
                      validator: RequiredValidator(errorText: "Choose Model"),
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                      ),
                      // decoration: InputDecoration(
                      //   contentPadding: EdgeInsets.all(12.0),
                      //   enabledBorder: OutlineInputBorder(
                      //     borderRadius: const BorderRadius.all(
                      //       const Radius.circular(30.0),
                      //     ),
                      //     borderSide: BorderSide(
                      //         color: Theme.of(context).accentColor, width: 2.0),
                      //   ),
                      //   disabledBorder: OutlineInputBorder(
                      //     borderRadius: const BorderRadius.all(
                      //       const Radius.circular(30.0),
                      //     ),
                      //     borderSide: BorderSide(color: Colors.teal, width: 2.0),
                      //   ),
                      // ),
                      value: model,
                      hint: Text('Select Model'),
                      items: modelList.map((list2) {
                        return DropdownMenuItem(
                          child: Text(list2['name'].toString()),
                          value: list2['id'].toString(),
                        );
                      })?.toList(),
                      onChanged: (value3) {
                        setState(() {
                          //    getVariant(value3);
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          stops: [0.1, 0.9],
                          colors: [
                            Colors.grey[300],
                            Colors.grey[300]
                            // Colors.yellow[800],
                            // Colors.yellow[700],
                            // Colors.yellow[600],
                            // Colors.yellow[400],
                          ],
                        ),
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context).focusColor.withOpacity(0.3),
                              offset: Offset(0, 2),
                              blurRadius: 7.0)
                        ]),
                    child: DropdownButtonFormField(
                      //  validator: RequiredValidator(errorText: "Choose Variant"),
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                      ),
                      // decoration: InputDecoration(
                      //   contentPadding: EdgeInsets.all(12.0),
                      //   enabledBorder: OutlineInputBorder(
                      //     borderRadius: const BorderRadius.all(
                      //       const Radius.circular(30.0),
                      //     ),
                      //     borderSide: BorderSide(
                      //         color: Theme.of(context).accentColor, width: 2.0),
                      //   ),
                      //   disabledBorder: OutlineInputBorder(
                      //     borderRadius: const BorderRadius.all(
                      //       const Radius.circular(30.0),
                      //     ),
                      //     borderSide: BorderSide(color: Colors.teal, width: 2.0),
                      //   ),
                      // ),
                      value: variant,
                      hint: Text('Select Variant'),
                      items: variantList.map((list3) {
                        return DropdownMenuItem(
                          child: Text(list3['name']),
                          value: list3['id'].toString(),
                        );
                      }).toList(),
                      onChanged: (value3) {
                        setState(() {
                          //     variant=value3;

                          //  getYear(value3);
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          stops: [0.1, 0.9],
                          colors: [
                            Colors.grey[300],
                            Colors.grey[300]
                            // Colors.yellow[800],
                            // Colors.yellow[700],
                            // Colors.yellow[600],
                            // Colors.yellow[400],
                          ],
                        ),
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context).focusColor.withOpacity(0.3),
                              offset: Offset(0, 2),
                              blurRadius: 7.0)
                        ]),
                    child: DropdownButtonFormField(
                      //    validator: RequiredValidator(errorText: "Choose Year"),
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                      ),
                      // decoration: InputDecoration(
                      //   contentPadding: EdgeInsets.all(12.0),
                      //   enabledBorder: OutlineInputBorder(
                      //     borderRadius: const BorderRadius.all(
                      //       const Radius.circular(30.0),
                      //     ),
                      //     borderSide: BorderSide(
                      //         color: Theme.of(context).accentColor, width: 2.0),
                      //   ),
                      //   disabledBorder: OutlineInputBorder(
                      //     borderRadius: const BorderRadius.all(
                      //       const Radius.circular(30.0),
                      //     ),
                      //     borderSide: BorderSide(color: Colors.teal, width: 2.0),
                      //   ),
                      // ),
                      value: year,
                      hint: Text('Select Year'),
                      items: yearList.map((list4) {
                        return DropdownMenuItem(
                          child: Text(list4['name']),
                          value: list4['id'].toString(),
                        );
                      }).toList(),
                      onChanged: (value3) {
                        setState(() {
                          getYearId(value3);
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 25),
                  child: Theme(
                    data: new ThemeData(
                      primaryColor: Theme.of(context).accentColor,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            stops: [0.1, 0.9],
                            colors: [
                              Colors.grey[300],
                              Colors.grey[300]
                              // Colors.yellow[800],
                              // Colors.yellow[700],
                              // Colors.yellow[600],
                              // Colors.yellow[400],
                            ],
                          ),
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context).focusColor.withOpacity(0.3),
                                offset: Offset(0, 2),
                                blurRadius: 7.0)
                          ]),
                      child: new TextFormField(
                        validator: RequiredValidator(errorText: "Description Required"),
                        autofocus: false,
                        controller: _controller,
                        maxLines: 3,
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                          // contentPadding: EdgeInsets.all(12.0),
                          // focusedBorder: OutlineInputBorder(
                          //   borderRadius: const BorderRadius.all(
                          //     const Radius.circular(8.0),
                          //   ),
                          //   borderSide: BorderSide(
                          //       color: Theme.of(context).accentColor, width: 2.0),
                          // ),
                          // enabledBorder: OutlineInputBorder(
                          //   borderRadius: const BorderRadius.all(
                          //     const Radius.circular(8.0),
                          //   ),
                          //   borderSide: BorderSide(
                          //       color: Theme.of(context).accentColor, width: 2.0),
                          // ),
                          // disabledBorder: OutlineInputBorder(
                          //   borderRadius: const BorderRadius.all(
                          //     const Radius.circular(8.0),
                          //   ),
                          //   borderSide:
                          //       BorderSide(color: Colors.teal, width: 2.0),
                          // ),
                          labelText: "Description",
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Text('Select Fuel Type'),
                    ],
                  ),
                ),
                Container(
                  height: 110,
                  child: ListView.builder(
                      // scrollDirection: Axis.horizontal,
                      itemCount: fuelList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: RadioListTile(
                            value: fuelList[index]['id'],
                            groupValue: groupValue,
                            title: Text(fuelList[index]['name']),
                            onChanged: (newValue) {
                              setState(() {
                                groupValue = newValue;
                                //   getFuelId( newValue);
                                print(newValue);
                              });
                            },
                            activeColor: Theme.of(context).accentColor,
                            selected: false,
                          ),
                        );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: OutlineButton.icon(
                      onPressed: getImage,
                      icon: Icon(Icons.camera_alt_rounded),
                      label: _image1 == null ? Text(' Upload Image') : Text('1 Image Selecetd')),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: OutlineButton.icon(
                      onPressed: getImage,
                      icon: Icon(Icons.audiotrack),
                      label: Text('Record Voice')),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: BlockButtonWidget(
                    text: Text(
                      '                   Submit                  ',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      // if (_formKey.currentState.validate()) {
                      //   Scaffold.of(context).showSnackBar(
                      //       SnackBar(content: Text('Processing Data')));
                      // }

                      // print(selectedModelId);
                      // print(selectId);
                      //
                      // print(selectedvariant);
                      //
                      // print(_controller.text);
                      //
                      // book();
                      // print(groupValue);
                      _showMyDialog();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future BookingSuccess() {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: "Booking saved Success",
        onConfirmBtnTap: () {
          Navigator.of(context).pushReplacementNamed('/Pages', arguments: 0);
        });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Comming Soon!',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Launching on FEB-15 '),
                //  Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
