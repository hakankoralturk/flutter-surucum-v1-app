import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:surucum_beta/constants/app_constants.dart';
import 'package:surucum_beta/providers/theme_data_provider.dart';
import 'package:surucum_beta/ui/screens/onboard_screen.dart';

// void main() {
//   runApp(MyApp());
//   init();
// }

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          lazy: true,
          create: (context) => ThemeDataProvider(),
        ),
      ],
      child: EasyLocalization(
        child: MyApp(),
        supportedLocales: AppConstants.SUPPORTED_LOCALES,
        path: AppConstants.LANG_PATH,
      ),
    ),
  );
  init();
}

Future<void> init() async {
  OneSignal.shared.init("729d3742-0e27-4a9a-b6b7-abdb8f1114de");
// //in case of iOS --- see below
//   OneSignal.shared.init("729d3742-0e27-4a9a-b6b7-abdb8f1114de",
//       {OSiOSSettings.autoPrompt: false, OSiOSSettings.inAppLaunchUrl: true});

  OneSignal.shared
      .setNotificationReceivedHandler((OSNotification notification) {
    // a notification has been received
  });

  OneSignal.shared
      .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    // will be called whenever a notification is opened/button pressed.
    print("Open Notif");
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Surucum App',
      theme: context.watch<ThemeDataProvider>().getThemeData,
      home: OnboardScreen(),
    );
  }
}
