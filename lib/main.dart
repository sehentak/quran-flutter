import 'package:flutter/material.dart';
import 'package:quran/internal/firebase_options.dart';
import 'package:quran/internal/resource/routes.rsc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
    );

    await FirebaseAppCheck.instance.activate(
        webRecaptchaSiteKey: 'recaptcha-v3-site-key',
        androidProvider: AndroidProvider.playIntegrity
    );

    FirebaseAnalytics.instance;

    runApp(
        MaterialApp(
            title: 'Qur\'an',
            routes: QuranRoute.routes,
            home: QuranRoute.listPage
        )
    );
}