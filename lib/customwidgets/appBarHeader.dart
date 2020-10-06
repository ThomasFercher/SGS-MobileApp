import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../styles.dart';

class AppBarHeader extends StatelessWidget {
  final String title;
  final Widget trailling;
  final AppTheme theme;
  final List<Widget> body;
  final bool isPage;
  final Widget actionButton;
  final Widget bottomAction;
  bool contentPadding = true;

  AppBarHeader({
    this.isPage,
    this.title,
    this.trailling,
    this.theme,
    this.body,
    this.actionButton,
    contentPadding,
    this.bottomAction,
  }) : contentPadding = contentPadding ?? true;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: getTheme().primaryColor,
      ),
      child: Scaffold(
        //  backgroundColor: Colors.white,
        bottomSheet: bottomAction ??
            Container(
              height: 0,
              width: 0,
            ),
        appBar: AppBar(
          toolbarHeight: 80,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: getTheme().primaryColor,
          leading: isPage
              ? Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                )
              : null,
          title: Text(
            title,
            style: GoogleFonts.nunito(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 26,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: trailling,
            )
          ],
        ),
        floatingActionButton: actionButton ?? null,
        body: CustomPaint(
          painter: DarkPainter(),
          child: Padding(
            padding: contentPadding
                ? const EdgeInsets.symmetric(horizontal: 15.0)
                : const EdgeInsets.all(0),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate(body),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DarkPainter extends CustomPainter {
  AppTheme theme = getTheme();
  //drawing
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;

    var height = 200.0;
    var path = new Path();

    paint.color = theme.primaryColor;
    path = new Path();

    canvas.save();
    canvas.translate(size.width * 0.5, size.height * 0.5);
    canvas.rotate(20);

    canvas.drawOval(Rect.fromLTWH(-100, 100, 200, 400), paint);
    canvas.restore();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}