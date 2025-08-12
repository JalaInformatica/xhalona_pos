import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_icon_button.dart';
import 'package:xhalona_pos/widgets/app_text_field.dart';

class AppTypeaheadCustom<T> extends StatefulWidget {
  final String label;
  final bool autofocus;
  final Future<List<T>> Function(String) updateFilterValue;
  final String Function(T)? displayText;
  final Widget Function(T)? displayWidget;
  final void Function(T) onSelected;
  final void Function(bool forceClear) onClear;
  final Widget Function(BuildContext)? emptyBuilder;
  final Duration? debounceDuration;
  final TextEditingController controller;
  final Widget unfocusedWidget;

  const AppTypeaheadCustom({
    super.key,
    required this.label,
    required this.updateFilterValue,
    required this.onSelected,
    required this.onClear,
    this.autofocus = true,
    this.displayText,
    this.displayWidget,
    required this.unfocusedWidget,
    this.emptyBuilder,
    this.debounceDuration,
    required this.controller,
  }) : assert(displayText != null || displayWidget != null,
      'Either displayText or displayWidget must be provided.');

  @override
  State<AppTypeaheadCustom<T>> createState() => _AppTypeaheadCustomState<T>();
}

class _AppTypeaheadCustomState<T> extends State<AppTypeaheadCustom<T>> {
  late bool _isFocused;
  late FocusNode _customFocusNode;

  @override
  void initState() {
    super.initState();
    _isFocused = false;
    _customFocusNode = FocusNode();

    _customFocusNode.addListener(() {
      if (mounted) {
        setState(() {
          _isFocused = _customFocusNode.hasFocus;
        });
      }
    });
  }

  @override
  void dispose() {
    _customFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<T>(
      suggestionsCallback: widget.updateFilterValue,
      debounceDuration: widget.debounceDuration ?? const Duration(milliseconds: 300),
      emptyBuilder: widget.emptyBuilder,
      controller: widget.controller,
      onSelected: (value) {
        widget.onSelected(value);
        _customFocusNode.unfocus();
      },
      decorationBuilder: (context, child) {
        return Material(
          elevation: 2,
          color: AppColor.whiteColor,
          child: child,
        );
      },
      builder: (context, textEditingController, _) {
        return _isFocused
            ? AppTextField(
                context: context,
                autofocus: true, // now trigger keyboard only when tapped
                textEditingController: textEditingController,
                focusNode: _customFocusNode,
                onTapOutside: (_) {
                  _customFocusNode.unfocus();
                },
                labelText: widget.label,
                suffixIcon: textEditingController.text.isEmpty
                    ? Icon(Icons.search, color: AppColor.grey400)
                    : AppIconButton(
                        onPressed: () => widget.onClear(true),
                        icon: Icon(Icons.close, color: AppColor.grey400),
                      ),
              )
            : ListTile(
                onTap: () {
                  setState(() => _isFocused = true);
                  _customFocusNode.requestFocus();
                },
                dense: true,
                isThreeLine: false,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: AppColor.grey300),
                  borderRadius: BorderRadius.circular(5),
                ),
                title: widget.unfocusedWidget,
              );
      },
      itemBuilder: (context, T suggestion) {
        return ListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          splashColor: AppColor.grey200,
          tileColor: AppColor.whiteColor,
          title: widget.displayWidget != null
              ? widget.displayWidget!(suggestion)
              : Text(
                  widget.displayText!(suggestion),
                  style: AppTextStyle.textBodyStyle(),
                ),
        );
      },
      loadingBuilder: (context) => ListTile(
        tileColor: AppColor.whiteColor,
        leading: const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(),
        ),
        title: Text("Memuat...", style: AppTextStyle.textBodyStyle()),
      ),
    );
  }
}
