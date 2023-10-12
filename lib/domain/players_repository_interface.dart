import 'package:of_card_match/domain/players.dart';

abstract class IPlayersRepository {
  Future<List<Player>> getTopPlayersFromCompetition(String competitionId);
}
