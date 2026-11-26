import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'blocs/auth/auth_cubit.dart';
import 'blocs/cart/cart_bloc.dart';
import 'blocs/journal/journal_cubit.dart';
import 'blocs/settings/settings_cubit.dart';
import 'blocs/settings/settings_state.dart';
import 'data/local_storage_service.dart';
import 'screens/login_screen.dart';
import 'screens/root_screen.dart';
import 'services/location_service.dart';
import 'services/media_service.dart';
import 'theme.dart';

Future<void> main() async {
  // Load local settings before runApp to avoid a light-theme flash on launch.
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();

  final initialDarkMode = LocalStorageService.readDarkMode(preferences);
  final initialDisplayName = LocalStorageService.readDisplayName(preferences);
  final initialNotes = LocalStorageService.readNotes(preferences);

  final documents = await getApplicationDocumentsDirectory();

  runApp(
    FlipApp(
      mediaService: MediaService(Directory('${documents.path}/media')),
      locationService: LocationService(),
      initialSettings: SettingsState(
        isDarkMode: initialDarkMode,
        displayName: initialDisplayName,
        notes: initialNotes,
        avatarName: LocalStorageService.readAvatarName(preferences),
        deliveryPoint: LocalStorageService.readDeliveryPoint(preferences),
      ),
    ),
  );
}

class FlipApp extends StatelessWidget {
  final SettingsState initialSettings;

  final MediaService mediaService;
  final LocationService locationService;

  const FlipApp({
    super.key,
    required this.initialSettings,
    required this.mediaService,
    required this.locationService,
  });

  @override
  Widget build(BuildContext context) {
    // Провайдеры стоят над MaterialApp, поэтому видны на всех маршрутах.
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: mediaService),
        RepositoryProvider.value(value: locationService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthCubit()),
          BlocProvider(create: (_) => CartBloc()),
          BlocProvider(create: (_) => JournalCubit()),
          BlocProvider(create: (_) => SettingsCubit(initialSettings)),
        ],
        child: BlocSelector<SettingsCubit, SettingsState, bool>(
          selector: (state) => state.isDarkMode,
          builder: (context, isDarkMode) => MaterialApp(
            title: 'Flip',
            debugShowCheckedModeBanner: false,
            theme: buildFlipTheme(Brightness.light),
            darkTheme: buildFlipTheme(Brightness.dark),
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: LoginScreen(catalogBuilder: (_) => const RootScreen()),
          ),
        ),
      ),
    );
  }
}
