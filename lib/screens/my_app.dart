import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/common/utils/colors.dart';
import 'package:whatsapp_clone/common/widgets/custom_error_screen.dart';
import 'package:whatsapp_clone/common/widgets/loading_screen.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/landing/screens/landing_screen.dart';
import 'package:whatsapp_clone/screens/mobile_screen_layout.dart';
import 'package:whatsapp_clone/services/firebase_messaging.dart';
import 'package:whatsapp_clone/services/router.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp Clone',
      onGenerateRoute: (settings) => RouteGenerator.generate(settings),
      theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: backgroundColor,
          floatingActionButtonTheme:
              const FloatingActionButtonThemeData(backgroundColor: tabColor),
          appBarTheme: const AppBarTheme(backgroundColor: appBarColor)),
      home: Builder(
        builder: (context) {
          return ref.watch(authCheckProvider).when(
            data: (userModel) {
              return ScreenUtilInit(
                builder: (context, child) {
                  if (userModel == null) return const LandingScreen();

                  return const MobileScreenLayout();
                },
                designSize: MediaQuery.of(context).size,
              );
            },
            error: (error, stackTrace) {
              debugPrint(error.toString());
              debugPrint(stackTrace.toString());
              return CustomErrorScreen(
                error: error.toString(),
              );
            },
            loading: () {
              return const LoadingScreen();
            },
          );
        },
      ),
    );
  }
}
