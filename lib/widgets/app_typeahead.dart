import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_icon_button.dart';
import 'package:xhalona_pos/widgets/app_text_field.dart';

class AppTypeahead<T> extends TypeAheadField<T> {
  AppTypeahead({
    super.key,
    required String label,
    required TextEditingController controller,
    required ValueChanged<String?> onSelected,
    required Future<List<T>> Function(String newFilterValue) updateFilterValue,
    required String Function(T) displayText,
    required String Function(T) getId,
    // required Widget icon,
    required Function(bool forceClear) onClear,
  }) : super(
       controller: controller,
       suggestionsCallback: (pattern) {
          return updateFilterValue(pattern);
        },
        builder: (context, textEditingController, focusNode) {
          return AppTextField(
            context: context,
            textEditingController: textEditingController,
            focusNode: focusNode,
            onTapOutside: (e){
              onClear(false);
            },
            labelText: label,
            suffixIcon: AppIconButton(
              onPressed: (){
                onClear(true);
              },
              icon: Icon(
                Icons.close,
                color: AppColor.grey400,
              )
            ),
          );
        },
        itemBuilder: (context, T suggestion) {
          return ListTile(
            title: Text(displayText(suggestion)),
          );
        },
        
        onSelected: (T suggestion) {
          onSelected(getId(suggestion));
          
        },
      );
}
