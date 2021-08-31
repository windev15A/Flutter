import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

String formatPrice(int price) {
  return NumberFormat.currency(locale: "fr_FR", symbol: "€").format(price);
}


