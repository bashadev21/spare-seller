import 'dart:async';
import 'dart:convert';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:sparedo_partner/base_url.dart';
import 'package:sparedo_partner/src/pages/login.dart';

typedef void OnError(Exception exception);

class BookingDetails extends StatefulWidget {
  final int id;
  BookingDetails(this.id);

  @override
  _BookingDetailsState createState() => _BookingDetailsState();
}

String UserId;

enum PlayerState { stopped, playing, paused }

class _BookingDetailsState extends State<BookingDetails> {
  List bookingDetails = List();
  List sellerDetails = List();
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

  // Future bookingdetails() async {
  //   final LocalStorage storage = new LocalStorage("");
  //   var selected_category = storage.getItem('booking_id');
  //   print(selected_category);
  //
  //   var response =
  //       await http.get('${BaseUrl.bookingDetails}${widget.id.toString()}');
  //   var jsonBody = response.body;
  //   var data = json.decode(jsonBody);
  //   setState(() {
  //     data = data;
  //   });
  //
  //   this.bookingDetails = data['data'];
  //   print(this.bookingDetails);
  // }
  List image = List();
  List voice = List();
  Future bookingdetails() async {
    final LocalStorage storage = new LocalStorage("");
    var selected_category = storage.getItem('booking_id');
    print(selected_category);

    var response = await http.get('${BaseUrl.bookingDetails}${widget.id.toString()}');
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

    print('statusCodew : ' + response.statusCode.toString());
  }

  // AudioPlayer audioPlayer = AudioPlayer();
  // AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);

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

  @override
  void initState() {
    // bookingdetails();
    bookingdetails();
    // SellerFunc();
    initAudioPlayer();
    // SellerFunc();
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          elevation: 0,
          centerTitle: true,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Booking Details',
            style: Theme.of(context)
                .textTheme
                .headline6
                .merge(TextStyle(letterSpacing: 1.3, color: Theme.of(context).primaryColor)),
          ),
        ),
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
                                            child: Column(
                                              children: [
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
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                            child: Column(
                                              children: [
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
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                            child: Column(
                                              children: [
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
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                            child: Column(
                                              children: [
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
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                            child: Column(
                                              children: [
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
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                            child: Column(
                                              children: [
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
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  Container(
                                    width: 99.0.w,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          fit: FlexFit.tight,
                                          child: Container(
                                            height: 6.0.h,
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Description',
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
                                                    maxLines: 8,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 13, fontWeight: FontWeight.w500),
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
                                                  child: Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        IconButton(
                                                          onPressed: isPlaying
                                                              ? null
                                                              : () => play(
                                                                  bookingDetails[index]['id']
                                                                      .toString(),
                                                                  voice[index]['voice'].toString()),
                                                          iconSize: 25.0.sp,
                                                          icon: Icon(Icons.play_arrow),
                                                          color: Theme.of(context).accentColor,
                                                        ),
                                                        IconButton(
                                                          onPressed:
                                                              isPlaying ? () => pause() : null,
                                                          iconSize: 25.0.sp,
                                                          icon: Icon(Icons.pause),
                                                          color: Theme.of(context).accentColor,
                                                        ),
                                                        IconButton(
                                                          onPressed: isPlaying || isPaused
                                                              ? () => stop()
                                                              : null,
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
                                                          inactiveTrackColor: Color(
                                                              0xFF8D8E98), // Custom Gray Color
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
                                                            max:
                                                                duration.inMilliseconds.toDouble()),
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

                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(horizontal: 40),
                                  //   child: BlockButtonWidget(
                                  //     text: Text(
                                  //       'Seller List',
                                  //       style: TextStyle(
                                  //           color: Colors.black87,
                                  //           fontWeight: FontWeight.w600,
                                  //           letterSpacing: 0.7),
                                  //     ),
                                  //     color: Theme.of(context).accentColor,
                                  //     onPressed: () {
                                  //       Navigator.push(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //               builder: (context) => SellerDetails(widget.id)));
                                  //     },
                                  //   ),
                                  // ),
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
      ),
    );
  }
}
