import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.leadingIcon,
    this.leadingOnPressed,
    this.showBackArrow,
    this.backgroundColor,
    this.elevation,
    this.borderColor,
    this.blurColor,
    this.leadingIconColor,
    this.gradient,
    this.bottom,
  });

  final Widget? title;
  final bool? showBackArrow;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;
  final Color? backgroundColor;
  final double? elevation;
  final Color? borderColor;
  final Color? blurColor;
  final Color? leadingIconColor;
  final Gradient? gradient;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: showBackArrow ?? false,
      title: title,
      actions: actions,
      leading: (showBackArrow ?? false)
          ? IconButton(
              onPressed: leadingOnPressed ?? () => Navigator.of(context).pop(),
              icon: Icon(
                leadingIcon ?? Icons.arrow_back,
                color: leadingIconColor ?? Colors.white,
              ),
            )
          : null,
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: elevation ?? 0,
      bottom: bottom,
      flexibleSpace: gradient != null
          ? Container(
              decoration: BoxDecoration(
                gradient: gradient,
                border: borderColor != null
                    ? Border(
                        bottom: BorderSide(color: borderColor!, width: 1),
                      )
                    : null,
                boxShadow: [
                  if (blurColor != null && elevation != null)
                    BoxShadow(
                      color: blurColor!.withOpacity(0.1),
                      spreadRadius: 2,
                      offset: Offset(0, elevation!),
                    ),
                ],
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize {
    final double bottomHeight = bottom?.preferredSize.height ?? 0;
    return Size.fromHeight(kToolbarHeight + bottomHeight);
  }
}
