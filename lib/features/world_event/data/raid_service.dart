import 'package:cloud_firestore/cloud_firestore.dart';

class RaidService {
  final FirebaseFirestore _firestore;

  RaidService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Joins the dragon raid using a Transaction to prevent race conditions.
  /// Returns [true] if the slot was successfully reserved.
  Future<bool> joinRaid({required String userId}) async {
    // @AETHER: Using a Transaction to ensure atomic integrity in high-concurrency MMO scenarios.
    // This prevents the "Thundering Herd" problem where multiple users might claim the last slot.
    
    try {
      return await _firestore.runTransaction((transaction) async {
        final raidRef = _firestore.collection('events').doc('dragon_raid');
        final snapshot = await transaction.get(raidRef);

        if (!snapshot.exists) {
          throw Exception("Raid event does not exist in Firestore.");
        }

        final int slotsFilled = snapshot.data()?['slots_filled'] ?? 0;
        final int maxSlots = snapshot.data()?['max_slots'] ?? 0;

        // Check if there is still room
        if (slotsFilled < maxSlots) {
          // Increment the slot count atomically
          transaction.update(raidRef, {'slots_filled': slotsFilled + 1});
          
          // @AETHER: Successfully reserved slot. Transaction guaranteed exactly 1 winner for this slot.
          return true;
        } else {
          // Raid is full
          return false;
        }
      });
    } catch (e) {
      // In a real app, you'd log this to Crashlytics
      return false;
    }
  }

  /// Stream of raid data for real-time UI updates
  Stream<DocumentSnapshot<Map<String, dynamic>>> get raidStream =>
      _firestore.collection('events').doc('dragon_raid').snapshots();
}
