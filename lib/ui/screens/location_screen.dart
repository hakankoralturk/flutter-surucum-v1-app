import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  //final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position _currentPosition;
  String _currentAddress;

  @override
  void initState() {
    super.initState();
    setLocation();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    bool isLoading = false;

    return Scaffold(
      backgroundColor: Color(0xFF183650),
      appBar: AppBar(
        title: Text("Konum Gönder"),
        backgroundColor: Color(0xFF183650),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              child: Icon(Icons.info_rounded),
              onTap: () {},
            ),
          ),
        ],
      ),
      body: SafeArea(
        minimum: EdgeInsets.only(left: 30, right: 30, top: 30),
        child: Column(
          children: [
            Container(
              height: height / 5,
              child: MaterialButton(
                onPressed: () => _getAddressFromLatLng(),
                disabledColor: Theme.of(context).primaryColor,
                padding: EdgeInsets.all(20),
                color: Colors.blueGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Align(
                  child: isLoading
                      ? new CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          strokeWidth: 2,
                        )
                      : new Text(
                          "Güncel Konumum",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              child: _currentPosition == null
                  ? null
                  : Text(
                      "Enlem: " + _currentPosition.latitude.toString(),
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
            ),
            Container(
              child: _currentPosition == null
                  ? null
                  : Text(
                      "Boylam: " + _currentPosition.longitude.toString(),
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
            ),
            Container(
              child: _currentAddress == null
                  ? null
                  : Text(
                      "Adres: \n$_currentAddress",
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Position> _getCurrentLocation() async {
    var currrentLocation;

    try {
      currrentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
    } catch (e) {
      currrentLocation = null;
    }
    return currrentLocation;
  }

  setLocation() async {
    await _getCurrentLocation().then((position) {
      setState(() {
        _currentPosition = position;
      });
    });
  }

  Future<void> _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];
      print(_currentPosition.latitude.toString());
      setState(() {
        _currentAddress =
            "${place.toString()}, ${place.name}, \n${place.subLocality}, ${place.street}, ${place.isoCountryCode}, ${place.locality}, ${place.postalCode}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }
}

// @override
// void initState() {
//   super.initState();

//   doSomeAsyncStuff();
// }

// Future<void> doSomeAsyncStuff() async {
//   ...
// }
