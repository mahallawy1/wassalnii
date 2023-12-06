import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'toast.dart'; // Assuming you have this for displaying messages

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getToDoList() async {
    String userId = _auth.currentUser!.uid;
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('tasks').where('userId', isEqualTo: userId).get();
      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      showToast(message: 'Failed to retrieve to-do list.');
      return [];
    }
  }

  Stream<QuerySnapshot> getUserToDoList() {
    String userId = _auth.currentUser!.uid;
    return _firestore.collection('tasks')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }
  // Sign Up with Email and Password
  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(message: 'The email address is already in use.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
      return null;
    }
  }

  // Sign In with Email and Password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(message: 'Invalid email or password.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
      return null;
    }
  }

  // Add Task
  Future<void> addTask(String taskName, String priority, String deadline) async {
    String userId = _auth.currentUser!.uid;
    await _firestore.collection('tasks').add({
      'userId': userId,
      'taskName': taskName,
      'priority': priority,
      'deadline': deadline,
    });
  }

  // Edit Task
  Future<void> editTask(String docId, String taskName, String priority, String deadline) async {
    await _firestore.collection('tasks').doc(docId).update({
      'taskName': taskName,
      'priority': priority,
      'deadline': deadline,
    });
  }

  // Delete Task
  Future<void> deleteTask(String docId) async {
    await _firestore.collection('tasks').doc(docId).delete();
  }
}
