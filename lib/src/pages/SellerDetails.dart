import 'dart:ui';

import 'package:flutter/material.dart';

class SellerDetails extends StatefulWidget {
  final int id;

  SellerDetails(
    this.id,
  );

  List sellerDetails = List();

  @override
  _SellerDetailsState createState() => _SellerDetailsState();
}

class _SellerDetailsState extends State<SellerDetails> {
  String SellerAmount;
  String bookid, sellerId, amount;
  int SellerId;
  List sellerDetails = List();
  List bidDetails = List();
  // Future SellerFunc() async {
  //   var response =
  //       await http.get('${BaseUrl.sellerDetails}${widget.id.toString()}');
  //
  //   var jsonBody = response.body;
  //   var data = json.decode(jsonBody);
  //   setState(() {
  //     data = data;
  //   });
  //
  //   this.sellerDetails = data['data'];
  //   print(this.sellerDetails);
  //   print('selllllllllllll');
  //   print(sellerDetails);
  // }

  // Future saveBid() async {
  //   var response = await http.post(BaseUrl.saveBid +
  //       'booking_id=' +
  //       widget.id.toString() +
  //       '&' +
  //       'seller_id=' +
  //       SellerId.toString() +
  //       '&' +
  //       'amount=' +
  //       SellerAmount);
  //   bookid = widget.id.toString();
  //   sellerId = SellerId.toString();
  //   amount = SellerAmount;
  //   print('bookid :' + widget.id.toString());
  //   print('sellerIddaaa :' + SellerId.toString());
  //   print('selleramount :' + SellerAmount);
  //   //  var response=await http.post('http://192.168.1.147:8080/sparedo_partner/public/api/save_bid?booking_id=${widget.id.toString()}&');
  //   var jsonBody = response.body;
  //   var data = json.decode(jsonBody);
  //   setState(() {
  //     data = data;
  //   });
  //
  //   // this.bidDetails = data['data'];
  //   // print(this.bidDetails);
  //   // print(bidDetails);
  //
  //   if (response.statusCode == 200) {
  //     Navigator.pushReplacement(context,
  //         MaterialPageRoute(builder: (context) => BookingDetails(widget.id)));
  //     Fluttertoast.showToast(
  //         msg: "Seller Saved Successfully",
  //         toastLength: Toast.LENGTH_LONG,
  //         gravity: ToastGravity.TOP,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.green,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //
  //     print('response body : ${response.body}');
  //     try {
  //       json.decode(response.body);
  //       print('trying to decode  Respose Body result is : success');
  //     } catch (Ex) {
  //       print("Exepition with json decode : $Ex");
  //     }
  //   }
  //   return response;
  // }
  //
  // @override
  // void initState() {
  //   SellerFunc();
  //   // SellerFunc();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        leading: new IconButton(
          icon:
              new Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Seller Details',
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(
              letterSpacing: 1.3, color: Theme.of(context).primaryColor)),
        ),
      ),
      body: (Container(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                child: Row(
                  children: [
                    Flexible(
                      flex: 7,
                      fit: FlexFit.tight,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Seller ',
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .merge(TextStyle(
                                      color: Theme.of(context).primaryColor)),
                            ),
                            Text(
                              'Name',
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .merge(TextStyle(
                                      color: Theme.of(context).primaryColor)),
                            ),
                          ],
                        ),
                        height: MediaQuery.of(context).size.height * 0.1,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      fit: FlexFit.tight,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        color: Theme.of(context).accentColor,
                        child: Center(
                          child: Text(
                            'Rs.(₹)',
                            style: Theme.of(context).textTheme.headline6.merge(
                                TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          ),
                        ),
                      ),
                    ),

                    Flexible(
                      flex: 5,
                      fit: FlexFit.tight,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        color: Theme.of(context).accentColor,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Return ',
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .merge(TextStyle(
                                      color: Theme.of(context).primaryColor)),
                            ),
                            Text(
                              'Days',
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .merge(TextStyle(
                                      color: Theme.of(context).primaryColor)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      fit: FlexFit.tight,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        color: Theme.of(context).accentColor,
                        child: Center(
                          child: Text(
                            'Action',
                            style: Theme.of(context).textTheme.headline6.merge(
                                TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          ),
                        ),
                      ),
                    ),
                    // Column(
                    //   children: [
                    //     Text(
                    //       'Seller ',
                    //       style: Theme.of(context).textTheme.headline6.merge(
                    //           TextStyle(color: Theme.of(context).primaryColor)),
                    //     ),
                    //     Text(
                    //       'Name',
                    //       style: Theme.of(context).textTheme.headline6.merge(
                    //           TextStyle(color: Theme.of(context).primaryColor)),
                    //     ),
                    //   ],
                    // ),
                    // Text(
                    //   '     Rs.(₹)',
                    //   style: Theme.of(context).textTheme.headline6.merge(
                    //       TextStyle(color: Theme.of(context).primaryColor)),
                    // ),
                    // Column(
                    //   children: [
                    //     Text(
                    //       'Return ',
                    //       style: Theme.of(context).textTheme.headline6.merge(
                    //           TextStyle(color: Theme.of(context).primaryColor)),
                    //     ),
                    //     Text(
                    //       'Days',
                    //       style: Theme.of(context).textTheme.headline6.merge(
                    //           TextStyle(color: Theme.of(context).primaryColor)),
                    //     ),
                    //   ],
                    // ),
                    // Text(
                    //   'Action',
                    //   style: Theme.of(context).textTheme.headline6.merge(
                    //       TextStyle(color: Theme.of(context).primaryColor)),
                    // ),
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.77,
              child: ListView(children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.77,
                  child: sellerDetails.length > 0
                      ? ListView.builder(
                          itemCount: sellerDetails.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 5),
                              child: Container(
                                decoration: BoxDecoration(boxShadow: [
                                  new BoxShadow(
                                    color: Colors.black54,
                                    blurRadius: 2.0,
                                  ),
                                ], borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    Flexible(
                                        flex: 7,
                                        fit: FlexFit.tight,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.0),
                                                bottomLeft:
                                                    Radius.circular(10.0)),
                                            color: Colors.grey[100],
                                          ),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.08,
                                          child: Center(
                                              child: Text(
                                            sellerDetails[index]['name'],
                                            overflow: TextOverflow.fade,
                                            maxLines: 1,
                                            style: TextStyle(fontSize: 16),
                                          )),
                                        )),
                                    Flexible(
                                        flex: 5,
                                        fit: FlexFit.tight,
                                        child: Container(
                                          child: Center(
                                            child: Text(
                                              sellerDetails[index]['amount'],
                                              overflow: TextOverflow.fade,
                                              maxLines: 1,
                                              style: TextStyle(fontSize: 17),
                                            ),
                                          ),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.08,
                                          color: Colors.grey[100],
                                        )),
                                    Flexible(
                                        flex: 5,
                                        fit: FlexFit.tight,
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.08,
                                          color: Colors.grey[100],
                                          child: Center(
                                            child: Text(
                                              sellerDetails[index]
                                                  ['return_days'],
                                              overflow: TextOverflow.fade,
                                              maxLines: 1,
                                              style: TextStyle(fontSize: 17),
                                            ),
                                          ),
                                        )),
                                    Flexible(
                                        flex: 5,
                                        fit: FlexFit.tight,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10.0),
                                                bottomRight:
                                                    Radius.circular(10.0)),
                                            color: Colors.grey[100],
                                          ),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.08,
                                          child: IconButton(
                                              icon: Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                                size: 30,
                                              ),
                                              onPressed: () {
                                                SellerId = sellerDetails[index]
                                                    ['seller_id'];
                                                SellerAmount =
                                                    sellerDetails[index]
                                                        ['amount'];

                                                _showMyDialog();
                                              }),
                                        )),
                                  ],
                                ),
                              ),
                            );
                          }

                          // itemBuilder: (context, index) => Padding(
                          //     padding: EdgeInsets.all(8.0),
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //       children: [
                          //         Text(sellerDetails[index]['name']),
                          //         Text(sellerDetails[index]['amount']),
                          //         Text(sellerDetails[index]['return_days']),
                          //         InkWell(
                          //             onTap: () {
                          //               SellerId = sellerDetails[index]['seller_id'];
                          //               SellerAmount = sellerDetails[index]['amount'];
                          //
                          //               _showMyDialog();
                          //             },
                          //             child: Icon(
                          //               Icons.check_circle,
                          //               color: Colors.green,
                          //             )),
                          //       ],
                          //     )),
                          )
                      : Center(child: CircularProgressIndicator()),
                ),
              ]),
            ),
          ],
        ),
      )),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you select this Seller?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Select',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                //   saveBid();
              },
            ),
          ],
        );
      },
    );
  }
}
