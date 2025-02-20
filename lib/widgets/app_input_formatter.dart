import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:xhalona_pos/core/theme/theme.dart';
import 'package:xhalona_pos/widgets/app_elevated_button.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue.copyWith(text: '');

    // Hapus semua karakter non-digit
    String cleaned = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Konversi kembali ke format angka
    int value = int.tryParse(cleaned) ?? 0;
    String formatted = _formatter.format(value);

    // Kembalikan nilai yang diformat
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

Widget buildTextField(
  String label,
  String hint,
  TextEditingController controller, {
  TextInputType keyboardType = TextInputType.text,
  List<TextInputFormatter>? inputFormatters,
  bool isEnabled = true,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    enabled: isEnabled,
    inputFormatters: inputFormatters,
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return '$label tidak boleh kosong';
      }
      return null;
    },
  );
}

Widget buildDropdownFieldJK(
    String label, List<String> items, ValueChanged<String?> onChanged,
    {bool enabled = true}) {
  return DropdownButtonFormField<String>(
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
    ),
    items: items.map((item) {
      return DropdownMenuItem(value: item, child: Text(item));
    }).toList(),
    onChanged: enabled ? onChanged : null, // Disable onChanged if not enabled
    validator: (value) {
      if (value == null || value.isEmpty) {
        return '$label tidak boleh kosong';
      }
      return null;
    },
    disabledHint: Text('Pilih $label'), // Optional: hint when disabled
  );
}

Widget masterButton(VoidCallback onTap, String label, IconData icon) {
  return AppElevatedButton(
    onPressed: onTap,
    foregroundColor: AppColor.primaryColor,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColor.primaryColor,
        ),
        SizedBox(width: 8),
        Text(label, style: AppTextStyle.textSubtitleStyle()),
      ],
    ),
  );
}

Widget buildShimmerLoading() {
  return ListView.builder(
    padding: EdgeInsets.all(16),
    itemCount: 10,
    itemBuilder: (context, index) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 16,
          margin: EdgeInsets.symmetric(vertical: 8),
          color: Colors.white,
        ),
      );
    },
  );
}
