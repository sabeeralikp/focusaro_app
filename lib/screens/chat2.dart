import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'messagescreen.dart';

class Mock extends StatefulWidget {
  static const String id = 'chat_Screen';
  @override
  _MockState createState() => _MockState();
}

class _MockState extends State<Mock> {
  static bool switchValue = false;
  @override
  Widget build(BuildContext context) {
    final String phoneNumber = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: Icon(Icons.message),
        onPressed: () {
          setState(() {
            print('object');
            Navigator.pushNamed(
              context,
              Accounts.id,
              arguments: phoneNumber,
            );
          });
        },
      ),
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        bottom: PreferredSize(
            child: Padding(padding: EdgeInsets.all(8.0)),
            preferredSize: Size.fromHeight(27.0)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(40),
          ),
        ),
        brightness: Brightness.dark,
        elevation: 8,
        title: Padding(
          padding: const EdgeInsets.only(
            right: 20.0,
            top: 20.0,
            left: 20.0,
          ),
          child: Text(
            'Inbox',
            style: TextStyle(
              fontSize: 23.0,
              color: Colors.white,
            ),
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              right: 20.0,
              top: 20.0,
            ),
            child: CupertinoSwitch(
              value: switchValue ? true : false,
              activeColor: Colors.teal[700],
              onChanged: (value) {
                setState(() {
                  // print(value);
                  switchValue = value;
                  print(switchValue);
                });
              },
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (BuildContext context, int index) {
          final Message chat = chats[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(),
              ),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(2),
                    decoration: chat.unread
                        ? BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            border: Border.all(
                              width: 2,
                              color: Colors.blue,
                            ),
                            // shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ],
                          )
                        : BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage(chat.sender.imageUrl),
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    width: MediaQuery.of(context).size.width * 0.65,
                    padding: EdgeInsets.all(
                      20,
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  chat.sender.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                chat.sender.isOnline
                                    ? Container(
                                        margin: const EdgeInsets.only(left: 5),
                                        width: 7,
                                        height: 7,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.blue,
                                        ),
                                      )
                                    : Container(
                                        child: null,
                                      ),
                              ],
                            ),
                            Text(
                              chat.time,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w300,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            chat.text,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Message {
  final User sender;
  final String
      time; // Would usually be type DateTime or Firebase Timestamp in production apps
  final String text;
  final bool unread;

  Message({
    this.sender,
    this.time,
    this.text,
    this.unread,
  });
}

class User {
  final int id;
  final String name;
  final String imageUrl;
  final bool isOnline;

  User({
    this.id,
    this.name,
    this.imageUrl,
    this.isOnline,
  });
}

// EXAMPLE CHATS ON HOME SCREEN
List<Message> chats = [
  Message(
    sender: ironMan,
    time: '5:30 PM',
    text: 'Hey, I am currently in Focus Mode will get back to you',
    unread: true,
  ),
  Message(
    sender: spiderMan,
    time: '4:30 PM',
    text: 'This is a mock message',
    unread: true,
  ),
  Message(
    sender: ironMan,
    time: '3:45 PM',
    text: 'How are you ?',
    unread: true,
  ),
  Message(
    sender: ironMan,
    time: '3:15 PM',
    text: 'Call me soon',
    unread: true,
  ),
  Message(
    sender: blackWindow,
    time: '2:30 PM',
    text:
        'But that spider kid is having some difficulties due his identity reveal by a blog called daily bugle.',
    unread: true,
  ),
  Message(
    sender: scarletWitch,
    time: '2:30 PM',
    text:
        'Pepper & Morgan is fine. They\'re strong as you. Morgan is a very brave girl, one day she\'ll make you proud.',
    unread: true,
  ),
  Message(
    sender: hulk,
    time: '2:30 PM',
    text: 'Yes Tony!',
    unread: true,
  ),
  Message(
    sender: captainMarvel,
    time: '2:00 PM',
    text: 'I hope my family is doing well.',
    unread: true,
  ),
];

// EXAMPLE MESSAGES IN CHAT SCREEN
List<Message> messages = [
  Message(
    sender: ironMan,
    time: '5:30 PM',
    text: 'Hey, I am currently in Focus Mode will get back to you',
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '4:30 PM',
    text: 'This is a mock message',
    unread: true,
  ),
  Message(
    sender: ironMan,
    time: '3:45 PM',
    text: 'How are you ?',
    unread: true,
  ),
  Message(
    sender: ironMan,
    time: '3:15 PM',
    text: 'Call me soon',
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '2:30 PM',
    text:
        'But that spider kid is having some difficulties due his identity reveal by a blog called daily bugle.',
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '2:30 PM',
    text:
        'Pepper & Morgan is fine. They\'re strong as you. Morgan is a very brave girl, one day she\'ll make you proud.',
    unread: true,
  ),
  Message(
    sender: currentUser,
    time: '2:30 PM',
    text: 'Yes Tony!',
    unread: true,
  ),
  Message(
    sender: ironMan,
    time: '2:00 PM',
    text: 'I hope my family is doing well.',
    unread: true,
  ),
];

// YOU - current user
final User currentUser = User(
  id: 0,
  name: 'Nick Fury',
  imageUrl: 'images/figma.jpg',
  isOnline: true,
);

// USERS
final User ironMan = User(
  id: 1,
  name: 'ADeeBz',
  imageUrl: 'images/figma.jpg',
  isOnline: true,
);
final User captainAmerica = User(
  id: 2,
  name: 'Ani',
  imageUrl: 'images/figma.jpg',
  isOnline: true,
);
final User hulk = User(
  id: 3,
  name: 'Henna',
  imageUrl: 'images/figma.jpg',
  isOnline: false,
);
final User scarletWitch = User(
  id: 4,
  name: 'Beebi',
  imageUrl: 'images/figma.jpg',
  isOnline: false,
);
final User spiderMan = User(
  id: 5,
  name: 'ADeeBa M',
  imageUrl: 'images/figma.jpg',
  isOnline: true,
);
final User blackWindow = User(
  id: 6,
  name: 'Aneesa',
  imageUrl: 'images/figma.jpg',
  isOnline: false,
);
final User thor = User(
  id: 7,
  name: 'Henna',
  imageUrl: 'images/figma.jpg',
  isOnline: false,
);
final User captainMarvel = User(
  id: 8,
  name: 'Libna',
  imageUrl: 'images/figma.jpg',
  isOnline: false,
);

// class ChatScreen extends StatefulWidget {
//   final User user;

//   ChatScreen({this.user});

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   _chatBubble(Message message, bool isMe, bool isSameUser) {
//     if (isMe) {
//       return Column(
//         children: <Widget>[
//           Container(
//             alignment: Alignment.topRight,
//             child: Container(
//               constraints: BoxConstraints(
//                 maxWidth: MediaQuery.of(context).size.width * 0.80,
//               ),
//               padding: EdgeInsets.all(10),
//               margin: EdgeInsets.symmetric(vertical: 10),
//               decoration: BoxDecoration(
//                 color: Theme.of(context).primaryColor,
//                 borderRadius: BorderRadius.circular(15),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                   ),
//                 ],
//               ),
//               child: Text(
//                 message.text,
//                 style: TextStyle(
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//           !isSameUser
//               ? Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: <Widget>[
//                     Text(
//                       message.time,
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.black45,
//                       ),
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.5),
//                             spreadRadius: 2,
//                             blurRadius: 5,
//                           ),
//                         ],
//                       ),
//                       child: CircleAvatar(
//                         radius: 15,
//                         backgroundImage: AssetImage(message.sender.imageUrl),
//                       ),
//                     ),
//                   ],
//                 )
//               : Container(
//                   child: null,
//                 ),
//         ],
//       );
//     } else {
//       return Column(
//         children: <Widget>[
//           Container(
//             alignment: Alignment.topLeft,
//             child: Container(
//               constraints: BoxConstraints(
//                 maxWidth: MediaQuery.of(context).size.width * 0.80,
//               ),
//               padding: EdgeInsets.all(10),
//               margin: EdgeInsets.symmetric(vertical: 10),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(15),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                   ),
//                 ],
//               ),
//               child: Text(
//                 message.text,
//                 style: TextStyle(
//                   color: Colors.black54,
//                 ),
//               ),
//             ),
//           ),
//           !isSameUser
//               ? Row(
//                   children: <Widget>[
//                     Container(
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.5),
//                             spreadRadius: 2,
//                             blurRadius: 5,
//                           ),
//                         ],
//                       ),
//                       child: CircleAvatar(
//                         radius: 15,
//                         backgroundImage: AssetImage(message.sender.imageUrl),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Text(
//                       message.time,
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.black45,
//                       ),
//                     ),
//                   ],
//                 )
//               : Container(
//                   child: null,
//                 ),
//         ],
//       );
//     }
//   }

