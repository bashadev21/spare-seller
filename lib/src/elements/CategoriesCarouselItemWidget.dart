import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sparedo_partner/base_url.dart';
import 'package:sparedo_partner/src/pages/brandListScreen.dart';
import 'package:localstorage/localstorage.dart';

import '../models/category.dart';

// ignore: must_be_immutable
class CategoriesCarouselItemWidget extends StatefulWidget {
  double marginLeft;
  Category category;

  CategoriesCarouselItemWidget({Key key, this.marginLeft, this.category})
      : super(key: key);

  @override
  _CategoriesCarouselItemWidgetState createState() =>
      _CategoriesCarouselItemWidgetState();
}

class _CategoriesCarouselItemWidgetState
    extends State<CategoriesCarouselItemWidget> {
  List categoryList = List();

  final LocalStorage storage = new LocalStorage("");

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      highlightColor: Colors.transparent,
      onTap: () {
        print('you clicked ${widget.category.id}');
        storage.setItem('category_id', widget.category.id.toString());
        storage.setItem('category_name', widget.category.name);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BrandList()));

        // Navigator.of(context).pushNamed('/CarScreen');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Hero(
            tag: widget.category.id,
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsetsDirectional.only(
                      start: this.widget.marginLeft, end: 0),
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.22,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  // child: Padding(
                  //   padding: const EdgeInsets.all(15),
                  //   child: widget.category.avatar.toLowerCase().endsWith('.svg')
                  //       ? SvgPicture.network(
                  //           widget.category.avatar,
                  //           color: Theme.of(context).accentColor,
                  //         )
                  //       // : CachedNetworkImage(
                  //       //     fit: BoxFit.cover,
                  //       //     imageUrl: category.image.icon,
                  //       //     placeholder: (context, url) => Image.asset(
                  //       //       'assets/img/loading.gif',
                  //       //       fit: BoxFit.cover,
                  //       //     ),
                  //       //     errorWidget: (context, url, error) => Icon(Icons.error),
                  //       //   ),
                  //   :
                  //
                  //
                  //   Center(child:  Image.network('http://192.168.1.147:8080/sparedo_partner/public/assets/category/${widget.category.avatar}'))
                  // ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.18,
                        width: MediaQuery.of(context).size.width * 0.80,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [0.1, 0.6],
                              colors: [
                                Color.fromRGBO(63, 83, 204, 0.8),
                                Color.fromRGBO(66, 200, 234, 0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.3),
                                  offset: Offset(0, 2),
                                  blurRadius: 7.0)
                            ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.12,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.09,
                                ),
                                Text(
                                  widget.category.name.toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.grey[100],
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  left: MediaQuery.of(context).size.width * 0.58,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.30,
                    width: MediaQuery.of(context).size.width * 0.30,
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.045,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.width * 0.27,
                          width: MediaQuery.of(context).size.width * 0.3,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [0.1, 0.6],
                              colors: [
                                Color.fromRGBO(44, 159, 210, 0.3),
                                Color.fromRGBO(66, 200, 234, 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(70),
                                bottomRight: Radius.circular(15)),
                          ),
                          // child: Padding(
                          //   padding: const EdgeInsets.only(
                          //       left: 20, right: 2, top: 20, bottom: 20),
                          // 'https://sparesdo.com/public/assets/category/${widget.category.avatar}',
                          // child: CachedNetworkImage(
                          //   imageUrl:
                          //       '${BaseUrl.category}${widget.category.avatar}',
                          //   color: Colors.white.withOpacity(0.7),
                          //   height: MediaQuery.of(context).size.height * 0.1,
                          //   width: MediaQuery.of(context).size.height * 0.1,
                          // ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Container(
          //   margin: EdgeInsetsDirectional.only(start: this.widget.marginLeft, end: 20),
          //   child: Text(
          //     widget.category.id,
          //     overflow: TextOverflow.ellipsis,
          //     style: Theme.of(context).textTheme.bodyText2,
          //   ),
          // ),
        ],
      ),
    );
  }
}
