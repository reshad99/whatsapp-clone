import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/init.dart';
import 'package:whatsapp_clone/screens/my_app.dart';

void main() async {
  await init();
  runApp(const ProviderScope(child: MyApp()));
}
