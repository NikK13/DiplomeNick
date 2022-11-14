import 'package:diplome_nick/data/utils/app.dart';
import 'package:diplome_nick/data/utils/guards.dart';
import 'package:diplome_nick/data/utils/localization.dart';
import 'package:diplome_nick/data/utils/router.gr.dart';
import 'package:diplome_nick/data/utils/styles.dart';
import 'package:diplome_nick/ui/bloc/app_bloc.dart';
import 'package:diplome_nick/ui/bloc/fb_bloc.dart';
import 'package:diplome_nick/ui/provider/prefsprovider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

late AppBloc appBloc;
late FirebaseBloc firebaseBloc;
late PreferenceProvider prefsProvider;

final GlobalKey<NavigatorState> globalKey = GlobalKey<NavigatorState>();

Future loadingFuture = Future.delayed(const Duration(milliseconds: 1500));

bool isToRedirectHome = true;
bool isAsAdministrator = false;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      databaseURL: "https://diplome-nick-2023-default-rtdb.firebaseio.com",
      apiKey: "AIzaSyBAWAvMS-ElIX4tLOF6I3Hj5Neu4ZOwj-k",
      appId: "1:102761724817:web:d3cacd59d9d3e9be68f830",
      messagingSenderId: "102761724817",
      projectId: "diplome-nick-2023"
    )
  );
  await AppLocalizations.loadLanguages();
  firebaseBloc = FirebaseBloc();
  appBloc = AppBloc();
  if(kIsWeb) setPathUrlStrategy();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PreferenceProvider()),
      ],
      child: Application(),
    ),
  );
}

class Application extends StatelessWidget {
  final _appRouter = AppRouter(
    checkIfUserLoggedIn: CheckIfUserLoggedIn()
  );

  Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferenceProvider>(
      builder: (ctx, provider, child) {
        prefsProvider = provider;
        return provider.locale != null ? MaterialApp.router(
          key: globalKey,
          title: App.appName,
          debugShowCheckedModeBanner: false,
          showPerformanceOverlay: false,
          locale: provider.preferences.locale,
          localizationsDelegates: App.delegates,
          supportedLocales: App.supportedLocales,
          themeMode: getThemeMode(provider.currentTheme ?? "light"),
          theme: themeLight,
          darkTheme: themeDark,
          routerDelegate: _appRouter.delegate(),
          routeInformationParser: _appRouter.defaultRouteParser(),
          routeInformationProvider: _appRouter.routeInfoProvider(),
        ) : const SizedBox();
      },
    );
  }
}

