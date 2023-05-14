// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whatsapp_clone/features/status/repository/status_repository.dart';
import 'package:firebase_analytics_platform_interface/firebase_analytics_platform_interface.dart';

import 'package:whatsapp_clone/main.dart';
import 'package:whatsapp_clone/models/user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  setupFirebaseAnalyticsMocks();

  test('Test that whoHasSeen method gets the data properly', () async {
    String statusUrl = getStatusUrl();
    final ref = ProviderContainer();
    final statusRepoProvider = ref.read(statusRepositoryProvider);

    final result = statusRepoProvider.getWhoHasSeen(statusUrl);

    await expectLater(result, emits(isA<List<UserModel>>()));

    debugPrint(result.first.toString());
    expect(result.length, 2);
  });
}

String getStatusUrl() {
  return 'https://firebasestorage.googleapis.com/v0/b/whatsapp-clone-34977.appspot.com/o/status%2F212280ce-7457-4ff8-b484-ff9504ff43d1?alt=media&token=8c0a8cb4-a5f1-4909-ba75-732c5ff7a8c5';
}

typedef Callback = void Function(MethodCall call);

final List<MethodCall> methodCallLog = <MethodCall>[];

void setupFirebaseAnalyticsMocks([Callback? customHandlers]) {

  setupFirebaseCoreMocks();

TestDefaultBinaryMessengerBinding? binaryMessengerBinding = TestDefaultBinaryMessengerBinding.instance;
if (binaryMessengerBinding == null) {
  binaryMessengerBinding = TestDefaultBinaryMessengerBinding.instance;
  TestWidgetsFlutterBinding.ensureInitialized();
  binaryMessengerBinding!.defaultBinaryMessenger.setMockMethodCallHandler(
    MethodChannelFirebaseAnalytics.channel,
    (MethodCall methodCall) async {
      // ...
    },
  );
}
  TestDefaultBinaryMessengerBinding.instance?.defaultBinaryMessenger
      .setMockMethodCallHandler(MethodChannelFirebaseAnalytics.channel,
          (MethodCall methodCall) async {
            
    methodCallLog.add(methodCall);
    switch (methodCall.method) {
      case 'Analytics#getAppInstanceId':
        return 'ABCD1234';

      default:
        return false;
    }
  });
  
}
