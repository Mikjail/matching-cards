import 'package:of_card_match/ui/matching_cards/matching_cards.dart';

class MatchingCard {
  int id;
  String name;
  MatchStatus status;
  bool selected;
  String imageUrl;
  bool isPlayer;

  MatchingCard(
      {required this.id,
      required this.name,
      required this.imageUrl,
      required this.status,
      required this.selected,
      this.isPlayer = true});
}
