import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/models/message.dart';
import 'package:tiktok_clone/features/inbox/repos/messages_repo.dart';

class MessagesViewModel extends AsyncNotifier<void> {
  late final MessagesRepo _repo;

  @override
  FutureOr<void> build() {
    _repo = ref.read(messagesRepo);
  }

  Future<void> sendMessage(String text) async {
    final user = ref.read(authRepo).user;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final message = MessageModel(
        text: text,
        userId: user!.uid,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      await _repo.sendMessage(message);
    });
  }
}

final messagesProvider = AsyncNotifierProvider<MessagesViewModel, void>(
  () => MessagesViewModel(),
);

final chatProvider = StreamProvider.autoDispose
    .family<List<MessageModel>, String>((ref, chatRoomId) {
  final db = FirebaseFirestore.instance;

  return db
      .collection("chat_rooms")
      .doc("5wIEF4qSGhFMKms4Pjuu")
      .collection("texts")
      .orderBy("createdAt")
      .snapshots()
      .map((event) => event.docs
          .map(
            (doc) => MessageModel.fromJson(
              doc.data(),
            ),
          )
          .toList()
          .reversed
          .toList());
});
