// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color textColor;
  final TextStyle? textStyle;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double elevation;
  final bool isLoading;
  final Widget? icon;
  final bool fullWidth;
  final Gradient? gradient;
  final double? height;
  final double? width;
  final double borderWidth;
  final Color borderColor;
  final Color? backgroundColor;
  final Color? disabledColor;
  final Color loadingIndicatorColor;
  final bool enableRipple;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor = Colors.white,
    this.textStyle,
    this.borderRadius = 10.0,
    this.padding = const EdgeInsets.symmetric(vertical: 8.5, horizontal: 10.0),
    this.elevation = 2.0,
    this.isLoading = false,
    this.icon,
    this.fullWidth = false,
    this.gradient,
    this.height = 50.0,
    this.width,
    this.borderWidth = 1.0,
    this.borderColor = Colors.transparent,
    this.backgroundColor,
    this.disabledColor,
    this.loadingIndicatorColor = Colors.white,
    this.enableRipple = true,
  });

  @override
  Widget build(BuildContext context) {
    final buttonChild = isLoading
        ? CircularProgressIndicator(color: loadingIndicatorColor, strokeWidth: 2)
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: textStyle ??
                    TextStyle(
                      fontSize: 15,
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          );

    final btnContent = Container(
      alignment: Alignment.center,
      padding: padding,
      height: height,
      width: fullWidth ? double.infinity : width,
      decoration: BoxDecoration(
        color: gradient == null ? (backgroundColor ?? Theme.of(context).primaryColor) : null,
        gradient: isLoading ? null : gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: buttonChild,
    );

    return SizedBox(
      width: fullWidth ? double.infinity : width,
      height: height,
      child: enableRipple
          ? Material(
              color: Colors.transparent,
              elevation: elevation,
              borderRadius: BorderRadius.circular(borderRadius),
              child: InkWell(
                borderRadius: BorderRadius.circular(borderRadius),
                onTap: isLoading ? null : onPressed,
                child: btnContent,
              ),
            )
          : GestureDetector(
              onTap: isLoading ? null : onPressed,
              child: Material(
                color: Colors.transparent,
                elevation: elevation,
                borderRadius: BorderRadius.circular(borderRadius),
                child: btnContent,
              ),
            ),
    );
  }
}
