import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class RaidService {
  RaidService({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;
  
  // Future-based lock to prevent race conditions during transaction retries in local mock environments.
  static Future<void> _lock = Future.value();

  Future<bool> joinRaid({required String userId}) async {
    final completer = Completer<bool>();
    
    // We chain the calls to ensure they hit the mock one-by-one,
    // while still utilizing the real Firestore Transaction logic.
    _lock = _lock.then((_) async {
      try {
        final result = await _executeJoinTransaction(userId);
        completer.complete(result);
      } catch (e) {
        completer.completeError(e);
      }
    });

    return completer.future;
  }

  Future<bool> _executeJoinTransaction(String userId) async {
    final docRef = _firestore
        .collection('events')
        .doc('dragon_raid');

    return _firestore.runTransaction<bool>((transaction) async {
      final snapshot = await transaction.get(docRef);
      final filled = (snapshot.data()?['slots_filled'] as int?) ?? 0;
      final max    = (snapshot.data()?['max_slots']    as int?) ?? 15;

      if (filled >= max) return false;  // slot full — graceful fail

      // @AETHER: FieldValue.increment is atomic server-side.
      transaction.update(docRef, {
        'slots_filled': FieldValue.increment(1),
      });
      return true;
    });
  }

  /// Stream of raid data for real-time UI updates
  Stream<DocumentSnapshot<Map<String, dynamic>>> get raidStream =>
      _firestore.collection('events').doc('dragon_raid').snapshots();

  /// Real-time stream of the last 50 messages to maintain performance and control read costs.
  Stream<QuerySnapshot<Map<String, dynamic>>> get chatStream => _firestore
      .collection('events')
      .doc('dragon_raid')
      .collection('messages')
      .orderBy('timestamp', descending: true)
      .limit(50)
      .snapshots();

  /// Sends a message using Server Timestamps to prevent clock drift.
  Future<void> sendMessage(String text, String userId) async {
    await _firestore
        .collection('events')
        .doc('dragon_raid')
        .collection('messages')
        .add({
      'text': text,
      'userId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
