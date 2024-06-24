import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get a reference to a specific collection
  CollectionReference collection(String collectionPath) {
    return _firestore.collection(collectionPath);
  }

  // Get a document by its ID from a specific collection
  Future<DocumentSnapshot<Object?>> getDocument(
      String collectionPath, String documentId) async {
    return await collection(collectionPath).doc(documentId).get();
  }

  // Add a new document to a collection
  Future<void> addDocument(String collectionPath, Map<String, dynamic> data) async {
    await collection(collectionPath).add(data);
  }

  // Update an existing document
  Future<void> updateDocument(String collectionPath, String documentId, Map<String, dynamic> data) async {
    await collection(collectionPath).doc(documentId).update(data);
  }

  // Delete a document
  Future<void> deleteDocument(String collectionPath, String documentId) async {
    await collection(collectionPath).doc(documentId).delete();
  }

  // Stream to listen for real-time changes in a collection
  Stream<QuerySnapshot<Object?>> streamCollection(String collectionPath) {
    return collection(collectionPath).snapshots();
  }

  // Stream to listen for real-time changes in a document
  Stream<DocumentSnapshot<Object?>> streamDocument(String collectionPath, String documentId) {
    return collection(collectionPath).doc(documentId).snapshots();
  }
}
