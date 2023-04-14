import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/widgets/custom_error_screen.dart';
import 'package:whatsapp_clone/common/widgets/loading_screen.dart';
import 'package:whatsapp_clone/features/select_contacts/controller/select_contacts_controller.dart';
import 'package:whatsapp_clone/features/select_contacts/screens/components/contact_widget.dart';

class SelectContactsScreen extends ConsumerWidget {
  const SelectContactsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select contact'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2));
        },
        child: ref.watch(getContactsProvider).when(
          data: (data) {
            return buildContactList(data);
          },
          error: (error, stackTrace) {
            return CustomErrorScreen(error: error.toString());
          },
          loading: () {
            return const LoadingScreen();
          },
        ),
      ),
    );
  }

  ListView buildContactList(List<Contact?> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        var contact = data[index];
        return ContactWidget(contact: contact!);
      },
    );
  }
}
