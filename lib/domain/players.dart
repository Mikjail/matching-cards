class PlayerCard {
  final int id;
  final String team;
  final String player;
  final String imgPlayer;
  final String imgTeam;

  PlayerCard({
    required this.id,
    required this.team,
    required this.player,
    required this.imgPlayer,
    required this.imgTeam,
  });

  factory PlayerCard.fromJson(Map<String, dynamic> json) {
    return PlayerCard(
      id: json['id'],
      team: json['nationalTeam']['name'],
      player: json['name'],
      imgPlayer: json['imageSrc'],
      imgTeam: json['nationalTeam']['logoUrls'][0]['url'],
    );
  }
}
