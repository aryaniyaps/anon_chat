import 'package:flutter/material.dart';

Color colorFromUserId(String userId) {
  int hashCode = userId.hashCode;
  int red = (hashCode & 0xFF0000) >> 16;
  int green = (hashCode & 0x00FF00) >> 8;
  int blue = (hashCode & 0x0000FF);

  Color color = Color.fromARGB(255, red, green, blue);

  // Check contrast ratio against white background
  double contrastRatio = _calculateContrastRatio(color, Colors.white);
  double minimumContrastRatio = 4.5; // Minimum contrast ratio for accessibility

  // Adjust color if contrast ratio is below the threshold
  if (contrastRatio < minimumContrastRatio) {
    // darken color for better contrast
    color = darkenColor(color, 0.4);
  }

  return color;
}

Color darkenColor(Color color, double amount) {
  assert(
    amount >= 0 && amount <= 1,
    'Darken amount should be between 0 and 1.',
  );

  int red = (color.red * (1 - amount)).round();
  int green = (color.green * (1 - amount)).round();
  int blue = (color.blue * (1 - amount)).round();

  return Color.fromARGB(color.alpha, red, green, blue);
}

double _calculateContrastRatio(Color first, Color second) {
  // Calculate contrast ratio using the relative luminance formula
  double luminance1 = _calculateRelativeLuminance(first);
  double luminance2 = _calculateRelativeLuminance(second);
  double contrastRatio = (luminance1 + 0.05) / (luminance2 + 0.05);
  return contrastRatio;
}

double _calculateRelativeLuminance(Color color) {
  double red = color.red / 255;
  double green = color.green / 255;
  double blue = color.blue / 255;

  return 0.2126 * red + 0.7152 * green + 0.0722 * blue;
}
