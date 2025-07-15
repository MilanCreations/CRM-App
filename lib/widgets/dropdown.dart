import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropdownButton2 extends StatefulWidget {
  const CustomDropdownButton2({
    super.key,
    required this.hint,
    required this.value,
    required this.dropdownItems,
    required this.onChanged,
    this.selectedItemTextColor = Colors.black,
    this.selectedItemFontWeight = FontWeight.bold,
    this.hintAlignment,
    this.valueAlignment,
    this.buttonHeight,
    this.buttonWidth,
    this.buttonPadding,
    this.buttonDecoration,
    this.buttonElevation,
    this.icon,
    this.iconSize,
    this.iconEnabledColor,
    this.iconDisabledColor,
    this.itemHeight,
    this.itemPadding,
    this.dropdownHeight,
    this.dropdownWidth,
    this.dropdownPadding,
    this.dropdownDecoration,
    this.dropdownElevation,
    this.scrollbarRadius,
    this.scrollbarThickness,
    this.scrollbarAlwaysShow,
    this.offset = Offset.zero,
    this.prefixIcon,
    this.borderRadius = 12.0,
    this.focusBorderColor = Colors.black,
    this.borderColor = Colors.black,
    this.enableSearch = false, // ✅ New
  });

  final Widget hint;
  final String? value;
  final List<String> dropdownItems;
  final ValueChanged<String?>? onChanged;
  final Alignment? hintAlignment;
  final Alignment? valueAlignment;
  final double? buttonHeight, buttonWidth;
  final EdgeInsetsGeometry? buttonPadding;
  final BoxDecoration? buttonDecoration;
  final int? buttonElevation;
  final Widget? icon;
  final double? iconSize;
  final Color? iconEnabledColor;
  final Color? iconDisabledColor;
  final double? itemHeight;
  final EdgeInsetsGeometry? itemPadding;
  final double? dropdownHeight, dropdownWidth;
  final EdgeInsetsGeometry? dropdownPadding;
  final BoxDecoration? dropdownDecoration;
  final int? dropdownElevation;
  final Radius? scrollbarRadius;
  final double? scrollbarThickness;
  final bool? scrollbarAlwaysShow;
  final Offset offset;
  final Widget? prefixIcon;
  final double borderRadius;
  final Color focusBorderColor;
  final Color borderColor;
  final Color selectedItemTextColor;
  final FontWeight selectedItemFontWeight;
  final bool enableSearch;

  @override
  State<CustomDropdownButton2> createState() => _CustomDropdownButton2State();
}

class _CustomDropdownButton2State extends State<CustomDropdownButton2> {
  late List<String> filteredItems;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredItems = List.from(widget.dropdownItems);
  }

  @override
  void didUpdateWidget(covariant CustomDropdownButton2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dropdownItems != widget.dropdownItems) {
      filteredItems = List.from(widget.dropdownItems);
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color resolvedBorderColor = widget.borderColor;

    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Row(
          children: [
            if (widget.prefixIcon != null) ...[
              widget.prefixIcon!,
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Container(
                alignment: widget.hintAlignment,
                child: widget.hint,
              ),
            ),
          ],
        ),
        value: widget.value,
        selectedItemBuilder: (BuildContext context) {
          return widget.dropdownItems.map<Widget>((String item) {
            return Align(
              alignment: widget.valueAlignment ?? Alignment.centerLeft,
              child: Row(
                children: [
                  if (widget.prefixIcon != null) ...[
                    widget.prefixIcon!,
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        color: widget.selectedItemTextColor,
                        fontWeight: widget.selectedItemFontWeight,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList();
        },
        items: (widget.enableSearch ? filteredItems : widget.dropdownItems)
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                ))
            .toList(),
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        },
        onMenuStateChange: (isOpen) {
          if (!isOpen && widget.enableSearch) {
            searchController.clear();
            filteredItems = List.from(widget.dropdownItems);
          }
        },
        dropdownSearchData: widget.enableSearch
            ? DropdownSearchData(
                searchController: searchController,
                searchInnerWidgetHeight: 50,
                searchInnerWidget: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        filteredItems = widget.dropdownItems
                            .where((item) =>
                                item.toLowerCase().contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                ),
              )
            : null,
        buttonStyleData: ButtonStyleData(
          height: widget.buttonHeight ?? 60,
          width: widget.buttonWidth ?? double.infinity,
          padding: widget.buttonPadding ??
              const EdgeInsets.symmetric(horizontal: 16),
          decoration: widget.buttonDecoration ??
              BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: Border.all(color: resolvedBorderColor),
              ),
          elevation: widget.buttonElevation,
        ),
        iconStyleData: IconStyleData(
          icon: widget.icon ?? const Icon(Icons.keyboard_arrow_down),
          iconSize: widget.iconSize ?? 24,
          iconEnabledColor: widget.iconEnabledColor,
          iconDisabledColor: widget.iconDisabledColor,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: widget.dropdownHeight ?? 250,
          width: widget.dropdownWidth ?? MediaQuery.of(context).size.width * 0.9,
          padding: widget.dropdownPadding,
          decoration: widget.dropdownDecoration ??
              BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
          elevation: widget.dropdownElevation ?? 8,
          offset: widget.offset,
          scrollbarTheme: ScrollbarThemeData(
            radius: widget.scrollbarRadius ?? const Radius.circular(40),
            thickness: widget.scrollbarThickness != null
                ? WidgetStateProperty.all<double>(widget.scrollbarThickness!)
                : null,
            thumbVisibility: widget.scrollbarAlwaysShow != null
                ? WidgetStateProperty.all<bool>(widget.scrollbarAlwaysShow!)
                : null,
          ),
        ),
        menuItemStyleData: MenuItemStyleData(
          height: widget.itemHeight ?? 48,
          padding:
              widget.itemPadding ?? const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}
