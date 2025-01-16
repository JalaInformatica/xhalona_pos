import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_elevated_button.dart';
import 'package:xhalona_pos/widgets/app_text_field.dart';

AppTextField posTextField({
  required BuildContext context,
  required TextEditingController textEditingController,
  required labelText,
  bool isReadOnly = false,
  }){
  return AppTextField(
    context: context,
    textEditingController: textEditingController,
    labelText: labelText,
    contentPadding: EdgeInsets.symmetric(
      horizontal: 5.w, 
      vertical: 5.h
    ),
    readOnly: isReadOnly,
  );
}

AppElevatedButton posAppButton({
  required String text, 
  required VoidCallback onPressed
  }){
  return AppElevatedButton(
    backgroundColor: AppColor.whiteColor,  
    foregroundColor: AppColor.primaryColor,
    borderColor: AppColor.primaryColor,
    padding: EdgeInsets.symmetric(horizontal: 5.w),
    onPressed: onPressed, 
    text: Text(text)
    );
}

// DropdownSearch<EmployeeDAO>(
//                               selectedItem: null,
//                               mode: Mode.form,  
//                               suffixProps: DropdownSuffixProps(
//                                 dropdownButtonProps: DropdownButtonProps(
//                                   iconOpened: Icon(Icons.arrow_drop_down),
//                                   iconClosed: Icon(Icons.arrow_drop_down),
//                                   iconSize: 24,
//                                   style: IconButton.styleFrom(
//                                     visualDensity: VisualDensity.compact,
//                                     padding: EdgeInsets.zero,
//                                     tapTargetSize: MaterialTapTargetSize.shrinkWrap
//                                   )
//                                 )
//                               ),
//                               onChanged: (EmployeeDAO? selectedEmployee) {
//                                 if (selectedEmployee != null) {
//                                   print("Selected Employee: ${selectedEmployee.fullName}");
//                                 }
//                               },
//                               items: controller.getEmployees,  
//                                 dropdownBuilder: (BuildContext context, EmployeeDAO? selectedItem) {
//                                   return Text(
//                                     selectedItem?.fullName ?? "Terapis",
//                                     style: AppTextStyle.textBodyStyle(),
//                                   );
//                                 },
//                                 decoratorProps: DropDownDecoratorProps(
//                                   decoration: InputDecoration(
//                                     isDense: true,
//                                     contentPadding: EdgeInsets.only(left: 5.w),
//                                     border: OutlineInputBorder(
//                                       gapPadding: 0,
//                                       borderSide: BorderSide(color: AppColor.grey300),
//                                       borderRadius: BorderRadius.circular(5)
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       gapPadding: 0,
//                                       borderSide: BorderSide(color: AppColor.grey300),
//                                       borderRadius: BorderRadius.circular(5)
//                                     )
//                                   )
//                                 ),
//                               itemAsString: (EmployeeDAO? employee) => employee?.fullName ?? '',
//                               compareFn: (EmployeeDAO a, EmployeeDAO b) => a.empId == b.empId,  
//                               popupProps: PopupProps.menu(
//                                 showSearchBox: true,  
//                                 searchDelay: Duration(milliseconds: 1000), 
//                                 constraints: BoxConstraints(maxHeight: 300),
//                                 itemBuilder: (context, item, isSelected, isFocused) {
//                                   return ListTile(
//                                     title: Text(item.fullName),
//                                     selected: isSelected,  
//                                     tileColor: isFocused ? Colors.grey.shade200 : null, 
//                                   );
//                                 },
//                                 searchFieldProps: TextFieldProps(
//                                   decoration: InputDecoration(
//                                     hintText: "Cari Terapis",
//                                     border: OutlineInputBorder(
//                                       gapPadding: 0,
//                                       borderSide: BorderSide(color: AppColor.grey300),
//                                       borderRadius: BorderRadius.circular(5)
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       gapPadding: 0,
//                                       borderSide: BorderSide(color: AppColor.grey300),
//                                       borderRadius: BorderRadius.circular(5)
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       gapPadding: 0,
//                                       borderSide: BorderSide(color: AppColor.primaryColor),
//                                       borderRadius: BorderRadius.circular(5)
//                                     ),  
//                                     contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),  // Padding inside the search box
//                                   ),
//                                   style: TextStyle(fontSize: 16, color: Colors.black),  // Customize the text style
//                                   autofocus: true, 
//                                 ),
//                               ),
                              
//                               validator: (EmployeeDAO? employee) =>
//                                   employee == null ? "Please select an employee" : null,  // Validation for selection
//                             ),