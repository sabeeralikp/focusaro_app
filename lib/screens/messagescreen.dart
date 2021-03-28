import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'map.dart';
import 'package:flash_chat/services/location_services.dart';
import 'package:provider/provider.dart';
import 'dart:math' show cos, sqrt, asin;

bool focusMode = false;

class Accounts extends StatefulWidget {
  static const String id = 'accounts';
  Accounts({String phoneNumber});

  @override
  _AccountsState createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  String photoUrl;
  Map<String, Color> contactsColorMap = new Map();
  TextEditingController searchController = new TextEditingController();

  List<Contact> user = [];
  Future<dynamic> s;

  @override
  void initState() {
    super.initState();

    getPermissions();
    setState(() {});
  }

  getPermissions() async {
    if (await Permission.contacts.request().isGranted) {
      getAllContacts();

      searchController.addListener(() {
        filterContacts();
      });
    }
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  getAllContacts() async {
    List colors = [Colors.green, Colors.indigo, Colors.yellow, Colors.orange];
    int colorIndex = 0;
    Contact s;
    List<Contact> _contacts = (await ContactsService.getContacts()).toList();

    _contacts.forEach((contact) {
      try {
        FirebaseFirestore.instance
            .collection('user')
            .where(
              'phoneNumber',
              isEqualTo: contact.phones.first.value
                  .replaceAll(' ', '')
                  .replaceAll('+91', ''),
            )
            .get()
            .then(
              (value) => value.docs.forEach(
                (element) {
                  if (element['phoneNumber'] != null) {
                    print(element['phoneNumber']);
                    s = contact;
                    print("Avatar" +
                        contact.avatar.length.toString() +
                        element['photoUrl']);

                    user.add(s);

                    print(user.toString() + '///' + s.toString());
                  }
                },
              ),
            );
      } catch (e) {
        print(e);
      }
      Color baseColor = colors[colorIndex];
      contactsColorMap[contact.displayName] = baseColor;
      colorIndex++;
      if (colorIndex == colors.length) {
        colorIndex = 0;
      }
    });
    setState(() {
      contacts = user;

      // print(users);
    });
  }

  filterContacts() {
    List<Contact> _contacts = [];
    _contacts.addAll(contacts);
    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((contact) {
        String searchTerm = searchController.text.toLowerCase();
        String searchTermFlatten = flattenPhoneNumber(searchTerm);
        String contactName = contact.displayName.toLowerCase();
        bool nameMatches = contactName.contains(searchTerm);
        if (nameMatches == true) {
          return true;
        }

        if (searchTermFlatten.isEmpty) {
          return false;
        }

        var phone = contact.phones.firstWhere((phn) {
          String phnFlattened = flattenPhoneNumber(phn.value);
          return phnFlattened.contains(searchTermFlatten);
        }, orElse: () => null);

        return phone != null;
      });
    }
    setState(() {
      contactsFiltered = _contacts;
    });
  }

