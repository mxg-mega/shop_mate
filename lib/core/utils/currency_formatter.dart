import 'package:flutter/material.dart';

class CurrencyFormatter extends StatefulWidget {
  const CurrencyFormatter(
      {super.key, required this.number, required this.currency});

  final double number;
  final String currency;

  @override
  State<CurrencyFormatter> createState() => _CurrencyFormatterState();
}

class _CurrencyFormatterState extends State<CurrencyFormatter> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

String formatPrice({String? currency = '₦', required double price}) {
  // get the price
  // convert to string
  final convertPrice = price.toStringAsFixed(2);
  // 100.00 split at '.'
  final splitPrice = convertPrice.split('.');
  // count lenght of digits from right to left or invert and then start from left to right
  final int length = splitPrice[0].length;
  String formattedPrice = '';
  for (int i = length - 1; i >= 0; --i) {
    formattedPrice += splitPrice[0][length - i - 1];
    if (i % 3 == 0 && i != 0) {
      formattedPrice += ',';
    }
  }
  formattedPrice = '$formattedPrice.${splitPrice[1]}';
  return '$currency$formattedPrice';
}

String formatNumber({required double number}) {
  return number.toStringAsFixed(2);
}
