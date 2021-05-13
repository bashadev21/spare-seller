import 'package:flutter/material.dart';
import 'package:simple_time_range_picker/simple_time_range_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:sparedo_partner/src/elements/BlockButtonWidget.dart';
import 'package:sparedo_partner/src/elements/CustomAppbar.dart';

class ProFileScreen extends StatefulWidget {
  @override
  _ProFileScreenState createState() => _ProFileScreenState();
}

TimeOfDay _startTime;
TimeOfDay _endTime;
Map<String, bool> values = {
  'Sunday': false,
  'Monday': false,
  'Tuesday': false,
  'Wednesday': false,
  'Thursday': false,
  'friday': false,
  'Saturday': false,
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

class _ProFileScreenState extends State<ProFileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: Text('title'), appBar: AppBar()),
      body: ListView(
        children: [
          Container(
            height: 7.0.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Profile',
                  style: TextStyle(fontSize: 15.0.sp, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Container(
            height: 81.0.h,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  // FormBuilderFilterChip(
                  //   selectedColor: Theme.of(context).accentColor,
                  //   name: 'filter_chip',
                  //   decoration: InputDecoration(
                  //     labelText: 'Deal With',
                  //     labelStyle: TextStyle(color: Colors.black87),
                  //     border: InputBorder.none,
                  //   ),
                  //   spacing: 20,
                  //   options: [
                  //     FormBuilderFieldOption(
                  //         value: 'Car',
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: Text('Car'),
                  //         )),
                  //     FormBuilderFieldOption(
                  //         value: 'Bike',
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: Text('Bike'),
                  //         )),
                  //   ],
                  // ),
                  Container(
                    height: 8.0.h,
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Container(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  labelText: 'Name',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Container(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.location_on_rounded),
                                  labelText: 'Location',
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  Container(
                    height: 8.0.h,
                    child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.shopping_bag),
                        labelText: 'Shop Name',
                      ),
                    ),
                  ),
                  Container(
                    height: 8.0.h,
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Container(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.phone),
                                  labelText: 'Contact Number',
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Container(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.phone),
                                  labelText: 'Alternate Number',
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.5),
                    child: SizedBox(
                      height: 2.0.h,
                    ),
                  ),

                  Container(
                    height: 8.0.h,
                    child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.contact_phone_rounded),
                        labelText: 'Landline Number',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.5),
                    child: SizedBox(
                      height: 2.0.h,
                    ),
                  ),
                  new TextFormField(
                    maxLines: 3,
                    decoration: new InputDecoration(
                      border:
                          new OutlineInputBorder(borderSide: new BorderSide(color: Colors.teal)),
                      hintText: 'Description',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.5),
                    child: SizedBox(
                      height: 2.0.h,
                    ),
                  ),
                  Container(
                    height: 7.0.h,
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
                              style: TextStyle(fontSize: 10.0.sp),
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
                                  '66%',
                                  style: TextStyle(fontSize: 12.0.sp),
                                )),
                                decoration:
                                    BoxDecoration(border: Border.all(color: Colors.black87)),
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
                                    padding: const EdgeInsets.symmetric(horizontal: 50),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          flex: 2,
                                          fit: FlexFit.tight,
                                          child: InkWell(
                                            onTap: () => TimeRangePicker.show(
                                              context: context,
                                              onSubmitted: (TimeRangeValue value) {
                                                setState(() {
                                                  _startTime = value.startTime;
                                                  _endTime = value.endTime;
                                                });
                                              },
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.black87)),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Center(
                                                      child: Text(
                                                    '${_timeFormated(_startTime)}',
                                                    style: TextStyle(fontSize: 10.0.sp),
                                                  ))
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
                                            onTap: () => TimeRangePicker.show(
                                              context: context,
                                              onSubmitted: (TimeRangeValue value) {
                                                setState(() {
                                                  //  _startTime = value.startTime;
                                                  _endTime = value.endTime;
                                                });
                                              },
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.black87)),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Center(
                                                      child: Text(
                                                    '${_timeFormated(_endTime)}',
                                                    style: TextStyle(fontSize: 10.0.sp),
                                                  ))
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
                    height: 4.0.h,
                  ),
                  Text(
                    'Working Days:',
                    style: TextStyle(fontSize: 12.0.sp, fontWeight: FontWeight.w500),
                  ),
                  // RaisedButton(
                  //   child: Text(
                  //     " Get Selected Checkbox Items ",
                  //     style: TextStyle(fontSize: 18),
                  //   ),
                  //   onPressed: getCheckboxItems,
                  //   color: Colors.deepOrange,
                  //   textColor: Colors.white,
                  //   splashColor: Colors.grey,
                  //   padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  // ),
                  Expanded(
                    child: Container(
                      height: 60.0.h,
                      child: ListView(
                        physics: NeverScrollableScrollPhysics(),
                        children: values.keys.map((String key) {
                          return new CheckboxListTile(
                            title: new Text(key),
                            value: values[key],
                            activeColor: Theme.of(context).accentColor,
                            checkColor: Colors.white,
                            onChanged: (bool value) {
                              setState(() {
                                values[key] = value;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 3.0.h,
                  ),
                  BlockButtonWidget(
                    text: Text(
                      'NEXT',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w600, letterSpacing: 0.7),
                    ),
                    color: Theme.of(context).accentColor,
                    onPressed: () {},
                  ),
                  SizedBox(
                    height: 4.0.h,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  String _timeFormated(TimeOfDay time) {
    if (time == null) return "--:--";
    return "${time.hour}:${time.minute}";
  }
}
