import 'package:get_it/get_it.dart';
import 'package:whatsapp_clone/services/api_client.dart';
import 'package:whatsapp_clone/services/audio_player_service.dart';
import 'package:whatsapp_clone/services/hive.dart';
import 'package:whatsapp_clone/services/local_database.dart';

final getIt = GetIt.instance;

void setUpLocator() async {
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());
  getIt.registerLazySingleton<LocalDatabase>(() => HiveService());
}
