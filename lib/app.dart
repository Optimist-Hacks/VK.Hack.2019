import 'package:flutter/material.dart';
import 'package:go_here/data/repository/place_repository.dart';
import 'package:go_here/domain/place_bloc.dart';
import 'package:go_here/service/api_service.dart';
import 'package:go_here/service/aviasales_service.dart';
import 'package:go_here/ui/colors.dart';
import 'package:go_here/ui/page/main_page.dart';
import 'package:go_here/ui/strings.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();
    final placeRepository = PlaceRepository(apiService);
    final placeBloc = PlaceBloc(placeRepository);
    final aviasalesService = AviasalesService();
    return MultiProvider(
      providers: [
        Provider.value(value: placeBloc),
        Provider.value(value: aviasalesService),
      ],
      child: Builder(
        builder: (context) => MaterialApp(
          title: Strings.appName,
          theme: ThemeData(
            canvasColor: Colors.transparent,
            accentColor: GoColors.accent,
          ),
          routes: {
            MainPage.routeName: (context) => MainPage(),
          },
          home: MainPage(),
        ),
      ),
    );
  }
}
