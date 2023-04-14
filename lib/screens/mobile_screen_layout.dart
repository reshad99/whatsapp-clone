import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/utils/colors.dart';
import 'package:whatsapp_clone/common/utils/helpers.dart';
import 'package:whatsapp_clone/common/utils/info.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/chat/screens/contacts_list.dart';
import 'package:whatsapp_clone/features/status/screens/status_screen.dart';
import 'package:whatsapp_clone/services/firebase_messaging.dart';

class MobileScreenLayout extends ConsumerStatefulWidget {
  const MobileScreenLayout({this.animateTab, super.key});
  final int? animateTab;

  @override
  ConsumerState<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends ConsumerState<MobileScreenLayout>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    ref.read(authControllerProvider).changeUserState(true);
    tabController = TabController(length: 3, vsync: this);
    if (widget.animateTab != null) {
      tabController.animateTo(widget.animateTab!);
    }
    WidgetsBinding.instance.addObserver(this);
    ref.read(firebaseMessagingServiceProvider).initialize(context);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('Life cycle tetiklendi');
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).changeUserState(true);
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).changeUserState(false);
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          backgroundColor: appBarColor,
          appBar: AppBar(
            title: const Text(
              'Whatsapp',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
            ],
            bottom: TabBar(
                controller: tabController,
                indicatorColor: tabColor,
                indicatorWeight: 4,
                onTap: (value) {
                  ref.read(tabIndexProvider.notifier).update((state) => value);
                },
                labelColor: tabColor,
                unselectedLabelColor: Colors.grey,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(
                    child: Text('CHATS'),
                  ),
                  Tab(
                    child: Text('STATUS'),
                  ),
                  Tab(
                    child: Text('CALLS'),
                  ),
                ]),
          ),
          body: TabBarView(controller: tabController, children: const [
            ContactsList(),
            StatusScreen(),
            Center(
              child: Text('af'),
            )
          ]),
          floatingActionButton: getFloatingButton(ref)),
    );
  }
}

class SelectContactButton extends StatelessWidget {
  const SelectContactButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/select-contact');
        },
        child: const Icon(Icons.comment));
  }
}
