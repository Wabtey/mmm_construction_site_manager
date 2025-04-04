import 'package:http/http.dart' as http;
import 'package:mmm_construction_site_manager/api/model/role.dart';
import 'dart:convert';

import 'package:mmm_construction_site_manager/api/model/user.dart';

/// API Client
class UserApi {
  final String baseUrl;
  final http.Client _client;

  UserApi({required this.baseUrl, http.Client? client})
      : _client = client ?? http.Client();

  /// Get all users
  Future<List<User>> getAllUsers() async {
    final response = await _client.get(Uri.parse('$baseUrl/api/users'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  /// Get user by ID
  Future<User> getUser(String userId) async {
    final response = await _client.get(Uri.parse('$baseUrl/api/users/$userId'));

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else {
      throw Exception('Failed to load user');
    }
  }

  /// Get all usernames
  Future<List<String>> getUsernames() async {
    final response =
        await _client.get(Uri.parse('$baseUrl/api/users/usernames'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((username) => username as String).toList();
    } else {
      throw Exception('Failed to load usernames');
    }
  }

  /// Get user by username
  Future<User> getUserByUsername(String username) async {
    final response =
        await _client.get(Uri.parse('$baseUrl/api/users/usernames/$username'));

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else {
      throw Exception('Failed to load user');
    }
  }

  /// Get user role
  Future<Role> getUserRole(String userId) async {
    final response =
        await _client.get(Uri.parse('$baseUrl/api/users/$userId/role'));

    if (response.statusCode == 200) {
      return Role.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Role not found');
    } else {
      throw Exception('Failed to load role');
    }
  }

  /// Create user role
  Future<Role> createUserRole(String userId, Role role) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/api/users/$userId/role'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(role.toJson()),
    );

    if (response.statusCode == 200) {
      return Role.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else {
      throw Exception('Failed to create role');
    }
  }

  /// Edit user role
  Future<Role> editUserRole(String userId, Role role) async {
    final response = await _client.put(
      Uri.parse('$baseUrl/api/users/$userId/role'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(role.toJson()),
    );

    if (response.statusCode == 200) {
      return Role.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('User or role not found');
    } else {
      throw Exception('Failed to update role');
    }
  }
}
