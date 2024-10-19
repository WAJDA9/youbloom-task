import 'package:flutter/material.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:youbloom/const/colors.dart';
import 'package:youbloom/const/text.dart';

class CountryCodeField extends StatefulWidget {
  final TextEditingController controller;

  const CountryCodeField({super.key, required this.controller});

  @override
  State<CountryCodeField> createState() => _CountryCodeFieldState();
}

class _CountryCodeFieldState extends State<CountryCodeField> {
  String? countryCode;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntlPhoneField(
          showDropdownIcon: false,
          disableLengthCheck: true,
          controller: widget.controller,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            filled: true,
            fillColor: AppColors.fieldsColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
          ),
          initialCountryCode: 'TN',
          pickerDialogStyle: PickerDialogStyle(
            backgroundColor: AppColors.fieldsColor,
            searchFieldCursorColor: AppColors.primaryColor,
            searchFieldInputDecoration: InputDecoration(
              hintText: 'Search by name or dial code',
              hintStyle: AppTextStyle.infoText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.labelsColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.primaryColor),
              ),
            ),
          ),
          onCountryChanged: (phone) {
            widget.controller.text = phone.dialCode;
          },
        ),
      ],
    );
  }
}
