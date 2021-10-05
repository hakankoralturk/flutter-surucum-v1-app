import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:surucum_beta/constants/app_constants.dart';
import 'package:surucum_beta/helpers/strings.dart';
import 'package:surucum_beta/providers/theme_data_provider.dart';
import 'package:surucum_beta/ui/screens/login_screen.dart';

class OnboardScreen extends StatefulWidget {
  @override
  _OnboardScreenState createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  PageController _pageController;
  int currentIndex;
  bool visibleBackButton = false;
  bool loading = false;
  bool isButtonDisabled = false;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle.light.copyWith(
    //     systemNavigationBarIconBrightness: Brightness.dark,
    //     statusBarIconBrightness: Brightness.dark,
    //     statusBarBrightness: Brightness.light,
    //   ),
    // );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        height: 120,
        child: Padding(
          padding: EdgeInsets.only(left: 30, right: 30, top: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Material(
                  color: Color(0xFF25A3DC).withOpacity(.1),
                  child: InkWell(
                    onTap: () {
                      print("page changed");
                      onAddButtonTapped(currentIndex - 1);
                    },
                    child: visibleBackButton
                        ? Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.arrow_back,
                              color: Color(0xFF183650).withOpacity(.5),
                              size: 24,
                            ),
                          )
                        : SizedBox(),
                  ),
                ),
              ),
              GestureDetector(
                onTap: !isButtonDisabled
                    ? () {
                        print("skip");
                        _continue();
                      }
                    : null,
                child: Text(
                  "Skip".toUpperCase(),
                  style: TextStyle(
                    color: Color(0xFF68676E),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.only(top: height * .1),
        child: Stack(
          children: [
            PageView(
              onPageChanged: (int page) {
                setState(() {
                  currentIndex = page;
                  if (currentIndex != 0) {
                    visibleBackButton = true;
                  } else {
                    visibleBackButton = false;
                  }
                });
              },
              controller: _pageController,
              children: [
                makePage(
                  image: SvgPicture.asset(
                    AppConstants.ONBOARD_SVG_01,
                    width: MediaQuery.of(context).size.width / 1.3,
                  ),
                  title: Strings.stepOneTitle,
                  content: Strings.stepOneContent,
                ),
                makePage(
                  reverse: true,
                  image: SvgPicture.asset(
                    AppConstants.ONBOARD_SVG_02,
                    width: MediaQuery.of(context).size.width / 1.3,
                  ),
                  title: Strings.stepOneTitle,
                  content: Strings.stepOneContent,
                ),
                makePage(
                  last: true,
                  image: SvgPicture.asset(
                    AppConstants.ONBOARD_SVG_03,
                    width: MediaQuery.of(context).size.width / 1.3,
                  ),
                  title: Strings.stepOneTitle,
                  content: Strings.stepOneContent,
                ),
              ],
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget makePage({image, title, content, reverse = false, last = false}) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          !reverse
              ? Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: image,
                    ),
                    SizedBox(height: 30),
                  ],
                )
              : SizedBox(),
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF1D1C22),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Text(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          reverse
              ? Column(
                  children: [
                    SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: image,
                    ),
                  ],
                )
              : SizedBox(),
          Expanded(
            child: SizedBox(
              height: 60,
            ),
          ),
          last
              ? Container(
                  height: 60,
                  margin: EdgeInsets.only(bottom: 40),
                  child: MaterialButton(
                    onPressed: !isButtonDisabled
                        ? () {
                            _continue();
                          }
                        : null,
                    disabledColor: Color(0xFF183650).withOpacity(.7),
                    padding: EdgeInsets.all(10),
                    color: Color(0xFF183650).withOpacity(.7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Align(
                      child: isLoading()
                          ? CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              strokeWidth: 2,
                            )
                          : Text(
                              "Continue",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                    ),
                  ),
                )
              : SizedBox(height: 60),
        ],
      ),
    );
  }

  void onAddButtonTapped(int index) {
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 8,
      width: isActive ? 30 : 8,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: Color(0xFF68676E),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  List<Widget> _buildIndicator() {
    List<Widget> indicators = [];
    for (var i = 0; i < 3; i++) {
      if (currentIndex == i) {
        indicators.add(_indicator(true));
      } else {
        indicators.add(_indicator(false));
      }
    }
    return indicators;
  }

  bool isLoading() {
    return loading;
  }

  void setLoading(value) {
    setState(() {
      loading = value;
      isButtonDisabled = value;
    });
  }

  Future<void> _continue() async {
    setLoading(true);

    await Future.delayed(Duration(milliseconds: 1000));

    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (_) => LoginScreen(),
    //     ));

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (c, a1, a2) => LoginScreen(),
        transitionsBuilder: (c, anim, a2, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: Duration(milliseconds: 1000),
      ),
    );

    setLoading(false);
  }
}

class CustomAppBar extends PreferredSize {
  final Widget child;
  final double height;

  CustomAppBar({@required this.child, this.height = kToolbarHeight});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      alignment: Alignment.center,
      child: child,
    );
  }
}
