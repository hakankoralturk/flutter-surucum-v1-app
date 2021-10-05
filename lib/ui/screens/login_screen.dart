import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:surucum_beta/constants/app_constants.dart';
import 'package:surucum_beta/providers/theme_provider.dart';
import 'package:surucum_beta/ui/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _tcController = TextEditingController();
  TextEditingController _plateController = TextEditingController();
  // Pattern pattern =
  //     r'^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\d{3})\d{11})$';
  // RegExp _creditCard = RegExp(pattern);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    // GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    bool isLoading = false;

    return Scaffold(
      // backgroundColor: Color(0xFF183650),
      appBar: AppBar(
        backgroundColor: Color(0xFF183650),
        toolbarHeight: 40,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: GestureDetector(
                child: Icon(Icons.lightbulb),
                onTap: () {
                  themeProvider.isLightTheme == false
                      ? themeProvider.isLightTheme = true
                      : themeProvider.isLightTheme = false;
                  setState(() {});
                  print("theme changed");
                  //changeThemeMode(themeProvider.isLightTheme);
                  //return widget.id == 3 ? Scaffold(/*version 1*/) : Scaffold(/*version 2*/);
                }),
          ),
        ],
      ),
      body: SafeArea(
        minimum: EdgeInsets.only(left: 30, right: 30),
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 70,
                    right: 70,
                  ),
                  child: Lottie.asset('assets/animations/truck-running.json',
                      width: 300),
                ),
              ),
              // Container(
              //   child: Expanded(
              //     child: SvgPicture.asset(
              //       AppConstants.AKAR_LOGO_LIGHT,
              //       width: MediaQuery.of(context).size.width / 1.8,
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: AlignmentDirectional.center,
                child: Expanded(
                  child: Text(
                    "Sürücü Giriş",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: themeProvider.themeMode().textFieldBackgroundColor,
                ),
                child: TextField(
                  controller: _tcController,
                  keyboardType: TextInputType.number,
                  // inputFormatters: <TextInputFormatter>[
                  //   FilteringTextInputFormatter.allow(_creditCard),
                  // ],
                  // textAlign: TextAlign.end,
                  // onChanged: (value) {
                  //   context.watch().setMessage(null);
                  // },
                  style: TextStyle(
                    fontSize: 22,
                  ),
                  // enabled: !context.watch<UserProvider>().isLoading(),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    // errorText: context.watch<UserProvider>().getMessage(),
                    // hintText: LocaleKeys.login_textfield_hint.locale,
                    hintText: "Kullanıcı Kimliği",
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: themeProvider.themeMode().textFieldBackgroundColor,
                ),
                child: TextField(
                  controller: _plateController,
                  keyboardType: TextInputType.text,
                  // textAlign: TextAlign.end,
                  // onChanged: (value) {
                  //   context.watch().setMessage(null);
                  // },
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'Rubik',
                  ),
                  // enabled: !context.watch<UserProvider>().isLoading(),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    // errorText: context.watch<UserProvider>().getMessage(),
                    // hintText: LocaleKeys.login_textfield_hint.locale,
                    hintText: "Araç Plakası",
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 60,
                child: MaterialButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen())),
                  disabledColor: Theme.of(context).primaryColor,
                  color: Color(0xFF25A3DC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Align(
                    child: isLoading
                        ? LinearProgressIndicator(
                            backgroundColor: Colors.white,
                            minHeight: 6,
                          )
                        : Text(
                            "Giriş yap",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontFamily: 'Rubik',
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void checkLoggedIn() async {
    bool loggedIn = await Future.delayed(Duration(seconds: 2), () => false);
    if (loggedIn) {
      Future.delayed(
          Duration(seconds: 3),
          () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen())));
    } else {
      print("Else");
    }
  }
}
