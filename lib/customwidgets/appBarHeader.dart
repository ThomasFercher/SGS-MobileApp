import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/appBarBanner.dart';
import 'package:sgs/objects/appTheme.dart';
import 'package:sgs/providers/settingsProvider.dart';

import '../styles.dart';

class AppBarHeader extends StatelessWidget {
  final String title;
  final Widget trailling;
  final List<Widget> body;
  final bool isPage;
  final Widget actionButton;
  final Widget bottomAction;
  final _controller = ScrollController();
  final PreferredSizeWidget appbarBottom;
  bool contentPadding = true;

  AppBarHeader({
    this.isPage,
    this.title,
    this.trailling,
    this.body,
    this.actionButton,
    contentPadding,
    this.bottomAction,
    this.appbarBottom,
  }) : contentPadding = contentPadding ?? true;

  @override
  Widget build(BuildContext context) {
    List<SliverListTile> bodyList = body
        .map(
          (widget) => SliverListTile(
            child: widget,
            hasPadding: contentPadding,
          ),
        )
        .toList();

    _controller.addListener(() {
      var scrollOffset = _controller.position.pixels;
      var scrollDirection = _controller.position.userScrollDirection;

      if (scrollOffset < 140 && scrollDirection == ScrollDirection.reverse) {
        _controller.animateTo(140,
            duration: Duration(milliseconds: 100), curve: Curves.slowMiddle);
      } else if (scrollOffset < 140 &&
          scrollDirection == ScrollDirection.forward) {
        _controller.animateTo(0,
            duration: Duration(milliseconds: 100), curve: Curves.slowMiddle);
      }
    });

    AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: theme.background,
      ),
      child: Scaffold(
        bottomSheet: bottomAction ??
            Container(
              height: 0,
              width: 0,
            ),
        floatingActionButton: actionButton ?? null,
        backgroundColor: theme.background,
        body: CustomScrollView(
          controller: isPage ? null : _controller,
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: isPage ? 80 : 220,
              toolbarHeight: 80,
              flexibleSpace: !isPage ? AppBarBanner(220, title) : Container(),
              floating: true,
              elevation: 2,
              pinned: true,
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: theme.primaryColor,
              bottom: appbarBottom ?? null,
              automaticallyImplyLeading: true,
              leading: isPage
                  ? Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: IconButton(
                        icon: IconTheme(
                          data: IconThemeData(opacity: 1),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    )
                  : null,
              title: isPage
                  ? Text(
                      title,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 26,
                      ),
                    )
                  : null,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: trailling,
                )
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate(bodyList),
            ),
          ],
        ),
      ),
    );
  }
}

class DarkPainter extends CustomPainter {
  //drawing
  @override
  void paint(Canvas canvas, Size size) {
    /*   var paint = Paint();
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
    canvas.drawPath(path, paint);*/
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class SliverListTile extends StatelessWidget {
  final Widget child;
  final bool hasPadding;

  const SliverListTile(
      {Key key, @required this.child, @required this.hasPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();

    return ColoredBox(
      color: theme.background,
      child: Padding(
        padding: hasPadding
            ? const EdgeInsets.symmetric(horizontal: 15.0)
            : EdgeInsets.zero,
        child: child,
      ),
    );
  }
}
