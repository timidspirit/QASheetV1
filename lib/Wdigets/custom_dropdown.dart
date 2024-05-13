import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qasheets/utils/app_styles.dart';

class CustomDropDown extends StatelessWidget {
  final String? _selectedValue;

  const CustomDropDown(this._selectedValue, {super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      key: UniqueKey(),
      items: const [
        'Pilot New Hire',
        'Pilot Shared',
        'Pilot Break Fix',
        'M&E Break Fix',
        'M&E New Hire',
        'CSA Shared',
        'CSA Training',
        'CSA Break Fix',
        'CSA New Hire',
        'FA Duty Phone',
        'FA Shared',
        'FA Break Fix',
        'FA New Hire',
        'WIP Other',
      ],
      onChanged: (String? newValue) {
        if (kDebugMode) {
          print(newValue);
        } // Replace with your method to handle the change
      },
      selectedItem: _selectedValue,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: 'Select or search an option',
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppTheme.accent),
          ),
        ),
      ),
      popupProps: PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: "Search...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppTheme.accent),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          ),
        ),
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Please select a build sheet.';
        }
        return null;
      },
    );
  }
}
