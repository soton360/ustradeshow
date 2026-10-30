import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';
import '../constants/app_colors.dart';

/// Clean enterprise international phone input field powered by [phone_form_field].
/// Automatically attaches the country dial code (defaulting to BD +880 and US +1)
/// to ensure visitor SMS delivery never fails.
class CustomPhoneField extends StatelessWidget {
  final String label;
  final String? hint;
  final PhoneController controller;
  final bool isRequired;
  final String? helperText;
  final String? Function(PhoneNumber?)? customValidator;
  final ValueChanged<PhoneNumber?>? onChanged;

  const CustomPhoneField({
    super.key,
    this.label = 'Phone (optional)',
    this.hint = 'e.g. 01712-345678',
    required this.controller,
    this.isRequired = false,
    this.helperText,
    this.customValidator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                letterSpacing: -0.1,
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 3),
              const Text(
                '*',
                style: TextStyle(
                  color: AppColors.usaRed,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        PhoneFormField(
          controller: controller,
          isCountryButtonPersistent: true,
          countrySelectorNavigator:
              const CountrySelectorNavigator.modalBottomSheet(
            favorites: [IsoCode.BD, IsoCode.US],
            showDialCode: true,
            sortCountries: true,
            searchAutofocus: false,
          ),
          countryButtonStyle: const CountryButtonStyle(
            showFlag: true,
            showDialCode: true,
            showDropdownIcon: true,
            flagSize: 18,
            padding: EdgeInsets.symmetric(horizontal: 10),
            textStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryNavy,
            ),
          ),
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            helperText: helperText,
            helperStyle: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11.5,
            ),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border, width: 1.2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: AppColors.primaryNavy, width: 1.8),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.usaRed, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.usaRed, width: 1.8),
            ),
          ),
          validator: customValidator ??
              (PhoneNumber? phone) {
                if (phone == null || phone.nsn.trim().isEmpty) {
                  if (isRequired) {
                    return 'Please enter phone number for ticket SMS';
                  }
                  return null;
                }
                if (!phone.isValid()) {
                  return 'Please enter a valid phone number with country code';
                }
                return null;
              },
          onChanged: onChanged,
        ),
      ],
    );
  }
}

