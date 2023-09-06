class CardMatch {
  final String team;
  final String player;

  CardMatch({required this.team, required this.player});

  factory CardMatch.fromJson(team, player) {
    return CardMatch(
      team: team as String,
      player: player as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      team: player,
    };
  }
}
