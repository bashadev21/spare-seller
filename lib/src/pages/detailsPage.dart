import 'dart:async';
import 'dart:convert';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:sparedo_partner/base_url.dart';
import 'package:sparedo_partner/src/elements/CustomAppbar.dart';
import 'package:sparedo_partner/src/pages/login.dart';

typedef void OnError(Exception exception);
var kUrl = "https://sparesdo.com/public/assets/booking_voice_note/9/602b8b42860f0bookingVoice.wav";

class DeatilsPage extends StatefulWidget {
  final int id;

  DeatilsPage(this.id);

  //final GlobalKey<ScaffoldState> parentScaffoldKey;

//  DeatilsPage({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _DeatilsPageState createState() => _DeatilsPageState();
}

enum PlayerState { stopped, playing, paused }

class _DeatilsPageState extends State<DeatilsPage> {
  Duration duration;
  Duration position;

  AudioPlayer audioPlayer;

  String localFilePath;

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  get durationText => duration != null ? duration.toString().split('.').first : '';

  get positionText => position != null ? position.toString().split('.').first : '';

  bool isMuted = false;

  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;

  List bookingDetails = List();
  // AudioPlayer audioPlayer = AudioPlayer();
  // AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  List image = List();
  List voice = List();
  final _amountController = TextEditingController();
  final _rDaysController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  List bookingList = List();
  String _currentAddress = "", bookinIdR;
  String selectedBooking = '';
  int respon;
  String UserId;
  final imageList = [
    'assets/img/car.png',
    'assets/img/car.png',
    'assets/img/car.png',
  ];

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

