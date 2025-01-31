import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tescom_helpdesk/models/request_model.dart';

// StreamProvider for real-time updates
final requestProvider = StreamProvider<List<Request>>((ref) {
  final firestore = FirebaseFirestore.instance;

  // Return a stream of requests from Firestore
  return firestore.collection('requests').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      return Request.fromJson(doc.data());
    }).toList();
  });
});

// Helper methods for Firestore operations
class RequestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new request
  Future<void> addRequest(Request request) async {
    await _firestore
        .collection('requests')
        .doc(request.id)
        .set(request.toJson());
  }

  // Update request status
  Future<void> updateRequestStatus(String id, String status) async {
    await _firestore.collection('requests').doc(id).update({'status': status});
  }
}

// Provider for RequestService
final requestServiceProvider = Provider<RequestService>((ref) {
  return RequestService();
});
