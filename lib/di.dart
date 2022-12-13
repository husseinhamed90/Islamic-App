import 'package:get_it/get_it.dart';

import 'Logic/AppProvider.dart';

GetIt getIt = GetIt.instance;
void setup() {
  getIt.registerLazySingleton<AppProvider>(() => AppProvider());
}