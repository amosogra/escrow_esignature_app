import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Simulated backend service that stores data locally
class BackendService {
  static final BackendService instance = BackendService._internal();
  BackendService._internal();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Register a new user account
  Future<Map<String, dynamic>> registerUser(Map<String, dynamic> userData) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Generate a unique user ID
    final userId = DateTime.now().millisecondsSinceEpoch.toString();

    // Add user ID and creation date
    final userRecord = {
      ...userData,
      'userId': userId,
      'createdAt': DateTime.now().toIso8601String(),
      'status': 'active',
    };

    // Save user data
    await _prefs.setString('user_$userId', jsonEncode(userRecord));

    // Save current user ID
    await _prefs.setString('current_user_id', userId);

    // Add to users list
    final usersList = await getAllUsers();
    usersList.add(userRecord);
    await _saveUsersList(usersList);

    return userRecord;
  }

  /// Login user with email and password
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    final usersList = await getAllUsers();

    try {
      final user = usersList.firstWhere(
        (user) => user['email'] == email && user['password'] == password,
      );

      // Set as current user
      await _prefs.setString('current_user_id', user['userId']);

      return user;
    } catch (e) {
      return null;
    }
  }

  /// Get current logged-in user
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final userId = _prefs.getString('current_user_id');

    if (userId == null) return null;

    final userJson = _prefs.getString('user_$userId');

    if (userJson != null) {
      return jsonDecode(userJson) as Map<String, dynamic>;
    }

    return null;
  }

  /// Update user data
  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final userJson = _prefs.getString('user_$userId');

    if (userJson != null) {
      final user = jsonDecode(userJson) as Map<String, dynamic>;
      user.addAll(updates);
      user['updatedAt'] = DateTime.now().toIso8601String();

      await _prefs.setString('user_$userId', jsonEncode(user));

      // Update in users list
      final usersList = await getAllUsers();
      final index = usersList.indexWhere((u) => u['userId'] == userId);
      if (index != -1) {
        usersList[index] = user;
        await _saveUsersList(usersList);
      }
    }
  }

  /// Get all users (for admin/testing purposes)
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final usersJson = _prefs.getString('users_list');

    if (usersJson != null) {
      final List<dynamic> decoded = jsonDecode(usersJson);
      return decoded.map((e) => e as Map<String, dynamic>).toList();
    }

    return [];
  }

  /// Save users list
  Future<void> _saveUsersList(List<Map<String, dynamic>> users) async {
    await _prefs.setString('users_list', jsonEncode(users));
  }

  /// Logout current user
  Future<void> logout() async {
    await _prefs.remove('current_user_id');
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    return _prefs.getString('current_user_id') != null;
  }

  /// Create Anchor account
  Future<Map<String, dynamic>> createAnchorAccount(Map<String, dynamic> anchorData) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1000));

    final user = await getCurrentUser();

    if (user == null) {
      throw Exception('No user logged in');
    }

    final anchorAccount = {
      ...anchorData,
      'anchorAccountId': 'ANCHOR_${DateTime.now().millisecondsSinceEpoch}',
      'userId': user['userId'],
      'createdAt': DateTime.now().toIso8601String(),
      'status': 'active',
    };

    // Save Anchor account
    await _prefs.setString('anchor_account_${user['userId']}', jsonEncode(anchorAccount));

    // Update user with Anchor account ID
    await updateUser(user['userId'], {
      'anchorAccountId': anchorAccount['anchorAccountId'],
      'hasAnchorAccount': true,
    });

    return anchorAccount;
  }

  /// Get Anchor account for current user
  Future<Map<String, dynamic>?> getAnchorAccount() async {
    final user = await getCurrentUser();

    if (user == null) return null;

    final anchorJson = _prefs.getString('anchor_account_${user['userId']}');

    if (anchorJson != null) {
      return jsonDecode(anchorJson) as Map<String, dynamic>;
    }

    return null;
  }

  /// Clear all data (for testing/demo purposes)
  Future<void> clearAllData() async {
    await _prefs.clear();
  }
}
