import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

import '../customwidgets/dashboard/actionCard.dart';
import '../customwidgets/dashboard/carddata.dart';
import '../customwidgets/dashboard/dayRange.dart';
import '../customwidgets/dashboard/growProgress.dart';
import '../customwidgets/dashboard/waterTankLevel.dart';
import '../customwidgets/general/appBarBanner.dart';
import '../customwidgets/general/appBarHeader.dart';
import '../objects/appTheme.dart';
import '../objects/liveData.dart';
import '../providers/dataProvider.dart';
import '../providers/settingsProvider.dart';
import '../styles.dart';
import 'advanced.dart';
import 'environment.dart';
import 'gallery.dart';
import 'settings.dart';

class Dashboard extends StatelessWidget {
  static const String EnvironmentSettings = 'Environment';
  static const String Settings = 'Settings';
  static const String SignOut = 'About';

  static const List<String> choices = <String>[
    EnvironmentSettings,
    Settings,
    SignOut
  ];

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();
    return Consumer<DataProvider>(
      builder: (context, data, child) {
        LiveData d = data.liveData;
        var suntime = data.activeClimate.getSuntime(GROWPHASEVEGETATION);

        var width = MediaQuery.of(context).size.width - 20;
        return AppBarHeader(
          isPage: false,
          title: "Smart Urban Farm",
          contentPadding: true,
          flexibleSpace: AppBarBanner(220, "Smart Urban Farm"),
          body: <Widget>[
            Padding(padding: EdgeInsets.only(top: 20)),
            sectionTitle(
              context,
              "Details",
              theme.headlineColor,
            ),
            GridView.count(
              primary: false,
              padding: EdgeInsets.all(0),
              crossAxisSpacing: 15,
              // mainAxisSpacing: 10,
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              shrinkWrap: true,
              children: <Widget>[
                CardData(
                  icon: WeatherIcons.wi_thermometer,
                  label: "Temperatur",
                  text: "${d.temperature}°C",
                  iconColor: theme.primaryColor,
                  type: Temperature,
                  key: GlobalKey(),
                ),
                CardData(
                  icon: WeatherIcons.wi_humidity,
                  label: "Luftfeuchtigkeit",
                  text: "${d.humidity}%",
                  iconColor: theme.primaryColor,
                  type: Humidity,
                  key: GlobalKey(),
                ),
                CardData(
                  icon: WeatherIcons.wi_barometer,
                  label: "Bodenfeuchtigkeit",
                  text: "${d.soilMoisture}%",
                  iconColor: theme.primaryColor,
                  type: SoilMoisture,
                  key: GlobalKey(),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            sectionTitle(context, "Sunlight", theme.headlineColor),
            Container(
              child:
                  /*DaySlider(
                initialTimeString: dashboard.suntime,
                onValueChanged: (_timeRange) =>
                    {dashboard.suntimeChanged(_timeRange)},
              ),*/
                  DayRange(
                suntime: suntime,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            sectionTitle(
              context,
              "Actions",
              theme.headlineColor,
            ),
            GridView.count(
              primary: false,
              crossAxisCount: 2,
              padding: EdgeInsets.all(0),
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              // mainAxisSpacing: 10,

              childAspectRatio: 1.75,
              shrinkWrap: true,
              children: [
                ActionCard(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: RouteSettings(),
                        builder: (context) {
                          return Gallery();
                        },
                      ),
                    ),
                  },
                  icon: Icons.photo,
                  text: "Gallery",
                  iconColor: Color(0xFFdcf8ec),
                  backgroundColor: theme.primaryColor,
                ),
                ActionCard(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return Advanced();
                      }),
                    ),
                  },
                  icon: Icons.assessment,
                  text: "Advanced Data",
                  iconColor: Color(0xFFdcf8ec),
                  backgroundColor: theme.primaryColor,
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            sectionTitle(
              context,
              "Settings",
              theme.headlineColor,
            ),
            GridView.count(
              primary: false,
              crossAxisCount: 2,
              padding: EdgeInsets.all(0),
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              // mainAxisSpacing: 10,

              childAspectRatio: 1.75,
              shrinkWrap: true,
              children: [
                ActionCard(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return Environment(
                          height: MediaQuery.of(context).size.height - 80,
                        );
                      }),
                    ),
                  },
                  icon: Icons.settings_system_daydream,
                  text: "Environment",
                  iconColor: Color(0xFFe1e4f4),
                  backgroundColor: theme.secondaryColor,
                ),
                ActionCard(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return SettingsPage();
                      }),
                    ),
                  },
                  icon: Icons.settings,
                  text: "App Settings",
                  iconColor: Color(0xFFe1e4f4),
                  backgroundColor: theme.secondaryColor,
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            GridView.count(
              primary: false,
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 0.5,
              crossAxisSpacing: 15,
              children: [
                LayoutBuilder(builder: (context, c) {
                  return Column(
                    children: [
                      sectionTitle(
                          context, "Grow Progress", theme.headlineColor),
                      GrowProgress(c, d.growProgress)
                    ],
                  );
                }),
                LayoutBuilder(builder: (context, c) {
                  return Column(
                    children: [
                      sectionTitle(
                        context,
                        "Watertank",
                        theme.headlineColor,
                      ),
                      WaterTankLevel(
                        fullness: d.waterTankLevel,
                        height: c.maxHeight - 46,
                      ),
                    ],
                  );
                })
              ],
            )
          ],
        );
      },
    );
  }
}
