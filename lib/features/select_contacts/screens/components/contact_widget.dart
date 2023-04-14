import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/features/select_contacts/controller/select_contacts_controller.dart';

class ContactWidget extends ConsumerWidget {
  const ContactWidget({
    super.key,
    required this.contact,
  });

  final Contact contact;

  void selectData(BuildContext context, Contact contact, WidgetRef ref) {
    ref
        .read(selectContactControllerProvider)
        .selectContact(context, contact, ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        selectData(context, contact, ref);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: ListTile(
          title: Text(
            contact.displayName,
            style: const TextStyle(fontSize: 18),
          ),
          leading: contact.photo != null
              ? CircleAvatar(
                  backgroundImage: MemoryImage(contact.photo!),
                  radius: 30,
                )
              : null,
        ),
      ),
    );
  }
}
