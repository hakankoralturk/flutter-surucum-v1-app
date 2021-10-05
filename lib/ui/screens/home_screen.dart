import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:surucum_beta/main.dart';
import 'package:surucum_beta/ui/screens/barcode_screen.dart';
import 'package:surucum_beta/ui/screens/location_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String trailerPlate = "Çekiciye bağlı bir Römork yok";
  String _connectionStatus = "Unknown";
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  Flushbar flush;
  bool isDisabled;

  List<RegExp> plateValidations = [
    RegExp(r'\b\d{2}.{0,1}[^\d\W]{0,1}.{0,1}\b\d{4,5}\b'),
    RegExp(r'\b\d{2}.{0,1}[^\d\W]{0,1}.{0,1}\b[^\d\W]{0,1}.{0,1}\b\d{3,4}\b'),
    RegExp(
        r'\b\d{2}.{0,1}[^\d\W]{0,1}.{0,1}\b[^\d\W]{0,1}.{0,1}\w{0,1}.{0,1}\b\d{2,3}\b'),
  ];

  void showSimpleFlushbar(BuildContext context) {
    flush = Flushbar(
      title: "Problem",
      message: "Bağlantı yok.",
      // duration: Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      mainButton: FlatButton(
        onPressed: () {
          try {
            print(_connectionStatus);
            if (_connectionStatus == "ConnectivityResult.mobile" ||
                _connectionStatus == "ConnectivityResult.wifi") {
              print(_connectionStatus.toString());
              flush.dismiss(true);
              setState(() {
                isDisabled = false;
              });
            }
          } on PlatformException catch (e) {
            print(e.toString());
          }
        },
        child: Text(
          "YENİLE",
          style: TextStyle(color: Colors.amber),
        ),
      ),
    )..show(context);
  }

  // void hideSimpleFlushbar(BuildContext context) {
  //   flush.dismiss(context);
  // }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
      if (result == ConnectivityResult.none) {
        showSimpleFlushbar(context);
      }
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        setState(() => _connectionStatus = result.toString());
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }

  Future _scanQR() async {
    var options = ScanOptions(strings: const {
      "cancel": "İptal",
      "flash_on": "Flaşı Aç",
      "flash_off": "Flaşı Kapat"
    });

    try {
      var qrResult = await BarcodeScanner.scan(options: options);

      if (plateValidations[0].hasMatch(qrResult.rawContent.toString()) |
          plateValidations[1].hasMatch(qrResult.rawContent.toString()) |
          plateValidations[2].hasMatch(qrResult.rawContent.toString())) {
        setState(() {
          trailerPlate = qrResult.rawContent.toString();
        });
        print(trailerPlate);
      } else {
        setState(() {
          trailerPlate = "Römork Bağlayın";
        });
        print(trailerPlate);
        print('Plaka Doğrulanamadı');
      }
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          trailerPlate = "Camera permission was denied";
          print('1');
        });
      } else {
        setState(() {
          trailerPlate = "Unknown Error $ex";
          print('2');
        });
      }
    } on FormatException {
      setState(() {
        trailerPlate = "You pressed the back button before scanning anything";
        print('3');
      });
    } catch (ex) {
      setState(() {
        trailerPlate = "Unknown Error $ex";
        print('4');
      });
    }
  }

  @override
  void initState() {
    super.initState();

    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    print(flush);
    if (flush == null || flush.isShowing() == true) {
      setState(() {
        isDisabled = true;
      });
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    bool isLoading = false;

    return Scaffold(
      backgroundColor: Color(0xFF183650),
      appBar: AppBar(
        title: Text("Çekici: 34 AAA 987"),
        backgroundColor: Color(0xFF183650),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              child: Icon(Icons.settings),
              onTap: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              child: Icon(Icons.refresh),
              onTap: () {},
            ),
          ),
        ],
      ),
      body: SafeArea(
        minimum: EdgeInsets.only(left: 30, right: 30, top: 10),
        child: Wrap(
          spacing: 10,
          runSpacing: 20,
          children: [
            Container(
              width: width,
              height: height * .08,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Hakan KORALTÜRK",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        trailerPlate,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              width: width * .5 - 35,
              height: height * .3 - 45,
              child: MaterialButton(
                elevation: 0,
                onPressed: isDisabled
                    ? null
                    : () {
                        _scanQR();
                      },
                disabledColor: Colors.blueGrey.withOpacity(.3),
                padding: EdgeInsets.all(20),
                color: Color(0xFF3E1929),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: isLoading
                      ? new CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5,
                        )
                      : new Text(
                          "Römork Bağla",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isDisabled
                                ? Colors.white.withOpacity(.5)
                                : Colors.white,
                            fontSize: 22,
                            fontFamily: 'Rubik',
                          ),
                        ),
                ),
              ),
            ),
            Container(
              width: width * .5 - 35,
              height: height * .3 - 45,
              child: MaterialButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LocationScreen()),
                ),
                elevation: 0,
                disabledColor: Colors.blueGrey.withOpacity(.3),
                padding: EdgeInsets.all(20),
                color: Color(0xFF709775),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Align(
                  child: Text(
                    "Konum Gönder",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Rubik',
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: width,
              height: height * .2,
              child: MaterialButton(
                onPressed: () {
                  showSimpleFlushbar(context);
                },
                elevation: 0,
                disabledColor: Colors.blueGrey.withOpacity(.3),
                padding: EdgeInsets.all(20),
                color: Color(0xFFB0DAF1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Align(
                  child: Text(
                    "Mesajlaşma",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black.withOpacity(.7),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Rubik',
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: width,
              height: height * .2,
              child: MaterialButton(
                onPressed: isDisabled
                    ? null
                    : () {
                        print(isDisabled.toString());
                      },
                elevation: 0,
                disabledColor: Colors.blueGrey.withOpacity(.3),
                padding: EdgeInsets.all(20),
                color: Color(0xFFD2E59E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Align(
                  child: Text(
                    "Talimatlar",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black.withOpacity(.7),
                      fontSize: 20,
                      fontFamily: 'Rubik',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CheckInternet {
  StreamSubscription<DataConnectionStatus> listener;
  var internetStatus = "Unknown";
  var contentmessage = "Unknown";

  void _showDialog(String title, String content, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: new Text("err"),
              content: new Text(content),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: new Text("Close"))
              ]);
        });
  }

  checkConnection(BuildContext context) async {
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          internetStatus = "Connected to the Internet";
          contentmessage = "Connected to the Internet";
          _showDialog(internetStatus, contentmessage, context);
          break;
        case DataConnectionStatus.disconnected:
          internetStatus = "You are disconnected to the Internet. ";
          contentmessage = "Please check your internet connection";
          _showDialog(internetStatus, contentmessage, context);
          break;
      }
    });
    return await DataConnectionChecker().connectionStatus;
  }
}
