import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whatsapp_clone/features/status/repository/status_repository.dart';
import 'package:whatsapp_clone/models/status.dart';
import 'package:whatsapp_clone/models/story.dart';
import 'package:whatsapp_clone/models/user.dart';

final statusControllerProvider = Provider((ref) {
  final statusRepo = ref.read(statusRepositoryProvider);
  return StatusController(statusRepository: statusRepo, ref: ref);
});

final currentStatusUidProvider = StateProvider<String>((ref) {
  return '';
});

final currentStoryUidProvider = StateProvider<String>((ref) {
  return '';
});

class StatusController {
  final StatusRepository statusRepository;
  final ProviderRef ref;
  StatusController({
    required this.statusRepository,
    required this.ref,
  });

  void saveStory(BuildContext context, File file, String? text) {
    statusRepository.saveStory(context: context, file: file, text: text);
  }

  Future<bool> checkOwnStatuses() {
    return statusRepository.checkOwnStatuses();
  }

  Future<List<Status>> getOtherStatuses() {
    return statusRepository.getOtherStatuses();
  }

  Future<List<Story>> getStoriesByStatusId(
      BuildContext context, String statusId) {
    return statusRepository.getStoriesByStatus(
        statusId: statusId, context: context);
  }

  Stream<List<UserModel>> getWhoHasSeen(String statusUid) {
    return statusRepository.getWhoHasSeen(statusUid);
  }

  Future<void> viewStatus(String statusId, String storyId) {
    return statusRepository.viewStory(statusId, storyId);
  }
}
