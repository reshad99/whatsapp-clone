// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp_clone/features/select_contacts/repository/select_contact_repository.dart';

final getContactsProvider = FutureProvider((ref) {
  final selectContactRepository = ref.watch(selectContactRepositoryProvider);
  return selectContactRepository.getContacts();
});

final selectContactControllerProvider = Provider((ref) {
  final selectContactRepository = ref.watch(selectContactRepositoryProvider);
  return SelectContactsController(
      ref: ref, selectContactRepository: selectContactRepository);
});

class SelectContactsController {
  SelectContactsController({
    required this.ref,
    required this.selectContactRepository,
  });

  final ProviderRef ref;
  final SelectContactRepository selectContactRepository;

  void selectContact(BuildContext context, Contact contact, WidgetRef ref) {
    selectContactRepository.selectContact(context, contact, ref);
  }
}
