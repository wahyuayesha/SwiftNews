import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:newsapp/controllers/bookmark_controller.dart';
import 'package:newsapp/models/news.dart';
import 'package:newsapp/models/user.dart';

class FireServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // USER FUNCTIONS

  // FUNCTION FIRESERVICES: untuk mengambil data user dari Firestore
  Future<UserModel?> fetchUserData(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  // FUNCTION FIRESERVICES: untuk memperbarui data user
  Future<String?> updateUserData({
    required String currentPassword,
    required String newUsername,
    required String newProfilePictureUrl,
    required String newPassword,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return 'User not logged in';

      // Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Update password jika diisi
      if (newPassword.isNotEmpty) {
        await user.updatePassword(newPassword);
      }

      // Update Firestore
      Map<String, dynamic> data = {};
      if (newUsername.isNotEmpty) data['username'] = newUsername;
      if (newProfilePictureUrl.isNotEmpty) {
        data['profilePicture'] = newProfilePictureUrl;
      }

      if (data.isNotEmpty) {
        await _db.collection('users').doc(user.uid).update(data);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return e.code == 'wrong-password'
          ? 'Password incorrect'
          : e.message ?? 'Auth error';
    } catch (e) {
      return 'Unknown error: $e';
    }
  }

  // FUNCTION FIRESERVICES: untuk simpan report bug ke Firestore
  Future<String?> reportBug(String bugReport, String email, String username) async {
    try {
      await _db.collection('bug_report').add({
        'email': email,
        'username': username,
        'bug_report': bugReport,
        'sendAt': Timestamp.now(),
      });
      return null; // sukses, tidak ada error
    } on FirebaseException catch (e) {
      return e.message ?? 'Failed to report bug';
    } catch (e) {
      return 'Unknown error: $e';
    }
  }

  // BOOKMARK FUNCTIONS

  // FUNCTION FIRESERVICE: untuk menyimpan/menambahkan berita yang dibookmark ke database
  Future<String?> addBookmark(News news, String email) async {
    try {
      await _db.collection('bookmarked').add({
        'title': news.title,
        'url': news.url,
        'urlToImage': news.imageUrl,
        'source': news.source,
        'email': email,
        'publishedAt': news.publishedAt,
      });
      return null; // sukses, tidak ada error
    } catch (e) {
      return 'Failed to add bookmark: $e';
    }
  }

  // FUNCTION SERVICE: menghapus sebuah berita yang tersimpan di bookmark firestore
  Future<String?> removeBookmark(News news, String email) async {
    try {
      final snapshot =
          await _db
              .collection('bookmarked')
              .where('url', isEqualTo: news.url)
              .where('email', isEqualTo: email)
              .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      return null; // sukses, tidak ada error
    } catch (e) {
      return 'Failed to delete bookmark: $e';
    }
  }

  // FUNCTION SERVICE: mengambil data berita-berita yang telah di bookmark oleh user dari firestore
  Future<String?> fetchBookmarkedNews(String? email) async {
    try {
      if (email == null) return 'User not logged in';

      final snapshot =
          await _db
              .collection('bookmarked')
              .where('email', isEqualTo: email)
              .get();

      final bookmarkController = Get.find<BookmarkController>();
      bookmarkController.bookmarked_news.clear();
      for (var doc in snapshot.docs) {
        bookmarkController.bookmarked_news.add(
          News(
            title: doc['title'] ?? 'No Title',
            url: doc['url'] ?? '',
            imageUrl: doc['urlToImage'] ?? '',
            source: doc['source'] ?? 'No Source',
            publishedAt: doc['publishedAt'] ?? '',
          ),
        );
      }
      return null; // sukses, tidak ada error
    } catch (e) {
      return 'Failed to fetch bookmarks: $e';
    }
  }

  // FUNCTION SERVICE: menghapus seluruh bookmark yang disimpan user
  Future<String?> deleteFirestoreBookmarks(String email) async {
    try {
      final snapshot =
          await _db
              .collection('bookmarked')
              .where('email', isEqualTo: email)
              .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      return null;
    } catch (e) {
      return 'Failed to delete bookmark: $e';
    }
  }
}
