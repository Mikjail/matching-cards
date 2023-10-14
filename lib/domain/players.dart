class Player {
  final int id;
  final String team;
  final String player;
  final String imgPlayer;
  final String imgTeam;

  Player({
    required this.id,
    required this.team,
    required this.player,
    required this.imgPlayer,
    required this.imgTeam,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      team: json['nationalTeam']['name'],
      player: json['name'],
      imgPlayer: json['imageSrc'],
      imgTeam: json['nationalTeam']['logoUrls'][0]['url'],
    );
  }
}
