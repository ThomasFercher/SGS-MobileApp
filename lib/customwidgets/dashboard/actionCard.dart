import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';

import '../../styles.dart';

class ActionCard extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final String text;
  final Color iconColor;
  final Color backgroundColor;

  ActionCard({
    @required this.onPressed,
    @required this.icon,
    @required this.iconColor,
    @required this.text,
    @required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: cardElavation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius),
        ),
      ),
      color: backgroundColor,
      child: Container(
        child: InkWell(
          enableFeedback: true,
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: () => onPressed(),
          onLongPress: () => onPressed(),
          child: LayoutBuilder(builder: (context, constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: constraints.maxWidth - 35 - 12,
                  alignment: Alignment.bottomLeft,
                  margin: EdgeInsets.only(top: 40),
                  padding: EdgeInsets.only(bottom: 10, left: 10),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      text,
                      textAlign: TextAlign.start,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(top: 12, right: 12),
                  child: Icon(
                    icon,
                    size: 35,

                    color: iconColor, //Colors.white.withOpacity(1),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
