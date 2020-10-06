import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/appBarHeader.dart';
import 'package:sgs/customwidgets/datachart.dart';
import 'package:sgs/customwidgets/dayslider.dart';
import 'package:sgs/customwidgets/sectionTitle.dart';
import 'package:sgs/objects/environmentSettings.dart';
import 'package:sgs/providers/dashboardProvider.dart';
import 'package:weather_icons/weather_icons.dart';
import '../styles.dart';

class EditEnvironment extends StatelessWidget {
  EnvironmentSettings settings;

  EditEnvironment({@required this.settings});

  saveSettings() {
    print("safe");
  }

  @override
  Widget build(BuildContext context) {
    var name = settings.name;
    return Consumer<DashboardProvider>(builder: (context, d, child) {
      AppTheme theme = getTheme();
      return AppBarHeader(
        title: "Edit $name",
        isPage: true,
        theme: theme,
        contentPadding: false,
        bottomAction: Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          color: Colors.white,
          child: RaisedButton(
            onPressed: () => saveSettings(),
            color: theme.primaryColor,
            textColor: Colors.white,
            child: Text(
              "Save",
              style:
                  GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
          ),
        ),
        body: [
          Input(theme: theme, settings: settings),
          PlaceDivider(),
          EditVariable(
            value: settings.temperature,
            color: Colors.redAccent,
            title: "Temperature",
            unit: "°C",
            icon: WeatherIcons.thermometer,
            min: 0,
            max: 50,
            onValueChanged: (v) {
              print(v);
            },
          ),
          PlaceDivider(),
          EditVariable(
            value: settings.temperature,
            color: Colors.blueAccent,
            title: "Humidty",
            unit: "%",
            icon: WeatherIcons.humidity,
            min: 0,
            max: 100,
            onValueChanged: (v) {
              print(v);
            },
          ),
          PlaceDivider(),
          EditVariable(
            value: settings.temperature,
            color: Colors.brown,
            title: "Soil Moisture",
            unit: "%",
            icon: WeatherIcons.barometer,
            min: 0,
            max: 100,
            onValueChanged: (v) {
              print(v);
            },
          ),
          PlaceDivider(),
          EditVariable(
            value: settings.temperature,
            color: Colors.lightBlueAccent,
            title: "Water Consumption",
            unit: "l/d",
            icon: WeatherIcons.barometer,
            min: 0,
            max: 100,
            onValueChanged: (v) {},
          ),
          PlaceDivider(),
      
          DaySlider(
            onValueChanged: (a) {
              print(a);
            },
            initialTimeString: "6:00-14:00",
          ),
          PlaceDivider(height: 100.0,)
        ],
      );
    });
  }
}

class Input extends StatelessWidget {
  const Input({
    Key key,
    @required this.theme,
    @required this.settings,
  }) : super(key: key);

  final AppTheme theme;
  final EnvironmentSettings settings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: SectionTitle(
              title: "Name",
              fontSize: 24,
            ),
          ),
          SizedBox(
            height: 48,
            child: TextFormField(
              cursorColor: theme.primaryColor,
              initialValue: settings.name,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400]),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.primaryColor),
                  borderRadius: BorderRadius.circular(5.0),
                ),

                //fillColor: Colors.green
              ),
              validator: (val) {
                if (val.length == 0) {
                  return "Name cannot be empty!";
                } else {
                  return null;
                }
              },
              style: GoogleFonts.nunito(
                color: Colors.black87,
                fontSize: 20,
                height: 1,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EditVariable extends StatelessWidget {
  final double value;
  final String title;
  final Color color;
  final IconData icon;
  final String unit;
  final Function onValueChanged;
  final double min;
  final double max;

  EditVariable({
    this.value,
    this.title,
    this.color,
    this.icon,
    this.unit,
    this.onValueChanged,
    this.min,
    this.max,
  });

  @override
  Widget build(BuildContext context) {
    AppTheme theme = getTheme();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: 48,
                child: SectionTitle(
                  title: title,
                  fontSize: 24,
                ),
              ),
              Container(
                height: 48,
                alignment: Alignment.bottomRight,
                child: Text(
                  "$value$unit",
                  style: TextStyle(
                    color: getTheme().textColor,
                    fontWeight: FontWeight.w100,
                    fontSize: 30.0,
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: CupertinoSlider(
              value: value,
              onChanged: (val) => onValueChanged(val),
              activeColor: color,
              max: max,
              min: min,
            ),
          ),
        ],
      ),
    );
  }
}

class PlaceDivider extends StatelessWidget {
  double height;

  PlaceDivider({height}) : height = height ?? 15.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      height: height,
      width: MediaQuery.of(context).size.width,
    );
  }
}