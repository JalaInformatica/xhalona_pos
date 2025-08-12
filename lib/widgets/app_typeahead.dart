import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_text_field.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:xhalona_pos/widgets/app_icon_button.dart';

class AppTypeahead<T> extends TypeAheadField<T> {
  AppTypeahead({
    super.key,
    required String label,
     TextEditingController? controller,
    required ValueChanged<String> onSelected,
    required Future<List<T>> Function(String newFilterValue) updateFilterValue,
    required String Function(T) displayText,
    required String Function(T) getId,
    // required Widget icon,
    required Function(bool forceClear) onClear,
    super.emptyBuilder,
    super.debounceDuration,
  }) : super(
       controller: controller,
       
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
            textEditingController: textEditingController,
            focusNode: focusNode,
            onTapOutside: (e){
              onClear(false);
            },
            labelText: label,
            suffixIcon: textEditingController.text.isEmpty? 
            Icon(Icons.search, color: AppColor.grey400,):
            AppIconButton(
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
            dense: true,
            visualDensity: VisualDensity.compact,
            splashColor: AppColor.grey200,
            tileColor: AppColor.whiteColor,
            title: Text(displayText(suggestion), style: AppTextStyle.textBodyStyle(),),
          );
        },
        
        loadingBuilder: (context){
          return ListTile(
            tileColor: AppColor.whiteColor,
            leading: SizedBox(
              width: 20, height: 20,
              child: CircularProgressIndicator(
                color: AppColor.primaryColor,
              ),
            ),
            title: Text("Memuat...", style: AppTextStyle.textBodyStyle(),)
          );
        },
        
        onSelected: (T suggestion) {
          onSelected(getId(suggestion));
          
        },
      );
}
