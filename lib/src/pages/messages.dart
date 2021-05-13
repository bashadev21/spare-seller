import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/chat_controller.dart';
import '../elements/EmptyMessagesWidget.dart';
import '../elements/MessageItemWidget.dart';
import '../models/conversation.dart';

class MessagesWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  MessagesWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _MessagesWidgetState createState() => _MessagesWidgetState();
}

class _MessagesWidgetState extends StateMVC<MessagesWidget> {
  ChatController _con;

  _MessagesWidgetState() : super(ChatController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForConversations();
    super.initState();
  }

  Widget conversationsList() {
    return StreamBuilder(
      stream: _con.conversations,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var _docs = _con.orderSnapshotByTime(snapshot);
          return ListView.separated(
              itemCount: _docs.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 7);
              },
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) {
                Conversation _conversation = Conversation.fromJSON(_docs[index].data());
                return MessageItemWidget(
                  message: _conversation,
                  onDismissed: (conversation) {
                    setState(() {
                      //_conversationList.conversations.removeAt(index);
                    });
                  },
                );
              });
        } else {
          return EmptyMessagesWidget();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: MessagingWidget(),
        // body: Center(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Image.asset(
        //         'assets/img/2.png',
        //         height: 100,
        //         width: 200,
        //       ),
        //       Text(
        //         'we will launch on FEB-15',
        //         style: TextStyle(fontSize: 20),
        //       ),
        //     ],
        //   ),
        //   //   key: _con.scaffoldKey,
        //   //   appBar: AppBar(
        //   //     leading: new IconButton(
        //   //       icon: new Icon(Icons.sort, color: Theme.of(context).primaryColor),
        //   //       onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        //   //     ),
        //   //     automaticallyImplyLeading: false,
        //   //     backgroundColor: Colors.grey[900],
        //   //     elevation: 0,
        //   //     centerTitle: true,
        //   //     title: Text(
        //   //       S.of(context).messages,
        //   //       overflow: TextOverflow.fade,
        //   //       maxLines: 1,
        //   //       style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3,color: Theme.of(context).primaryColor)),
        //   //     ),
        //   //     // actions: <Widget>[
        //   //     //   new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        //   //     // ],
        //   //   ),
        //   //   body: currentUser.value.apiToken == null
        //   //       ? PermissionDeniedWidget()
        //   //       : ListView(
        //   //           primary: false,
        //   //           children: <Widget>[
        //   //             conversationsList(),
        //   //           ],
        //   //         ),
        //   // ),
        // ),
      ),
    );
  }
}

class Messaging {
  static final Client client = Client();

  // from 'https://console.firebase.google.com'
  // --> project settings --> cloud messaging --> "Server key"
  static const String serverKey =
      'AAAA_I7wyDk:APA91bH_NUxCl12OnNDe_1d8P8vXX9Qkbs0Hmw336WAZwLPEBkGVmnA5bsDOw90q4zkPdrw3ixtblSd3AGsQmwE79UKJ3bCjPc62wYA3sDCqjvfsC2nWv-eNfa-X0pwuOPbmWygrud-a';

  static Future<Response> sendToAll({
    @required String title,
    @required String body,
  }) =>
      sendToTopic(title: title, body: body, topic: 'all');

  static Future<Response> sendToTopic(
          {@required String title, @required String body, @required String topic}) =>
      sendTo(title: title, body: body, fcmToken: '/topics/$topic');

  static Future<Response> sendTo({
    @required String title,
    @required String body,
    @required String fcmToken,
  }) =>
      client.post(
        'https://fcm.googleapis.com/fcm/send',
        body: json.encode({
          'notification': {'body': '$body', 'title': '$title', 'sound': 'arrive'},
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '6',
            'status': 'done',
            'sound': 'default',
          },
          'to': '$fcmToken',
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
      );
}

class MessagingWidget extends StatefulWidget {
  @override
  _MessagingWidgetState createState() => _MessagingWidgetState();
}

class _MessagingWidgetState extends State<MessagingWidget> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final TextEditingController titleController = TextEditingController(text: 'Title');
  final TextEditingController bodyController = TextEditingController(text: 'Body123');
  final List<Message> messages = [];

  @override
  void initState() {
    super.initState();

    _firebaseMessaging.onTokenRefresh.listen(sendTokenToServer);
    _firebaseMessaging.getToken();

    _firebaseMessaging.subscribeToTopic('all');

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];
        setState(() {
          messages.add(Message(title: notification['title'], body: notification['body']));
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        final notification = message['data'];
        setState(() {
          messages.add(Message(
            title: '${notification['title']}',
            body: '${notification['body']}',
          ));
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextFormField(
              controller: bodyController,
              decoration: InputDecoration(labelText: 'Body'),
            ),
            RaisedButton(
              onPressed: sendNotification,
              child: Text('Send notification to all'),
            ),
          ]..addAll(messages.map(buildMessage).toList()),
        ),
      );

  Widget buildMessage(Message message) => ListTile(
        title: Text(message.title),
        subtitle: Text(message.body),
      );

  Future sendNotification() async {
    final response = await Messaging.sendToAll(
      title: titleController.text,
      body: bodyController.text,
      // fcmToken: Toeken,
    );

    if (response.statusCode != 200) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('[${response.statusCode}] Error message: ${response.body}'),
      ));
    }
  }

  String Toeken;
  void sendNo(fcmToken) {
    Toeken = fcmToken;
  }

  void sendTokenToServer(String fcmToken) {
    print('Token: $fcmToken');
    sendNo(fcmToken);
    // send key to your server to allow server to use
    // this token to send push notifications
  }
}

@immutable
class Message {
  final String title;
  final String body;

  const Message({
    @required this.title,
    @required this.body,
  });
}
