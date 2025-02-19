import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:xhalona_pos/widgets/app_text_field.dart';

class AppTypeahead<T> extends TypeAheadField<T> {
  AppTypeahead({
    super.key,
    required String label,
    required TextEditingController controller,
    required ValueChanged<String?> onChanged,
    required Future<List<T>> Function(String newFilterValue) updateFilterValue,
    required String Function(T) displayText,
    required String Function(T) getId,
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
            labelText: label,
          );
        },
        itemBuilder: (context, T suggestion) {
          return ListTile(
            title: Text(displayText(suggestion)),
          );
        },
        onSelected: (T suggestion) {
          // controller.text = displayText(suggestion);
          onChanged(getId(suggestion));
        },
      );
}
