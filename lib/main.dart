import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:hive/hive.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:surucum_beta/constants/app_constants.dart';
//import 'package:surucum_beta/providers/theme_data_provider.dart';
import 'package:surucum_beta/providers/theme_provider.dart';
import 'package:surucum_beta/ui/screens/home_screen.dart';
import 'package:surucum_beta/ui/screens/location_screen.dart';
import 'package:surucum_beta/ui/screens/login_screen.dart';
import 'package:surucum_beta/ui/screens/onboard_screen.dart';

// void main() {
//   runApp(MyApp());
//   init();
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await pathProvider.getApplicationDocumentsDirectory();

  await EasyLocalization.ensureInitialized();

  Hive.init(appDocumentDirectory.path);

  final settings = await Hive.openBox('settings');
  bool isLightTheme = settings.get('isLightTheme') ?? false;

  print(isLightTheme);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          lazy: true,
          create: (_) => ThemeProvider(isLightTheme: isLightTheme),
        ),
      ],
      child: EasyLocalization(
        child: AppStart(),
        supportedLocales: AppConstants.SUPPORTED_LOCALES,
        path: AppConstants.LANG_PATH,
      ),
    ),
  );
  init();
}

Future<void> init() async {
// YENİ ONESİGNAL İLE KALDIRDIK
  // OneSignal.shared.init("729d3742-0e27-4a9a-b6b7-abdb8f1114de");

// //in case of iOS --- see below
//   OneSignal.shared.init("729d3742-0e27-4a9a-b6b7-abdb8f1114de",
//       {OSiOSSettings.autoPrompt: false, OSiOSSettings.inAppLaunchUrl: true});

// YENİ ONESİGNAL İLE KALDIRDIK
  // OneSignal.shared
  //     .setNotificationReceivedHandler((OSNotification notification) {
  //   // a notification has been received
  // });

  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });

  OneSignal.shared.setAppId("729d3742-0e27-4a9a-b6b7-abdb8f1114de");

  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });

  OneSignal.shared
      .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    // will be called whenever a notification is opened/button pressed.
    print("Open Notif");
  });
}

class AppStart extends StatelessWidget {
  const AppStart({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return EasyLocalization(
      supportedLocales: AppConstants.SUPPORTED_LOCALES,
      path: AppConstants.LANG_PATH,
      child: MyApp(
        themeProvider: themeProvider,
      ),
    );
  }
}

class MyApp extends StatefulWidget with WidgetsBindingObserver {
  final ThemeProvider themeProvider;
  const MyApp({
    Key key,
    @required this.themeProvider,
  }) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Surucum App',
      debugShowCheckedModeBanner: false,
      theme: widget.themeProvider.themeData(),
      home: LoginScreen(),
    );
  }
}

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Surucum App',
//       theme: context.watch<ThemeDataProvider>().getThemeData,
//       home: OnboardScreen(),
//     );
//   }
// }
