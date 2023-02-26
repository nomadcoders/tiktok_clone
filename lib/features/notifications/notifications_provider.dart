import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';

class NotificationsProvider extends AsyncNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> updateToken(String token) async {
    final user = ref.read(authRepo).user;
    await _db.collection("users").doc(user!.uid).update({"token": token});
  }

  Future<void> initListeners() async {
    final permission = await _messaging.requestPermission();
    if (permission.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }
    // Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("I just got a message and I'm in the foreground");
      print(event.notification?.title);
    });
  }

  @override
  FutureOr build() async {
    final token = await _messaging.getToken();
    if (token == null) return;
    await updateToken(token);
    await initListeners();
    _messaging.onTokenRefresh.listen((newToken) async {
      await updateToken(newToken);
    });
  }
}

final notificationsProvider = AsyncNotifierProvider(
  () => NotificationsProvider(),
);
