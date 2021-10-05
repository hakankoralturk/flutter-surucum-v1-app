import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Position userLocation;
  Geolocator geolocator = Geolocator();

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
                onPressed: () => setLocation(),
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
              child: userLocation == null
                  ? null
                  : Text(
                      "Enlem: " + userLocation.latitude.toString(),
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
            ),
            Container(
              child: userLocation == null
                  ? null
                  : Text(
                      "Boylam: " + userLocation.longitude.toString(),
                      style: TextStyle(fontSize: 20, color: Colors.white),
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

  setLocation() {
    _getCurrentLocation().then((position) {
      setState(() {
        userLocation = position;
      });
    });

    // _getCurrentLocation().then((value) {
    //   setState(() {
    //     userLocation = value;
    //   });
    // });
  }
}
