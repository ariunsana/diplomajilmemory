import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/player.dart';
import '../models/game.dart';

class ApiService {
  final String baseUrl = 'http://127.0.0.1:8000/api'; // Use your Django server URL

  Future<List<Player>> getPlayers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/players/'),
        headers: {'Accept': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        if (data.isEmpty) {
          print('No players found in the database');
          return [];
        }
        return data.map((json) => Player.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        print('Players endpoint not found');
        return [];
      } else {
        print('Failed to load players: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching players: $e');
      return [];
    }
  }

  Future<List<Game>> getGames() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/games/'));
      
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((json) => Game.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load games');
      }
    } catch (e) {
      print('Error fetching games: $e');
      return [];
    }
  }

  Future<void> createGame(int playerId, int score, {
    required String gameType,
    String? gameName,
  }) async {
    try {
      final Map<String, dynamic> body = {
        'player': playerId,
        'score': score,
        'game_type': gameType,
        'game_name': gameName ?? 'Memory Match',
      };

      final response = await http.post(
        Uri.parse('$baseUrl/games/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(body),
      );
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode != 201) {
        throw Exception('Failed to save game score: ${response.body}');
      }
    } catch (e) {
      print('Error saving game: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<bool> checkNameExists(String name) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/players/check-name/$name/'),
        headers: {'Accept': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body)['exists'];
      }
      return false;
    } catch (e) {
      print('Error checking name: $e');
      return false;
    }
  }

  Future<Player> createPlayer(String name) async {
    // First check if name exists
    final nameExists = await checkNameExists(name);
    if (nameExists) {
      throw Exception('Энэ нэр аль хэдийн бүртгэгдсэн байна');
    }

    // If name doesn't exist, create new player
    try {
      final Map<String, dynamic> body = {
        'name': name,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/players/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(body),
      );
      
      if (response.statusCode == 201) {
        return Player.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create player');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<void> updatePlayerLevel(int playerId, int level, int score) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/players/$playerId/update_level/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'level': level,
          'score': score,
        }),
      );
      
      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 404) {
        throw Exception('Тоглогч олдсонгүй');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? 'Түвшин шинэчлэхэд алдаа гарлаа');
      }
    } catch (e) {
      print('Error updating player level: $e');
      throw Exception('Сүлжээний алдаа: $e');
    }
  }
} 