// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFormField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final int? maxLength;
  final TextInputFormatter? inputFormatter;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String fontFamily;
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;
  final Color? focusedBorderColor;
  final Color? enabledBorderColor;
  final InputDecoration? inputDecoration;
  final bool showHorizontalDivider;
  final bool showVerticalDivider;
  final String? prefixIconSvg;
  final double? prefixIconSize;
  final bool enableCopyButton;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final ValueChanged<String>? onChanged;
  final Color? borderColor;
  final bool readOnly;
  final bool showLabel; // NEW: Toggle label visibility

  const CustomTextFormField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
    this.maxLength,
    this.inputFormatter,
    this.labelStyle,
    this.hintStyle,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
    this.prefixIcon,
    this.prefixIconSvg,
    this.suffixIcon,
    this.fontFamily = 'Roboto',
    this.height,
    this.width,
    this.borderRadius,
    this.focusedBorderColor,
    this.enabledBorderColor,
    this.inputDecoration,
    this.showHorizontalDivider = false,
    this.showVerticalDivider = false,
    this.prefixIconSize,
    this.enableCopyButton = false,
    this.backgroundColor = Colors.grey,
    this.textColor = Colors.black,
    this.iconColor = Colors.black,
    this.onChanged,
    this.borderColor,
    this.readOnly = false,
    this.showLabel = true, // Default: show label
  });

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller.addListener(() {
      if (widget.onChanged != null) {
        widget.onChanged!(_controller.text);
      }
    });
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    super.dispose();
  }

  void _copyToClipboard() {
    if (_controller.text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _controller.text));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Text copied to clipboard")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle labelTextStyle = GoogleFonts.getFont(
      widget.fontFamily,
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      color: widget.textColor,
    );

    TextStyle hintTextStyle = GoogleFonts.getFont(
      widget.fontFamily,
      fontSize: 14.0,
      color: widget.textColor?.withOpacity(0.7) ?? Colors.grey,
    );

    BorderRadius effectiveBorderRadius = widget.borderRadius ?? BorderRadius.circular(10.0);
    Color effectiveFocusedBorderColor = widget.focusedBorderColor ?? widget.borderColor ?? Colors.black;
    Color effectiveEnabledBorderColor = widget.enabledBorderColor ?? widget.borderColor ?? Colors.grey;

    Widget divider = Container(
      width: 1,
      height: 24,
      color: Colors.grey,
    );

    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: effectiveBorderRadius,
        ),
        child: TextFormField(
          controller: _controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          validator: widget.validator,
          maxLength: widget.maxLength,
          inputFormatters: _getInputFormatters(),
          style: TextStyle(color: widget.textColor),
          onChanged: widget.onChanged,
          maxLines: widget.height != null ? (widget.height! ~/ 24) : 1,
          readOnly: widget.readOnly,
          decoration: widget.inputDecoration ??
              InputDecoration(
                labelText: widget.showLabel
                    ? (widget.label.isNotEmpty ? widget.label : "Label")
                    : null,
                labelStyle: widget.labelStyle ?? labelTextStyle,
                hintText: widget.label,
                alignLabelWithHint: true,
                hintStyle: widget.hintStyle ?? hintTextStyle,
                counterStyle: TextStyle(color: widget.textColor ?? Colors.black),
                contentPadding: widget.contentPadding ??
                    EdgeInsets.symmetric(
                      vertical: widget.height != null ? widget.height! * 0.3 : 15.0,
                      horizontal: 10.0,
                    ),
                prefixIcon: widget.prefixIconSvg != null
                    ? ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: widget.prefixIconSize ?? 24,
                          maxHeight: widget.prefixIconSize ?? 24,
                        ),
                        child: SvgPicture.asset(
                          widget.prefixIconSvg!,
                          fit: BoxFit.contain,
                          colorFilter: ColorFilter.mode(widget.iconColor!, BlendMode.srcIn),
                        ),
                      )
                    : widget.prefixIcon != null
                        ? IconTheme(
                            data: IconThemeData(color: widget.iconColor),
                            child: widget.prefixIcon!,
                          )
                        : null,
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.showHorizontalDivider)
                      Container(
                        width: 24,
                        height: 1,
                        color: Colors.grey,
                        margin: const EdgeInsets.only(right: 8.0),
                      ),
                    if (widget.showVerticalDivider) divider,
                    if (widget.enableCopyButton)
                      IconButton(
                        icon: Icon(Icons.copy, color: widget.iconColor),
                        onPressed: _copyToClipboard,
                        tooltip: "Copy",
                      ),
                    if (widget.suffixIcon != null)
                      IconTheme(
                        data: IconThemeData(color: widget.iconColor),
                        child: widget.suffixIcon!,
                      ),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: effectiveBorderRadius,
                  borderSide: BorderSide(color: effectiveEnabledBorderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: effectiveBorderRadius,
                  borderSide: BorderSide(color: effectiveFocusedBorderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: effectiveBorderRadius,
                  borderSide: BorderSide(color: effectiveEnabledBorderColor),
                ),
                filled: true,
                fillColor: widget.backgroundColor,
              ),
        ),
      ),
    );
  }

  List<TextInputFormatter> _getInputFormatters() {
    if (widget.keyboardType == TextInputType.phone) {
      return [
        FilteringTextInputFormatter.allow(RegExp(r'^[1-9][0-9]*$')),
      ];
    }
    if (widget.inputFormatter != null) {
      return [widget.inputFormatter!];
    }
    return [];
  }
}
