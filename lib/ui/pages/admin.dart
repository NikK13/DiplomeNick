import 'package:auto_route/auto_route.dart';
import 'package:diplome_nick/data/utils/app.dart';
import 'package:diplome_nick/data/utils/constants.dart';
import 'package:diplome_nick/data/utils/extensions.dart';
import 'package:diplome_nick/data/utils/localization.dart';
import 'package:diplome_nick/data/utils/router.gr.dart';
import 'package:diplome_nick/data/utils/styles.dart';
import 'package:diplome_nick/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeAdminPage extends StatefulWidget {
  const HomeAdminPage({Key? key}) : super(key: key);

  @override
  State<HomeAdminPage> createState() => _HomeAdminPageState();
}

class _HomeAdminPageState extends State<HomeAdminPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  int _currentIndex = 0;

  @override
  void initState() {
    appBloc.callStreams();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: null,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            appBarTitle,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: appColor,
          actions: [
            IconButton(
              onPressed: () async{
                await firebaseBloc.signOutUser();
                loadingFuture = Future.value(true);
                context.router.replaceAll([const LoginPageRoute()]);
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              )
            )
          ],
          leading: IconButton(
            onPressed: () => _scaffoldKey.currentState!.openDrawer(),
            icon: const Icon(
              Icons.dehaze,
              color: Colors.white,
            )
          ),
        ),
        drawerEnableOpenDragGesture: false,
        drawer: SizedBox(
          width: 220,
          child: Drawer(
            backgroundColor: backgroundColor(context),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    color: appColor
                  ),
                  accountName: Text(
                    firebaseBloc.fbUser!.email!.contains(adminEmail) ?
                    "Administrator" : firebaseBloc.fbUser!.email!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  accountEmail: Text(
                    firebaseBloc.fbUser!.email!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.grey.shade700,
                    child: Icon(
                      Icons.person,
                      color: Colors.grey.shade800,
                      size: 38,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.airplane_ticket_outlined,
                    color: accent(context),
                  ),
                  title: Text(
                    AppLocalizations.of(context, 'tickets')
                  ),
                  onTap: () {
                    setState(() => _currentIndex = 0);
                    context.navigateTo(const TicketsFragmentRoute());
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.flight,
                    color: accent(context),
                  ),
                  title: Text(
                    AppLocalizations.of(context, 'flights')
                  ),
                  onTap: () {
                    setState(() => _currentIndex = 1);
                    context.navigateTo(const FlightsFragmentRoute());
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    CupertinoIcons.settings,
                    color: accent(context),
                  ),
                  title: Text(
                    AppLocalizations.of(context, 'settings')
                  ),
                  onTap: () {
                    setState(() => _currentIndex = 2);
                    context.navigateTo(SettingsFragmentRoute());
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: AutoTabsScaffold(
            routes: [
              const TicketsFragmentRoute(),
              const FlightsFragmentRoute(),
              SettingsFragmentRoute()
            ],
          ),
        )
      ),
    );
  }

  String get appBarTitle{
    switch(_currentIndex){
      case 0:
        return AppLocalizations.of(context, 'tickets');
      case 1:
        return AppLocalizations.of(context, 'flights');
      case 2:
        return AppLocalizations.of(context, 'settings');
      default:
        return App.appName;
    }
  }
}
