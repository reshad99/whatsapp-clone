import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsapp_clone/core/widgets/error_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/login_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp_clone/features/chat/screens/components/flick_video_player.dart';
import 'package:whatsapp_clone/features/chat/screens/components/image_show.dart';
import 'package:whatsapp_clone/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:whatsapp_clone/features/status/screens/status_confirm.dart';
import 'package:whatsapp_clone/features/status/screens/status_view.dart';
import 'package:whatsapp_clone/models/story.dart';
import 'package:whatsapp_clone/models/user.dart';
import 'package:whatsapp_clone/features/chat/screens/mobile_chat_screen.dart';
import 'package:whatsapp_clone/screens/mobile_screen_layout.dart';

class RouteGenerator {
  static Route<dynamic>? generate(RouteSettings settings) {
    switch (settings.name) {
      case '/login-screen':
        return _buildRoute(const LoginScreen());

      case '/otp-screen':
        return _buildRoute(OtpScreen(
          verificationId: settings.arguments as String,
        ));

      case '/user-info':
        return _buildRoute(const UserInformationScreen());

      case '/home':
        return _buildRoute(MobileScreenLayout(
          animateTab: settings.arguments as int?,
        ));

      case '/select-contact':
        return _buildRoute(const SelectContactsScreen());

      case '/chat-screen':
        var arguments = settings.arguments as Map<String, dynamic>;
        final UserModel user = arguments['user'];
        return _buildRoute(MobileChatScreen(
          user: user,
        ));

      case '/flick-video-player':
        return _buildRoute(FlickVideoPlayerWidget(
            videoPlayerController:
                settings.arguments as VideoPlayerController));

      case '/image-show':
        return _buildRoute(ImageShow(url: settings.arguments as String));

      case '/status-confirm':
        return _buildRoute(StatusConfirm(file: settings.arguments as File));

      case '/story-view':
        var arguments = settings.arguments as Map<String, dynamic>;
        final UserModel user = arguments['user'];
        final List<Story> stories = arguments['stories'];

        return _buildRoute(StoryViewScreen(
          stories: stories,
          user: user,
        ));

      default:
        return _buildRoute(
          const ErrorScreen(),
        );
    }
  }

  static Route<dynamic> _buildRoute(Widget page) {
    return _isIOSPlatform()
        ? CupertinoPageRoute(builder: (_) => page)
        : MaterialPageRoute(builder: (_) => page);
  }

  static bool _isIOSPlatform() {
    return defaultTargetPlatform == TargetPlatform.iOS;
  }
}
