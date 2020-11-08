import 'package:firebase_database/firebase_database.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_cache.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sgs/pages/advanced.dart';
import 'package:sgs/pages/environment.dart';
import 'package:sgs/pages/gallery.dart';
import 'package:sgs/pages/home.dart';
import 'package:sgs/providers/environmentSettingsProvider.dart';
import 'package:sgs/providers/settingsProvider.dart';
import 'package:sgs/providers/storageProvider.dart';
import 'package:weather_icons/weather_icons.dart';
import 'providers/dashboardProvider.dart';
import 'styles.dart';
import 'dart:async';
import 'dart:ui' as UI;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'pages/settings.dart';

void main() => {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: getTheme().background[1],
        ),
      ),
      WidgetsFlutterBinding.ensureInitialized(),
      FlareCache.doesPrune = false,
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<DashboardProvider>(
              lazy: false,
              create: (_) => DashboardProvider(),
            ),
            ChangeNotifierProvider<StorageProvider>(
              lazy: true,
              create: (_) => StorageProvider(),
            ),
            ChangeNotifierProvider<SettingsProvider>(
              lazy: false,
              create: (_) => SettingsProvider(),
            ),
          ],
          child: SufMobileApplication(),
        ),
      )
    };

class SufMobileApplication extends StatelessWidget {
  final String assetName = 'assets/up_arrow.svg';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Provider.of<DashboardProvider>(context, listen: false).loadData();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: FutureBuilder(
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.none ||
              projectSnap.hasData == null ||
              projectSnap.connectionState == ConnectionState.waiting) {
            // Splashscreen using a Flare2d as a loading Animation
            return Container(
              color: Colors.white,
              child: FlareActor(
                'assets/flares/splashscreen.flr',
                alignment: Alignment.center,
                animation: "Loading",
              ),
            );
          } else {
            // Once loaded the main page will be displayed
            return MyHomePage(
              title: "Smart Grow Farm",
            );
          }
        },
        future: loadData(context),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.temperature}) : super(key: key);

  final temperature;
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // This function return the Backgroundpainter for the given tab

  @override
  Widget build(BuildContext context) {
    return Home();
  }
}

var _assetsToWarmup = [
  AssetFlare(bundle: rootBundle, name: "assets/flares/moon.flr"),
  AssetFlare(bundle: rootBundle, name: "assets/flares/sun.flr"),
  AssetFlare(bundle: rootBundle, name: "assets/flares/grow.flr")
];

/// This function loads the inital data from the database when the app starts.
Future<void> loadData(context) async {
  Stopwatch stopwatch = new Stopwatch()..start();
  await Provider.of<DashboardProvider>(context, listen: false).loadData();
  await Provider.of<StorageProvider>(context, listen: false)
      .loadImages(context);

  //chaches the flares so they can be instantly used without loading
  for (final asset in _assetsToWarmup) {
    await cachedActor(asset);
  }

  stopwatch.stop();
  //add a delay so the animation plays through
  return Future.delayed(
    Duration(milliseconds: 3000 - stopwatch.elapsedMilliseconds),
  );
}

Future<UI.Image> loadImageAsset(String assetName) async {
  final data = await rootBundle.load(assetName);
  return decodeImageFromList(data.buffer.asUint8List());
}
