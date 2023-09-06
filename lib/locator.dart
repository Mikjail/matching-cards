import 'package:get_it/get_it.dart';
import 'package:of_card_match/services/matching_card_service.dart';

final locator = GetIt.instance;

void setUpLocator() {
  if (!locator.isRegistered<MatchingCardService>()) {
    locator.registerLazySingleton<MatchingCardService>(
        () => MatchingCardService());
  }
}
