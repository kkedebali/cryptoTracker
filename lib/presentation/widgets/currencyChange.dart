import 'package:flutter/material.dart';

class CurrencyDropdown extends StatelessWidget {
  final String selectedCurrency;
  final ValueChanged<String?> onCurrencyChanged;

  const CurrencyDropdown({
    super.key,
    required this.selectedCurrency,
    required this.onCurrencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: selectedCurrency,
        dropdownColor: Colors.black87,
        underline: const SizedBox(),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        items: const [
          DropdownMenuItem(value: 'try', child: Text('TRY (₺)', style: TextStyle(color: Colors.white))),
          DropdownMenuItem(value: 'usd', child: Text('USD (\$)', style: TextStyle(color: Colors.white))),
          DropdownMenuItem(value: 'eur', child: Text('EUR (€)', style: TextStyle(color: Colors.white))),
        ],
        onChanged: onCurrencyChanged, // Dışarıdan gelen fonksiyonu tetikler
      ),
    );
  }
}