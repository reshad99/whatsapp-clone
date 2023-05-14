import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const double maxZoomScale = 5;
const double minZoomScale = 1;
const double messageFontSize = 16;
final sizeProvider = StateProvider<Size>((ref) {
  return const Size(200, 200);
});

final tabIndexProvider = StateProvider<int>((ref) {
  return 0;
});
