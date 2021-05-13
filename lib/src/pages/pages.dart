import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:sparedo_partner/src/pages/favorites.dart';

import '../helpers/helper.dart';
import '../models/route_argument.dart';
import '../pages/home.dart';
import 'messages.dart';

// ignore: must_be_immutable
class PagesWidget extends StatefulWidget {
  dynamic currentTab;
  RouteArgument routeArgument;
  final String userName;
  Widget currentPage = HomeWidget();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  PagesWidget({Key key, this.currentTab, this.userName}) {
    if (currentTab != null) {
      if (currentTab is RouteArgument) {
        routeArgument = currentTab;
        currentTab = int.parse(currentTab.id);
      }
    } else {
      currentTab = 1;
    }
  }

  @override
  _PagesWidgetState createState() {
    return _PagesWidgetState();
  }
}

class _PagesWidgetState extends State<PagesWidget> {
  initState() {
    super.initState();
    _selectTab(widget.currentTab);
  }

  @override
  void didUpdateWidget(PagesWidget oldWidget) {
    _selectTab(oldWidget.currentTab);
    super.didUpdateWidget(oldWidget);
  }

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      switch (tabItem) {
        case 0:
          widget.currentPage = ProFileScreen();
          break;
        // case 1:
        //   widget.currentPage = MapWidget(parentScaffoldKey: widget.scaffoldKey, routeArgument: widget.routeArgument);
        //   break;
        case 1:
          widget.currentPage = HomeWidget(parentScaffoldKey: widget.scaffoldKey);

          break;
        // case 3:
        //   widget.currentPage = OrdersWidget(parentScaffoldKey: widget.scaffoldKey);
        //   break;
        case 2:
          widget.currentPage = MessagesWidget(parentScaffoldKey: widget.scaffoldKey);
          //FavoritesWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: Helper.of(context).onWillPop,
        child: Scaffold(
          key: widget.scaffoldKey,
          //  drawer: DrawerWidget(),
          // endDrawer: FilterWidget(onFilter: (filter) {
          //   Navigator.of(context)
          //       .pushReplacementNamed('/Pages', arguments: widget.currentTab);
          // }),
          body: widget.currentPage,
          bottomNavigationBar: FancyBottomNavigation(
            circleColor: Theme.of(context).accentColor,
            inactiveIconColor: Theme.of(context).accentColor,

            initialSelection: widget.currentTab,

            // type: BottomNavigationBarType.fixed,
            // selectedItemColor: Theme.of(context).accentColor,
            // selectedFontSize: 10,
            // unselectedFontSize: 10,
            // iconSize: 22,
            // elevation: 0,
            // backgroundColor: Colors.grey[300],
            // selectedIconTheme: IconThemeData(size: 28),
            // unselectedItemColor: Theme.of(context).focusColor.withOpacity(1),
            // currentIndex: widget.currentTab,
            // onTap: (int i) {
            //   this._selectTab(i);
            // },
            // // this will be set when a new tab is tapped
            // items: [
            //   BottomNavigationBarItem(
            //     icon: Icon(Icons.book),
            //     label: 'Bookings',
            //   ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.location_on),
            //   label: '',
            // ),

            // BottomNavigationBarItem(
            //   icon: new Icon(Icons.fastfood),
            //   label: '',
            // ),
            // BottomNavigationBarItem(
            //     label: 'Home',
            //     icon: Container(
            //       width: 42,
            //       height: 42,
            //       decoration: BoxDecoration(
            //         color: Theme.of(context).accentColor,
            //         borderRadius: BorderRadius.all(
            //           Radius.circular(50),
            //         ),
            //         boxShadow: [
            //           BoxShadow(
            //               color: Theme.of(context).accentColor.withOpacity(0.4),
            //               blurRadius: 40,
            //               offset: Offset(0, 15)),
            //           BoxShadow(
            //               color: Theme.of(context).accentColor.withOpacity(0.4),
            //               blurRadius: 13,
            //               offset: Offset(0, 3))
            //         ],
            //       ),
            //       child: new Icon(Icons.home, color: Theme.of(context).primaryColor),
            //     )),
            // BottomNavigationBarItem(
            //   icon: new Icon(Icons.chat),
            //   label: 'message',
            // ),

            // ],
            tabs: [
              TabData(iconData: Icons.person, title: "Profile"),
              TabData(iconData: Icons.home, title: "Home"),
              TabData(iconData: Icons.message, title: "Message"),
            ],
            onTabChangedListener: (int i) {
              this._selectTab(i);
            },
          ),
        ));
  }
}
