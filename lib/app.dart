import 'package:flutter/material.dart';
import 'package:go_here/data/model/place.dart';
import 'package:go_here/data/repository/place_repository.dart';
import 'package:go_here/domain/place_bloc.dart';
import 'package:go_here/service/api_service.dart';
import 'package:go_here/service/aviasales_service.dart';
import 'package:go_here/service/preferences_service.dart';
import 'package:go_here/ui/colors.dart';
import 'package:go_here/ui/page/main_page.dart';
import 'package:go_here/ui/page/place_page.dart';
import 'package:go_here/ui/strings.dart';
import 'package:go_here/utils/log.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

const _tag = "app";

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();
    final placeRepository = PlaceRepository(apiService);
    final placeBloc = PlaceBloc(placeRepository);
    final aviasalesService = AviasalesService();
    final preferencesService = PreferencesService();

    return StreamBuilder<bool>(
        initialData: preferencesService.currentDartMode(),
        stream: preferencesService.darkModeSubject,
        builder: (context, snapshot) {
          Log.d(_tag, "darkMode = ${snapshot.data}");
          final goColors = GoColors(snapshot.data);

          return MultiProvider(
            providers: [
              Provider.value(value: placeBloc),
              Provider.value(value: aviasalesService),
              Provider.value(value: preferencesService),
              Provider.value(value: goColors),
            ],
            child: MaterialApp(
              title: Strings.appName,
              theme: ThemeData(
                scaffoldBackgroundColor: goColors.backgroundColor,
              ),
              routes: {
                MainPage.routeName: (context) => MainPage(),
              },
              onGenerateRoute: (settings) {
                switch (settings.name) {
                  case PlacePage.routeName:
                    final String categoryName = (settings.arguments as List)[0];
                    final Place place = (settings.arguments as List)[1];
                    final VideoPlayerController videoController =
                        (settings.arguments as List)[2];
                    final Future<void> videoControllerInitializeCallback =
                        (settings.arguments as List)[3];
                    return MaterialPageRoute(
                        builder: (context) => PlacePage(
                            categoryName,
                            place,
                            videoController,
                            videoControllerInitializeCallback));
                }
                return null;
              },
              home: MainPage(),
            ),
          );
        });
  }
}