  getdetails(String sender, String reciever) async {
    String text;
    FirebaseFirestore.instance
        .collection(sender.compareTo(reciever) > 0
            ? reciever + reciever
            : sender + reciever)
        .orderBy('timestamp')
        .limit(1)
        .get()
        .then((value) => value.docs.forEach((element) {
              if (element != null) {
                text = element['text'];
              } else
                text = '';
            }));
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final Map<dynamic, dynamic> data =
        ModalRoute.of(context).settings.arguments;
    print(data['userId'] + '+++++++');
    final String phoneNumber = data['phoneNumber'];

    bool isSearching = searchController.text.isNotEmpty;
    bool listItemsExist = (contactsFiltered.length > 0 || contacts.length > 0);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(data['userId'].toString() + '+++++++++++++');
          Navigator.pushNamed(context, MyMap.id, arguments: data['userId']);
        },
      ),
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 0.0,
              top: 20.0,
            ),
            child: CupertinoSwitch(
              value: focusMode,
              activeColor: Colors.teal[700],
              onChanged: (value) {
                setState(() {
                  // print(value);
                  focusMode = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 20.0,
              top: 20.0,
              left: 20.0,
            ),
            child: GestureDetector(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Icon(
                  Icons.refresh,
                ),
              ),
              onTap: () {
                setState(() {});
              },
            ),
          ),
        ],
      ),
      body: StreamProvider<UserLocation>(
        create: (context) => LocationService().locationStream,
        child: Body(
          searchController: searchController,
          listItemsExist: listItemsExist,
          isSearching: isSearching,
          contactsFiltered: contactsFiltered,
          contacts: contacts,
          contactsColorMap: contactsColorMap,
          phoneNumber: phoneNumber,
          userId: data['userId'],
        ),
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body(
      {Key key,
      @required this.searchController,
      @required this.listItemsExist,
      @required this.isSearching,
      @required this.contactsFiltered,
      @required this.contacts,
      @required this.contactsColorMap,
      @required this.phoneNumber,
      this.userId})
      : super(key: key);

  final TextEditingController searchController;
  final bool listItemsExist;
  final bool isSearching;
  final List<Contact> contactsFiltered;
  final List<Contact> contacts;
  final Map<String, Color> contactsColorMap;
  final String phoneNumber;
  final String userId;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 1274200 * asin(sqrt(a));
  }

  getdata(id, UserLocation current) async {
    FirebaseFirestore.instance.collection('user').doc(id).get().then((value) {
      List<dynamic> focusLocation = value.data()['focusLocation'];

      double result = calculateDistance(focusLocation[0], focusLocation[1],
          current.latitude, current.longitude);
      print("***********" +
          result.toString() +
          focusLocation[0].toString() +
          focusLocation[1].toString() +
          ' Hello ' +
          current.latitude.toString() +
          current.longitude.toString());
      if (result < 50) {
        setState(() {
          focusMode = true;
        });
      } else {
        focusMode = false;
        FirebaseFirestore.instance.collection('user').doc(id).update({
          'focusLocation': [0, 0],
          'focusMode': false,
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var userLocation = Provider.of<UserLocation>(context);
    print(userLocation.latitude.toString() + 'Bello');
    getdata(super.widget.userId, userLocation);
    return focusMode
        ? Container(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.work,
                    color: Colors.blue,
                    size: 80.0,
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    'Currently in Focus Mode',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 25.0,
                    ),
                  )
                ],
              ),
            ),
          )
        : Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Container(
                  child: TextField(
                    controller: widget.searchController,
                    decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.blue),
                        labelText: 'Search',
                        border: new OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            borderSide: new BorderSide(
                              color: Colors.blue,
                            )),
                        prefixIcon: Icon(Icons.search, color: Colors.blue)),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                widget.listItemsExist == true
                    ? Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.isSearching == true
                              ? widget.contactsFiltered.length
                              : widget.contacts.length,
                          itemBuilder: (context, index) {
                            Contact contact = widget.isSearching == true
                                ? widget.contactsFiltered[index]
                                : widget.contacts[index];

                            var baseColor =
                                widget.contactsColorMap[contact.displayName]
                                    as dynamic;

                            Color color1 = baseColor[800];
                            Color color2 = baseColor[400];
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, ChatScreen.id,
                                    arguments: {
                                      'reciever': contact.phones
                                          .elementAt(0)
                                          .value
                                          .replaceAll(' ', '')
                                          .replaceAll('+91', ''),
                                      'sender': widget.phoneNumber,
                                      'recieverName': contact.displayName,
                                    });
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 5.0),
                                decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25))),
                                child: ListTile(
                                    title: Text(
                                      contact.displayName,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0),
                                    ),
                                    subtitle: FutureBuilder(
                                      future: FirebaseFirestore.instance
                                          .collection(widget.phoneNumber
                                                      .compareTo(
                                                    contact.phones
                                                        .elementAt(0)
                                                        .value
                                                        .replaceAll(' ', '')
                                                        .replaceAll('+91', ''),
                                                  ) >
                                                  0
                                              ? contact.phones
                                                      .elementAt(0)
                                                      .value
                                                      .replaceAll(' ', '')
                                                      .replaceAll('+91', '') +
                                                  widget.phoneNumber
                                              : widget.phoneNumber +
                                                  contact.phones
                                                      .elementAt(0)
                                                      .value
                                                      .replaceAll(' ', '')
                                                      .replaceAll('+91', ''))
                                          .orderBy('timestamp',
                                              descending: true)
                                          .limit(1)
                                          .get(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          print(
                                            widget.phoneNumber +
                                                contact.phones
                                                    .elementAt(0)
                                                    .value
                                                    .replaceAll(' ', '')
                                                    .replaceAll('+91', ''),
                                          );
                                          final QuerySnapshot documents =
                                              snapshot.data;

                                          return Text(
                                            documents.docs.first.data()['text'],
                                            style: TextStyle(
                                                color: Colors.white60),
                                          );
                                        }
                                        return Text(' ');
                                      },
                                    ),
                                    leading: (contact.avatar != null &&
                                            contact.avatar.length > 0)
                                        ? CircleAvatar(
                                            backgroundImage:
                                                MemoryImage(contact.avatar),
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                gradient: LinearGradient(
                                                    colors: [
                                                      color1,
                                                      color2,
                                                    ],
                                                    begin: Alignment.bottomLeft,
                                                    end: Alignment.topRight)),
                                            child: CircleAvatar(
                                                radius: 27.0,
                                                child: Text(contact.initials(),
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                backgroundColor:
                                                    Colors.transparent))),
                              ),
                            );
                          },
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LoadingBouncingGrid.square(
                              backgroundColor: Colors.blue,
                              duration: Duration(milliseconds: 2000),
                            ),
                          ],
                        ),
                      )
              ],
            ),
          );
  }
}
