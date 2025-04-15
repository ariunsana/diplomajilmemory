class Player {
  final int id;
  final String name;
  final int level;
  final int score;
  final DateTime createdAt;

  Player({
    required this.id,
    required this.name,
    required this.level,
    required this.score,
    required this.createdAt,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      level: json['level'] ?? 1,  // Default to level 1 if not provided
      score: json['score'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
} 