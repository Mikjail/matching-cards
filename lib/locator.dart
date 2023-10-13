import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:of_card_match/domain/players_repository.dart';

final locator = GetIt.instance;

void setUpLocator() {
  if (!locator.isRegistered<PlayersRepository>()) {
    locator.registerLazySingleton<PlayersRepository>(
        () => PlayersRepository(Client()));
  }
}