//   _sendMessageArea() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8),
//       height: 70,
//       color: Colors.white,
//       child: Row(
//         children: <Widget>[
//           IconButton(
//             icon: Icon(Icons.photo),
//             iconSize: 25,
//             color: Theme.of(context).primaryColor,
//             onPressed: () {},
//           ),
//           Expanded(
//             child: TextField(
//               decoration: InputDecoration.collapsed(
//                 hintText: 'Send a message..',
//               ),
//               textCapitalization: TextCapitalization.sentences,
//             ),
//           ),
//           IconButton(
//             icon: Icon(Icons.send),
//             iconSize: 25,
//             color: Theme.of(context).primaryColor,
//             onPressed: () {},
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     int prevUserId;
//     return Scaffold(
//       backgroundColor: Color(0xFFF6F6F6),
//       appBar: AppBar(
//         brightness: Brightness.dark,
//         centerTitle: true,
//         title: RichText(
//           textAlign: TextAlign.center,
//           text: TextSpan(
//             children: [
//               TextSpan(
//                   text: widget.user.name,
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w400,
//                   )),
//               TextSpan(text: '\n'),
//               widget.user.isOnline
//                   ? TextSpan(
//                       text: 'Online',
//                       style: TextStyle(
//                         fontSize: 11,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     )
//                   : TextSpan(
//                       text: 'Offline',
//                       style: TextStyle(
//                         fontSize: 11,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     )
//             ],
//           ),
//         ),
//         leading: IconButton(
//             icon: Icon(Icons.arrow_back_ios),
//             color: Colors.white,
//             onPressed: () {
//               Navigator.pop(context);
//             }),
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: ListView.builder(
//               reverse: true,
//               padding: EdgeInsets.all(20),
//               itemCount: messages.length,
//               itemBuilder: (BuildContext context, int index) {
//                 final Message message = messages[index];
//                 final bool isMe = message.sender.id == currentUser.id;
//                 final bool isSameUser = prevUserId == message.sender.id;
//                 prevUserId = message.sender.id;
//                 return _chatBubble(message, isMe, isSameUser);
//               },
//             ),
//           ),
//           _sendMessageArea(),
//         ],
//       ),
//     );
//   }
// }