  Future getbookings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.get('user_id'));
    final userId = (prefs.get('user_id'));
    UserId = userId;
    print("user" + UserId);
    var response = await http.get(
        BaseUrl.booking_details + 'user_id=' + UserId + '&' + 'booking_id=' + widget.id.toString());
    var jsonBody = response.body;
    var data = json.decode(jsonBody);
    setState(() {
      data = data;
      print(data['data']);
    });

    this.bookingDetails = data['data']['details'];
    print(this.bookingDetails);
    print('listttttda');
    print(this.bookingDetails);

    this.image = data['data']['image'];
    print(this.image);
    print('listtimage');

    print(this.image);

    this.voice = data['data']['voice'];
    print(this.voice);
    print('listtvoice');
    print(this.voice);

    if (response.statusCode == 200) {
      print('response body : ${response.body}');
      try {
        json.decode(response.body);
        print('trying to decode  Respose Body result isssssss : success');
      } catch (Ex) {
        print("Exepition with json decode : $Ex");
      }
    }
    print(response);
    return response;
  }

  Future BidBook() async {
    // var bookiId= bookingList[index]['id'].toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.getString('user_id');
    setState(() {
      var current_user = (prefs.getString('user_id') ?? '');
      UserId = prefs.getString('user_id');
    });
    var response = await http.post(BaseUrl.save_qoute +
        'seller_id=' +
        UserId +
        '&' +
        'amount=' +
        _amountController.text +
        '&' +
        'return_days=' +
        _rDaysController.text +
        '&' +
        'booking_id=' +
        widget.id.toString());
    json.decode(response.body);

    setState(() {
      print(response);
    });
    print('statusCodee : ' + response.statusCode.toString());

    if (response.statusCode == 200) {
      qouteAdded();

      print('response body : ${response.body}');
      try {
        json.decode(response.body);
        print('trying to decode  Respose Body result issssss : success');
      } catch (Ex) {
        print("Exepition with json decode : $Ex");
      }
    }
    return response;
  }

  @override
  void initState() {
    getbookings();
    LoginCheck();
    initAudioPlayer();
    LoginCheck();
    super.initState();
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
    super.dispose();
  }

  void initAudioPlayer() {
    audioPlayer = AudioPlayer();
    _positionSubscription =
        audioPlayer.onAudioPositionChanged.listen((p) => setState(() => position = p));
    _audioPlayerStateSubscription = audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        setState(() => duration = audioPlayer.duration);
      } else if (s == AudioPlayerState.STOPPED) {
        onComplete();
        setState(() {
          position = duration;
        });
      }
    }, onError: (msg) {
      setState(() {
        playerState = PlayerState.stopped;
        duration = Duration(seconds: 0);
        position = Duration(seconds: 0);
      });
    });
  }

  Future play(id, voice) async {
    var ss = BaseUrl.voice + '/assets/booking_voice_note/' + id + '/' + voice;
    await audioPlayer.play(ss);

    setState(() {
      playerState = PlayerState.playing;
    });
  }

  Future _playLocal() async {
    await audioPlayer.play(localFilePath, isLocal: true);
    setState(() => playerState = PlayerState.playing);
  }

  Future pause() async {
    await audioPlayer.pause();
    setState(() => playerState = PlayerState.paused);
  }

  Future stop() async {
    await audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      position = Duration();
    });
  }

  Future mute(bool muted) async {
    await audioPlayer.mute(muted);
    setState(() {
      isMuted = muted;
    });
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  floatingActionButton:
      backgroundColor: Colors.white,
      appBar: BaseAppBar(
        title: Text('title'),
        appBar: AppBar(),
        // widgets: <Widget>[Icon(Icons.more_vert)],
      ),

      // appBar: AppBar(
      //   leading: new IconButton(
      //     icon: new Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      //   automaticallyImplyLeading: false,
      //   backgroundColor: Colors.grey[900],
      //   elevation: 0,
      //   centerTitle: true,
      //   // title: ValueListenableBuilder(
      //   //   valueListenable: settingsRepo.setting,
      //   //   builder: (context, value, child) {
      //   //     return Text(
      //   //       value.appName ?? S.of(context).home,
      //   //       style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
      //   //     );
      //   //   },
      //   // ),
      //   title: Text('Spare Do Seller',
      //       style: Theme.of(context)
      //           .textTheme
      //           .headline6
      //           .merge(TextStyle(letterSpacing: 1.3, color: Theme.of(context).primaryColor))),
      //
      //   // actions: <Widget>[
      //   //   new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
      //   // ],
      // ),
      body: ListView(
          //  height: MediaQuery.of(context).size.height * 0.99,
          children: [
            Container(
              height: 7.0.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Booking Details',
                    style: TextStyle(
                        fontSize: 15.0.sp, color: Colors.black87, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.89,
                child: bookingDetails.length > 0
                    ? ListView.builder(
                        itemCount: bookingDetails.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.89,
                            child: ListView(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Container(
                                      height: MediaQuery.of(context).size.height * 0.28,
                                      color: Colors.white,
                                      //  child: Text("${image[index]['image']}"),
                                      child: image.length == 0
                                          ? Image.asset('assets/img/no image 1.jpg')
                                          : Image.network(
                                              "https://sparesdo.com/public/assets/booking_images/${bookingDetails[index]['id']}/${image[index]['image']}",
                                              fit: BoxFit.contain,
                                            ),
                                    )),
                                SizedBox(
                                  height: 3.0.h,
                                ),
                                Container(
                                  height: 7.0.h,
                                  width: 99.0.w,
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: Container(
                                          height: 6.0.h,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 12.0.w,
                                              ),
                                              Text(
                                                'Booking ID',
                                                style: TextStyle(
                                                    color: Theme.of(context).accentColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12.0.sp),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: Container(
                                          height: 6.0.h,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                bookingDetails[index]['id'].toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 13, fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 7.0.h,
                                  width: 99.0.w,
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: Container(
                                          height: 6.0.h,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 12.0.w,
                                              ),
                                              Text(
                                                'Buyer Name',
                                                style: TextStyle(
                                                    color: Theme.of(context).accentColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12.0.sp),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: Container(
                                          height: 6.0.h,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                bookingDetails[index]['buyer_name'].toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 13, fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 7.0.h,
                                  width: 99.0.w,
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: Container(
                                          height: 6.0.h,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 12.0.w,
                                              ),
                                              Text(
                                                'State',
                                                style: TextStyle(
                                                    color: Theme.of(context).accentColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12.0.sp),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: Container(
                                          height: 6.0.h,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                bookingDetails[index]['category'].toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 13, fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 7.0.h,
                                  width: 99.0.w,
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: Container(
                                          height: 6.0.h,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 12.0.w,
                                              ),
                                              Text(
                                                'District',
                                                style: TextStyle(
                                                    color: Theme.of(context).accentColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12.0.sp),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: Container(
                                          height: 6.0.h,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                bookingDetails[index]['category'].toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 13, fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 7.0.h,
                                  width: 99.0.w,
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: Container(
                                          height: 6.0.h,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 12.0.w,
                                              ),
                                              Text(
                                                'City',
                                                style: TextStyle(
                                                    color: Theme.of(context).accentColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12.0.sp),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: Container(
                                          height: 6.0.h,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                bookingDetails[index]['category'].toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 13, fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Container(
                                //   height: 7.0.h,
                                //   width: 99.0.w,
                                //   child: Row(
                                //     children: [
                                //       Flexible(
                                //         flex: 1,
                                //         fit: FlexFit.tight,
                                //         child: Container(
                                //           height: 6.0.h,
                                //           child: Column(
                                //             children: [
                                //               Text(
                                //                 'Buyer Name',
                                //                 style: TextStyle(
                                //                     color: Theme.of(context).accentColor,
                                //                     fontWeight: FontWeight.w500,
                                //                     fontSize: 12.0.sp),
                                //               )
                                //             ],
                                //           ),
                                //         ),
                                //       ),
                                //       Flexible(
                                //         flex: 1,
                                //         fit: FlexFit.tight,
                                //         child: Container(
                                //           height: 6.0.h,
                                //           child: Column(
                                //             crossAxisAlignment: CrossAxisAlignment.start,
                                //             children: [
                                //               Text(
                                //                 bookingDetails[index]['buyer_name'].toString(),
                                //                 overflow: TextOverflow.ellipsis,
                                //                 style: TextStyle(
                                //                     fontSize: 13, fontWeight: FontWeight.w600),
                                //               ),
                                //             ],
                                //           ),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                Container(
                                  height: 7.0.h,
                                  width: 99.0.w,
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: Container(
                                          height: 6.0.h,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 12.0.w,
                                              ),
                                              Text(
                                                'Category',
                                                style: TextStyle(
                                                    color: Theme.of(context).accentColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12.0.sp),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: Container(
                                          height: 6.0.h,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                bookingDetails[index]['category'].toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 13, fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Container(
                                //   height: 7.0.h,
                                //   width: 99.0.w,
                                //   child: Row(
                                //     children: [
                                //       Flexible(
                                //         flex: 1,
                                //         fit: FlexFit.tight,
                                //         child: Container(
                                //           height: 6.0.h,
                                //           child: Column(
                                //             children: [
                                //               Text(
                                //                 'Location',
                                //                 style: TextStyle(
                                //                     color: Theme.of(context).accentColor,
                                //                     fontWeight: FontWeight.w500,
                                //                     fontSize: 12.0.sp),
                                //               )
                                //             ],
                                //           ),
                                //         ),
                                //       ),
                                //       Flexible(
                                //         flex: 1,
                                //         fit: FlexFit.tight,
                                //         child: Container(
                                //           height: 6.0.h,
                                //           child: Column(
                                //             crossAxisAlignment: CrossAxisAlignment.start,
                                //             children: [
                                //               Text(
                                //                 bookingDetails[index]['location_name']
                                //                         .toString() ??
                                //                     '',
                                //                 overflow: TextOverflow.ellipsis,
                                //                 style: TextStyle(
                                //                     fontSize: 13, fontWeight: FontWeight.w600),
                                //               ),
                                //             ],
                                //           ),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                Container(
                                  height: 7.0.h,
                                  width: 99.0.w,
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: Container(
                                          height: 6.0.h,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 12.0.w,
                                              ),
                                              Text(
                                                'Brand',
                                                style: TextStyle(
                                                    color: Theme.of(context).accentColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12.0.sp),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: Container(
                                          height: 6.0.h,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                bookingDetails[index]['brand'].toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 13, fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 7.0.h,
                                  width: 99.0.w,
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: Container(
                                          height: 6.0.h,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 12.0.w,
                                              ),
                                              Text(
                                                'Model',
                                                style: TextStyle(
                                                    color: Theme.of(context).accentColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12.0.sp),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: Container(
                                          height: 6.0.h,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                bookingDetails[index]['model'].toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 13, fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 7.0.h,
                                  width: 99.0.w,
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: Container(
                                          height: 6.0.h,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 12.0.w,
                                              ),
                                              Text(
                                                'Variant',
                                                style: TextStyle(
                                                    color: Theme.of(context).accentColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12.0.sp),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: Container(
                                          height: 6.0.h,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                bookingDetails[index]['variant'].toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 13, fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 7.0.h,
                                  width: 99.0.w,
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: Container(
                                          height: 6.0.h,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 12.0.w,
                                              ),
                                              Text(
                                                'Year',
                                                style: TextStyle(
                                                    color: Theme.of(context).accentColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12.0.sp),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: Container(
                                          height: 6.0.h,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                bookingDetails[index]['year'].toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 13, fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 7.0.h,
                                  width: 99.0.w,
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: Container(
                                          height: 6.0.h,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 12.0.w,
                                              ),
                                              Text(
                                                'Fuel',
                                                style: TextStyle(
                                                    color: Theme.of(context).accentColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12.0.sp),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.tight,
                                        child: Container(
                                          height: 6.0.h,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                bookingDetails[index]['fuel'].toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 13, fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  height: 2.0.h,
                                ),
                                bookingDetails[index]['description'] == null
                                    ? Container()
                                    : Container(
                                        width: 99.0.w,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              flex: 1,
                                              fit: FlexFit.tight,
                                              child: Container(
                                                height: 6.0.h,
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 12.0.w,
                                                    ),
                                                    Column(
                                                      children: [
                                                        Row(
                                                          children: [],
                                                        ),
                                                        Text(
                                                          'Description',
                                                          style: TextStyle(
                                                              color: Theme.of(context).accentColor,
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 12.0.sp),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 1,
                                              fit: FlexFit.tight,
                                              child: Padding(
                                                padding: const EdgeInsets.only(right: 3),
                                                child: Container(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        bookingDetails[index]['description']
                                                                .toString() ??
                                                            '',
                                                        //  Text(
                                                        //   'hddddddddddddddddddddddddddddddddddddddddddddddddddgggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggdddddddddddddddddddddd',
                                                        maxLines: 100,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w500),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                voice.length == 0
                                    ? Container()
                                    : Container(
                                        height: 8.0.h,
                                        width: 99.0.w,
                                        child: Row(
                                          children: [
                                            Flexible(
                                              flex: 1,
                                              fit: FlexFit.tight,
                                              child: Container(
                                                height: 6.0.h,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Voice Recording',
                                                      style: TextStyle(
                                                          color: Theme.of(context).accentColor,
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 12.0.sp),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 1,
                                              fit: FlexFit.tight,
                                              child: Container(
                                                height: 6.0.h,
                                                child:
                                                    Row(mainAxisSize: MainAxisSize.min, children: [
                                                  IconButton(
                                                    onPressed: isPlaying
                                                        ? null
                                                        : () => play(
                                                            bookingDetails[index]['id'].toString(),
                                                            voice[index]['voice'].toString()),
                                                    iconSize: 25.0.sp,
                                                    icon: Icon(Icons.play_arrow),
                                                    color: Theme.of(context).accentColor,
                                                  ),
                                                  IconButton(
                                                    onPressed: isPlaying ? () => pause() : null,
                                                    iconSize: 25.0.sp,
                                                    icon: Icon(Icons.pause),
                                                    color: Theme.of(context).accentColor,
                                                  ),
                                                  IconButton(
                                                    onPressed:
                                                        isPlaying || isPaused ? () => stop() : null,
                                                    iconSize: 25.0.sp,
                                                    icon: Icon(Icons.stop),
                                                    color: Theme.of(context).accentColor,
                                                  ),
                                                ]),
                                                // child: Row(
                                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                                //   children: [
                                                //     GestureDetector(
                                                //       onTap: () {
                                                //         // onPlayAudio(
                                                //         //     bookingDetails[index]['id']
                                                //         //         .toString(),
                                                //         //     voice[index]['voice'].toString());
                                                //       },
                                                //       child: CircleAvatar(
                                                //         child: Icon(
                                                //           Icons.play_arrow,
                                                //         ),
                                                //       ),
                                                //     ),
                                                //   ],
                                                // ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                voice.length == 0
                                    ? Container()
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            height: 80,
                                            child: Column(
                                              children: [
                                                if (duration != null)
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 10.0.sp, left: 10.0.sp),
                                                    child: SliderTheme(
                                                      data: SliderTheme.of(context).copyWith(
                                                        valueIndicatorColor: Colors
                                                            .blue, // This is what you are asking for
                                                        trackHeight: 0.5,
                                                        inactiveTrackColor:
                                                            Color(0xFF8D8E98), // Custom Gray Color
                                                        activeTrackColor:
                                                            Theme.of(context).accentColor,
                                                        thumbColor: Theme.of(context).accentColor,
                                                        overlayColor: Theme.of(context)
                                                            .accentColor, // Custom Thumb overlay Color
                                                        thumbShape: RoundSliderThumbShape(
                                                            enabledThumbRadius: 6.0),
                                                        overlayShape: RoundSliderOverlayShape(
                                                            overlayRadius: 20.0),
                                                      ),
                                                      child: Slider(
                                                          value: position?.inMilliseconds
                                                                  ?.toDouble() ??
                                                              0.0,
                                                          onChanged: (double value) {
                                                            return audioPlayer.seek(
                                                                (value / 1000).roundToDouble());
                                                          },
                                                          min: 0.0,
                                                          max: duration.inMilliseconds.toDouble()),
                                                    ),
                                                  ),
                                                Text(
                                                  position != null
                                                      ? "${positionText ?? ''} / ${durationText ?? ''}"
                                                      : duration != null
                                                          ? durationText
                                                          : '',
                                                  style: TextStyle(fontSize: 10.0.sp),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                // Material(child: _buildPlayer()),
                                // if (!kIsWeb)
                                //   localFilePath != null ? Text(localFilePath) : Container(),
                                // if (!kIsWeb)

                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                //     children: [
                                //       // RaisedButton(
                                //       //   onPressed: () => _loadFile(),
                                //       //   child: Text('Download'),
                                //       // ),
                                //       if (localFilePath != null)
                                //         RaisedButton(
                                //           onPressed: () => _playLocal(),
                                //           child: Text('play local'),
                                //         ),
                                //     ],
                                //   ),
                                // ),

                                // bookingDetails.isNotEmpty
                                //     ? bookingDetails[0]['hide_status'] == 0
                                //         ? InkWell(
                                //             onTap: () {
                                //               //  _showMyDialog();
                                //             },
                                //             child: Padding(
                                //               padding: const EdgeInsets.symmetric(horizontal: 50),
                                //               child: Container(
                                //                 child: Center(
                                //                     child: Row(
                                //                   mainAxisAlignment:
                                //                       MainAxisAlignment.spaceEvenly,
                                //                   children: [
                                //                     Text(
                                //                       'Bid',
                                //                       style: TextStyle(
                                //                           color: Colors.black87,
                                //                           fontSize: 18,
                                //                           letterSpacing: 1,
                                //                           fontWeight: FontWeight.w500),
                                //                     ),
                                //                   ],
                                //                 )),
                                //                 width: MediaQuery.of(context).size.width * 0.50,
                                //                 decoration: BoxDecoration(
                                //                     color: Theme.of(context).accentColor,
                                //                     borderRadius: BorderRadius.circular(10)),
                                //                 height:
                                //                     MediaQuery.of(context).size.height * 0.065,
                                //               ),
                                //             ),
                                //           )
                                //         : InkWell(
                                //             onTap: null,
                                //             child: Padding(
                                //               padding: const EdgeInsets.symmetric(horizontal: 50),
                                //               child: Container(
                                //                 child: Center(
                                //                     child: Row(
                                //                   mainAxisAlignment: MainAxisAlignment.center,
                                //                   children: [
                                //                     Text(
                                //                       " Done",
                                //                       style: TextStyle(
                                //                           color: Colors.white,
                                //                           fontSize: 18,
                                //                           letterSpacing: 1,
                                //                           fontWeight: FontWeight.w500),
                                //                     ),
                                //                   ],
                                //                 )),
                                //                 width: MediaQuery.of(context).size.width * 0.30,
                                //                 decoration: BoxDecoration(
                                //                     color: Colors.grey[400],
                                //                     borderRadius: BorderRadius.circular(10)),
                                //                 height:
                                //                     MediaQuery.of(context).size.height * 0.065,
                                //               ),
                                //             ),
                                //           )
                                //     : Center(
                                //         child: SpinKitThreeBounce(
                                //           color: Theme.of(context).accentColor,
                                //         ),
                                //       ),

                                bookingDetails.isNotEmpty
                                    ? bookingDetails[0]['hide_status'] == 0
                                        ? InkWell(
                                            onTap: () {
                                              _showMyDialog();
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 50),
                                              child: Container(
                                                child: Center(
                                                    child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Text(
                                                      'Bid',
                                                      style: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 18,
                                                          letterSpacing: 1,
                                                          fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                )),
                                                width: MediaQuery.of(context).size.width * 0.50,
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context).accentColor,
                                                    borderRadius: BorderRadius.circular(10)),
                                                height: MediaQuery.of(context).size.height * 0.065,
                                              ),
                                            ),
                                          )
                                        : InkWell(
                                            onTap: null,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 50),
                                              child: Container(
                                                child: Center(
                                                    child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      " Done",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          letterSpacing: 1,
                                                          fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                )),
                                                width: MediaQuery.of(context).size.width * 0.30,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[400],
                                                    borderRadius: BorderRadius.circular(10)),
                                                height: MediaQuery.of(context).size.height * 0.065,
                                              ),
                                            ),
                                          )
                                    : Center(
                                        child: SpinKitThreeBounce(
                                        color: Theme.of(context).accentColor,
                                      )),
                                SizedBox(
                                  height: 80,
                                ),

                                // Padding(
                                //     padding: const EdgeInsets.all(0.0),
                                //     child: Container(
                                //         height: MediaQuery.of(context).size.height * 0.28,
                                //         color: Colors.grey[200],
                                //         child: Image.network(
                                //           "https://sparesdo.com/public/assets/booking_images/${bookingList[index]['id']}/${bookingList[index]['image']}" ??
                                //               '',
                                //           fit: BoxFit.contain,
                                //         ))),
                              ],
                            ),
                          );
                        })
                    : Center(
                        child: SpinKitThreeBounce(
                          color: Theme.of(context).accentColor,
                        ),
                      )),
          ]),

      // body: Container(
      //   child: ListView(
      //     children: [
      //       Container(
      //           height: MediaQuery.of(context).size.height * 0.35,
      //           color: Colors.blue,
      //           child: PhotoViewGallery.builder(
      //               itemCount: imageList.length,
      //               builder: (context, index) {
      //                 return PhotoViewGalleryPageOptions(
      //                     imageProvider: AssetImage(
      //                   imageList[index],
      //                 ));
      //               })),
      //     ],
      //   ),
      // ));
    );
  }

  _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Container(
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    height: MediaQuery.of(context).size.height * 0.40,
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: Form(
                      key: _formKey,
                      child: KeyboardAvoider(
                        autoScroll: true,
                        child: ListView(
                          controller: _scrollController,
                          children: [
                            Container(
                              child: Center(
                                  child: Text(
                                'Bid',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20, color: Colors.white),
                              )),
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15), topLeft: Radius.circular(15)),
                              ),
                              height: MediaQuery.of(context).size.height * 0.08,
                            ),
                            Container(
                              height: 31.0.h,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30),
                                    child: TextFormField(
                                      keyboardType: TextInputType.phone,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                      ], // Only numbers can be entered // Only numbers can be entered
                                      validator: RequiredValidator(errorText: "Amount is required"),
                                      // obscureText: _con.hidePassword,
                                      //  onSaved: (input) => _con.user.password = input,
                                      //  validator: (input) => input.length < 6 ? S.of(context).should_be_more_than_6_letters : null,
                                      controller: _amountController,
                                      decoration: InputDecoration(
                                        counterText: '',
                                        prefixText: '₹ ',

                                        labelText: 'Amount',

                                        labelStyle: TextStyle(color: Colors.black87),
                                        contentPadding: EdgeInsets.all(12),
                                        //  hintText: S.of(context).john_doe,
                                        hintStyle: TextStyle(
                                            color: Theme.of(context).focusColor.withOpacity(0.7)),
                                        prefixIcon: Icon(Icons.monetization_on,
                                            color: Theme.of(context).accentColor),
                                        //   border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black87)),
                                        // enabledBorder:
                                        //     OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30),
                                    child: TextFormField(
                                      controller: _rDaysController,
                                      maxLength: 10,
                                      keyboardType: TextInputType.phone,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                      ], // Only numbers can be entered // Only numbers can be entered
                                      validator: RequiredValidator(errorText: "Days is required"),
                                      //validator: RequiredValidator(errorText: "username is required"),
                                      // validator: (input) => input.length < 3 ? S.of(context).should_be_more_than_3_letters : null,
                                      decoration: InputDecoration(
                                        counterText: '',

                                        labelText: 'Return Days',

                                        labelStyle: TextStyle(color: Colors.black87),
                                        contentPadding: EdgeInsets.all(12),
                                        //  hintText: S.of(context).john_doe,
                                        hintStyle: TextStyle(
                                            color: Theme.of(context).focusColor.withOpacity(0.7)),
                                        prefixIcon: Icon(Icons.calendar_today,
                                            color: Theme.of(context).accentColor),
                                        //   border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black87)),
                                        // enabledBorder:
                                        //     OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 2.0.h),

                                  // Row(
                                  //   children: [
                                  //     Flexible(
                                  //       flex: 1,
                                  //       child: Padding(
                                  //         padding: const EdgeInsets.all(3.0),
                                  //         child: Container(
                                  //           height: 10.0.h,
                                  //           child: Padding(
                                  //             padding: const EdgeInsets.symmetric(
                                  //                 horizontal: 10, vertical: 0),
                                  //             child: TextFormField(
                                  //               keyboardType: TextInputType.number,
                                  //               validator: RequiredValidator(
                                  //                   errorText: "Amount is required"),
                                  //               // obscureText: _con.hidePassword,
                                  //               //  onSaved: (input) => _con.user.password = input,
                                  //               //  validator: (input) => input.length < 6 ? S.of(context).should_be_more_than_6_letters : null,
                                  //               controller: _amountController,
                                  //               decoration: InputDecoration(
                                  //                 counterText: '',
                                  //                 prefixText: 'Rs.',
                                  //
                                  //                 labelText: 'Amount',
                                  //
                                  //                 labelStyle: TextStyle(color: Colors.black87),
                                  //                 contentPadding: EdgeInsets.all(12),
                                  //                 //  hintText: S.of(context).john_doe,
                                  //                 hintStyle: TextStyle(
                                  //                     color: Theme.of(context)
                                  //                         .focusColor
                                  //                         .withOpacity(0.7)),
                                  //                 prefixIcon: Icon(Icons.monetization_on,
                                  //                     color: Theme.of(context).accentColor),
                                  //                 //   border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
                                  //                 focusedBorder: UnderlineInputBorder(
                                  //                     borderSide:
                                  //                         BorderSide(color: Colors.black87)),
                                  //                 // enabledBorder:
                                  //                 //     OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     Flexible(
                                  //       flex: 1,
                                  //       child: Padding(
                                  //         padding: const EdgeInsets.all(3.0),
                                  //         child: Container(
                                  //           height: 10.0.h,
                                  //           child: Padding(
                                  //             padding: const EdgeInsets.symmetric(
                                  //                 horizontal: 10, vertical: 0),
                                  //             child: TextFormField(
                                  //               controller: _rDaysController,
                                  //               maxLength: 10,
                                  //               //  initialValue: '${widget.userphone}' ?? '',
                                  //               keyboardType: TextInputType.number,
                                  //               validator: RequiredValidator(
                                  //                   errorText: "Days is required"),
                                  //               //validator: RequiredValidator(errorText: "username is required"),
                                  //               // validator: (input) => input.length < 3 ? S.of(context).should_be_more_than_3_letters : null,
                                  //               decoration: InputDecoration(
                                  //                 counterText: '',
                                  //
                                  //                 labelText: 'Return Days',
                                  //
                                  //                 labelStyle: TextStyle(color: Colors.black87),
                                  //                 contentPadding: EdgeInsets.all(12),
                                  //                 //  hintText: S.of(context).john_doe,
                                  //                 hintStyle: TextStyle(
                                  //                     color: Theme.of(context)
                                  //                         .focusColor
                                  //                         .withOpacity(0.7)),
                                  //                 prefixIcon: Icon(Icons.calendar_today,
                                  //                     color: Theme.of(context).accentColor),
                                  //                 //   border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
                                  //                 focusedBorder: UnderlineInputBorder(
                                  //                     borderSide:
                                  //                         BorderSide(color: Colors.black87)),
                                  //                 // enabledBorder:
                                  //                 //     OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                                  //               ),
                                  //             ),
                                  //             // child: TextFormField(
                                  //             //   keyboardType: TextInputType.number,
                                  //             //   validator: RequiredValidator(errorText: "Days is required"),
                                  //             //   // obscureText: _con.hidePassword,
                                  //             //   //  onSaved: (input) => _con.user.password = input,
                                  //             //   //  validator: (input) => input.length < 6 ? S.of(context).should_be_more_than_6_letters : null,
                                  //             //   controller: _rDaysController,
                                  //             //   decoration: InputDecoration(
                                  //             //     labelText: 'Return Days',
                                  //             //     labelStyle: TextStyle(color: Theme.of(context).accentColor),
                                  //             //     contentPadding: EdgeInsets.all(12),
                                  //             //     hintText: 'days',
                                  //             //     hintStyle: TextStyle(
                                  //             //         color: Theme.of(context).focusColor.withOpacity(0.7)),
                                  //             //     prefixIcon: Icon(Icons.calendar_today, color: Colors.grey[500]),
                                  //             //     // suffixIcon: IconButton(
                                  //             //     //   onPressed: () {
                                  //             //     //     setState(() {
                                  //             //     //       _con.hidePassword = !_con.hidePassword;
                                  //             //     //     });
                                  //             //     //   },
                                  //             //     //   color: Theme.of(context).focusColor,
                                  //             //     //   icon: Icon(_con.hidePassword ? Icons.visibility : Icons.visibility_off),
                                  //             //     // ),
                                  //             //     // border: OutlineInputBorder(
                                  //             //     //     borderSide: BorderSide(
                                  //             //     //         color: Theme.of(context).focusColor.withOpacity(0.2))),
                                  //             //     // focusedBorder: OutlineInputBorder(
                                  //             //     //     borderSide: BorderSide(
                                  //             //     //         color: Theme.of(context).accentColor.withOpacity(0.5))),
                                  //             //     // enabledBorder: OutlineInputBorder(
                                  //             //     //     borderSide: BorderSide(
                                  //             //     //         color: Theme.of(context).accentColor.withOpacity(0.2))),
                                  //             //   ),
                                  //             // ),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     )
                                  //   ],
                                  // ),
                                  SizedBox(
                                    height: 1.0.h,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RaisedButton(
                                        color: Theme.of(context).accentColor,
                                        shape: new RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.circular(5.0)),
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        onPressed: () {
                                          // displd();
                                          _amountController.clear();
                                          _rDaysController.clear();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.07,
                                      ),
                                      RaisedButton(
                                        color: Colors.black,
                                        shape: new RoundedRectangleBorder(
                                            borderRadius: new BorderRadius.circular(5.0)),
                                        child: Text(
                                          'Submit',
                                          style: TextStyle(color: Theme.of(context).accentColor),
                                        ),
                                        onPressed: () {
                                          _formKey.currentState.validate() ? BidBook() : null;

                                          print(UserId);

                                          print(selectedBooking);

                                          print(_amountController.text);
                                          print(_rDaysController.text);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            // actions: <Widget>[
            //   TextButton(
            //     child: Text(
            //       'Cancel',
            //       style: TextStyle(color: Colors.red),
            //     ),
            //     onPressed: () {
            //       displd();
            //       _amountController.clear();
            //       _rDaysController.clear();
            //       Navigator.of(context).pop();
            //     },
            //   ),
            //   TextButton(
            //     child: Text(
            //       'Confirm',
            //       style: TextStyle(color: Colors.green),
            //     ),
            //     onPressed: () {
            //       _formKey.currentState.validate() ? BidBook() : null;
            //
            //       print(UserId);
            //
            //       print(selectedBooking);
            //
            //       print(_amountController.text);
            //       print(_rDaysController.text);
            //     },
            //   ),
            // ],
          ),
        );
      },
    );
  }

  qouteAdded() {
    Fluttertoast.showToast(
        msg: "Bid Added Successfully",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
    Navigator.of(context).pushReplacementNamed('/Pages', arguments: 1);
  }
}
