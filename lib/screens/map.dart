import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/services/location_services.dart';
import 'package:provider/provider.dart';

String _mapStyle;
LocationData location;
Future<UserLocation> currentLocation;

class MyMap extends StatefulWidget {
  static const id = 'map';
  MyMap({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/mapstyle.txt').then((string) {
      _mapStyle = string;
    });
  }

  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _controller;
  static bool switchValue = false;

  getLocation() async {
    setState(() {
      currentLocation = LocationService().getLocation();
      print(currentLocation.toString() + "##########");
    });
  }

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("images/current.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: 180,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      circle = Circle(
          circleId: CircleId("car"),
          radius: 50,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged().listen((newLocalData) {
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 192.8334901395799,
                  target: LatLng(newLocalData.latitude, newLocalData.longitude),
                  tilt: 0,
                  zoom: 18.30)));
          updateMarkerAndCircle(newLocalData, imageData);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  getloc() async {
    var location = await _locationTracker.getLocation();
    return location;
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String userInfo = ModalRoute.of(context).settings.arguments;
    return StreamProvider<UserLocation>(
      create: (context) => LocationService().locationStream,
      child: Scaffold(
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
              'Focus Map',
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
                    if (switchValue) {
                      setState(() {
                        print(location.latitude);
                        print(userInfo);
                        FirebaseFirestore.instance
                            .collection('user')
                            .doc(userInfo)
                            .update({
                          'focusLocation': [
                            location.latitude,
                            location.longitude
                          ],
                          'focusMode': true,
                        });
                      });
                    } else {
                      FirebaseFirestore.instance
                          .collection('user')
                          .doc(userInfo)
                          .update({
                        'focusLocation': [0, 0],
                        'focusMode': false,
                      });
                    }
                    print(switchValue);
                  });
                },
              ),
            ),
          ],
        ),
        body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: initialLocation,
          markers: Set.of((marker != null) ? [marker] : []),
          circles: Set.of((circle != null) ? [circle] : []),
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
            controller.setMapStyle(_mapStyle);
          },
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.location_searching),
            onPressed: () {
              getCurrentLocation();
            }),
      ),
    );
  }
}
