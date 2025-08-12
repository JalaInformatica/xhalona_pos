import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_icon_button.dart';
import 'package:xhalona_pos/widgets/app_text_field.dart';

class AppTypeahead2<T> extends TypeAheadField<T> {
  AppTypeahead2({
    super.key,
    required String label,
    super.onSelected,
    bool? autofocus,
    required Future<List<T>> Function(String newFilterValue) updateFilterValue,
    String Function(T)? displayText,
    Widget Function(T)? displayWidget,
    required Function(bool forceClear) onClear,
    super.emptyBuilder,
    super.debounceDuration,
    super.controller,
    Function()? onTapOutside,
    Widget? customSuffixIcon
  }) : assert(displayText != null || displayWidget != null,
          'Either displayText or displayWidget must be provided.'),
          super(
          suggestionsCallback: (pattern) {
            return updateFilterValue(pattern);
          },
          decorationBuilder: (context, child) {
            return Material(
              elevation: 2,
              color: AppColor.whiteColor,
              child: child,
            );
          },
          builder: (context, textEditingController, focusNode) {
            return AppTextField(
              context: context,
              autofocus: autofocus ?? false,
              textEditingController: textEditingController,
              focusNode: focusNode,
              onTapOutside: (e) {
                if(onTapOutside!=null){
                  onTapOutside();
                }
                onClear(false);
              },
              labelText: label,
              suffixIcon: textEditingController.text.isEmpty
                  ? customSuffixIcon ?? Icon(Icons.search, color: AppColor.grey400)
                  : AppIconButton(
                      onPressed: () {
                        onClear(true);
                      },
                      icon: Icon(Icons.close, color: AppColor.grey400),
                    ),
            );
          },
          itemBuilder: (context, T suggestion) {
            return ListTile(
              dense: true,
              visualDensity: VisualDensity.compact,
              splashColor: AppColor.grey200,
              tileColor: AppColor.whiteColor,
              title: displayWidget != null
                  ? displayWidget(suggestion)
                  : Text(displayText!(suggestion), style: AppTextStyle.textBodyStyle()),
            );
          },
          loadingBuilder: (context) {
            return ListTile(
              tileColor: AppColor.whiteColor,
              leading: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: AppColor.primaryColor),
              ),
              title: Text("Memuat...", style: AppTextStyle.textBodyStyle()),
            );
          },
        );
}
