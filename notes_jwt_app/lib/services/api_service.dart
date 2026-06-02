import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://gavin-semiagricultural-linda.ngrok-free.dev/api';

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    print('LOGIN STATUS : ${response.statusCode}');
    print('LOGIN BODY   : ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token'];
    }

    return null;
  }

  Future<List<dynamic>> getNotes(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/notes'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Gagal mengambil notes');
  }

  Future<void> createNote({
    required String token,
    required String title,
    required String content,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/notes'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'title': title,
        'content': content,
      }),
    );

    if (response.statusCode != 201 &&
        response.statusCode != 200) {
      throw Exception('Gagal menambah note');
    }
  }

  Future<void> updateNote({
    required String token,
    required int id,
    required String title,
    required String content,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/notes/$id'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'title': title,
        'content': content,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal update note');
    }
  }

  Future<void> deleteNote({
    required String token,
    required int id,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/notes/$id'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal hapus note');
    }
  }

  Future<String?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      final data = jsonDecode(response.body);

      return data['token'];
    }

    return null;
  }
}