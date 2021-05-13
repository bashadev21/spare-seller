import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:sizer/sizer.dart';

typedef void BoolCallback(bool val);

class BaseAppBar extends StatefulWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  // BaseAppBar({Key key, this.parentScaffoldKey}) : super(key: key);
  final Text title;
  final AppBar appBar;
  final Function toggle;
  // final List<Widget> leading;
  // final IconButton widgets;

  /// you can add more fields that meet your needs

  BaseAppBar({
    Key key,
    this.title,
    this.appBar,
    this.toggle,
    // this.widgets,
    // this.leading,
    this.parentScaffoldKey,
  }) : super(key: key);

  @override
  _BaseAppBarState createState() => _BaseAppBarState();
}

class _BaseAppBarState extends State<BaseAppBar> {
  final Color backgroundColor = Colors.red;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isOn = false;
  bool status = false;
  @override
  Widget build(BuildContext context) {
    return AppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/img/2.png',
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.4,
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: FlutterSwitch(
              valueFontSize: 10.0.sp,
              toggleSize: 20.0.sp,
              value: status,
              borderRadius: 30.0.sp,
              activeColor: Colors.green,
              inactiveColor: Colors.red,
              padding: 5.0,
              showOnOff: true,
              onToggle: (val) {
                setState(() {
                  status = val;
                });
              },
            ),
          )
        ]
        // leading: InkWell(
        //   onTap: () {
        //     onPressed:
        //     () => _scaffoldKey.currentState.openDrawer();
        //   },
        //   child: new Icon(
        //     Icons.menu,
        //     color: Colors.green,
        //   ),
        // ),
        // leading: new IconButton(
        //   icon: new Icon(Icons.settings),
        //   onPressed: () => _scaffoldKey.currentState.openDrawer(),
        // ),
        // actions: <Widget>[
        //   //     Switch(
        //   //       value: isSwitched,
        //   //       onChanged: (value) {
        //   //         setState(() {
        //   //           isSwitched = value;
        //   //           print(isSwitched);
        //   //         });
        //   //       },
        //   //       activeTrackColor: Colors.lightGreenAccent,
        //   //       activeColor: Colors.green,
        //   //       inactiveTrackColor: Colors.red,
        //   //     ),
        // ],
        );
  }

  @override
  Size get preferredSize => new Size.fromHeight(widget.appBar.preferredSize.height);
}
