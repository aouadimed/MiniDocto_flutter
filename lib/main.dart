import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_user/core/theme/app_theme.dart';
import 'package:flutter_user/core/services/app_routes.dart' as route;
import 'package:flutter_user/core/localization/app_localizations.dart';
import 'package:flutter_user/core/util/shared_pref_module.dart';
import 'package:flutter_user/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await initializeDependencies();
  await TokenManager.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('fr');
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      designSize: const Size(428, 926),
      minTextAdapt: true,
      splitScreenMode: true,
      builder:
          (context, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'mini docto+',
            theme: theme(),
            locale: _locale,
            supportedLocales: const [Locale('ar'), Locale('fr')],
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: _analytics),
            ],
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              ...GlobalMaterialLocalizations.delegates,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
            onGenerateRoute: route.controller,
            initialRoute:
                TokenManager.isLoggedIn
                    ? route.bottomNavigationBar
                    : route.loginScreen,
          ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
