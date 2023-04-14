import 'package:get_it/get_it.dart';
import 'package:whatsapp_clone/services/api_client.dart';
import 'package:whatsapp_clone/services/audio_player_service.dart';

final getIt = GetIt.instance;

void setUpLocator() {
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());
}
