import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final String fontFamily;
  final TextOverflow overflow;
  final int? maxLines;
  final TextDecoration? textDecoration;
  final VoidCallback? onTap;
  final Gradient? gradient;

  const CustomText({
    Key? key,
    required this.text,
    this.textAlign = TextAlign.left,
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.black,
    this.fontFamily = 'PrimaryFont',
    this.overflow = TextOverflow.visible,
    this.maxLines,
    this.textDecoration,
    this.onTap,
    this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle;

    final shader = gradient?.createShader(
      Rect.fromLTWH(0, 0, text.length * fontSize, fontSize),
    );

    try {
      textStyle = GoogleFonts.getFont(
        fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: textDecoration,
        color: gradient == null ? color : null,
        foreground: gradient != null ? (Paint()..shader = shader!) : null,
      );
    } catch (e) {
      textStyle = TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: textDecoration,
        color: gradient == null ? color : null,
        foreground: gradient != null ? (Paint()..shader = shader!) : null,
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        style: textStyle,
      ),
    );
  }
}
