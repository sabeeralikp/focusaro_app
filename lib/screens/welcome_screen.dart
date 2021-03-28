import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'sample.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permantly denied, we cannot request permissions.');
  }

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return Future.error(
          'Location permissions are denied (actual value: $permission).');
    }
  }

  return await Geolocator.getCurrentPosition();
}

class WelcomeScreen extends StatefulWidget {
  static const String id = 'Welcome_Screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  @override
  void initState() {
    // ignore: todo

    super.initState();
    getPermissions();
    _determinePosition().then((v) => print(v));
    controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    animation = ColorTween(
      begin: Colors.brown[900],
      end: Colors.black,
    ).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  getPermissions() async {
    await Permission.contacts.request();
  }

  @override
  void dispose() {
    //ignore: todo

    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: CircleAvatar(
                    backgroundImage: AssetImage('images/figma.jpg'),
                    radius: 40.0,
                  ),
                  // child: Container(
                  //   child: Image.asset('images/figma.jpg'),
                  //   height: 60.0,
                  // ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  'Focusaro',
                  style: TextStyle(
                    fontSize: 40.0,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 70.0),
                //   child:
                //   RoundedButton(
                //     color: Colors.lightBlueAccent,
                //     function: () {
                //       //Go to login screen.
                //       Navigator.pushNamed(context, LoginScreen.id);
                //     },
                //     text: 'Log In',
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 70.0,
                  ),
                  child: RoundedButton(
                    color: Colors.blueAccent,
                    function: () {
                      // //Go to registration screen.
                      // Navigator.pushNamed(context, RegistrationScreen.id);
                      Navigator.popAndPushNamed(context, RegistrationScreen.id);
                    },
                    text: 'Continue',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
