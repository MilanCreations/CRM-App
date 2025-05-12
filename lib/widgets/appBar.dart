// ignore_for_file: deprecated_member_use

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
    this.gradient, // ✅ New gradient parameter
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
  final Gradient? gradient; // ✅ New gradient property

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: gradient == null ? (backgroundColor ?? Colors.white) : null,
        gradient: gradient, // ✅ Apply gradient if provided
        boxShadow: [
          if (blurColor != null && elevation != null)
            BoxShadow(
              color: blurColor!.withOpacity(0.1),
              spreadRadius: 2,
              offset: Offset(0, elevation!),
            ),
        ],
        border: borderColor != null
            ? Border(
                bottom: BorderSide(
                  color: borderColor!,
                  width: 1,
                ),
              )
            : null,
      ),
      child: AppBar(
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
        backgroundColor: Colors.transparent, // ✅ To allow gradient visibility
        elevation: 0,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
