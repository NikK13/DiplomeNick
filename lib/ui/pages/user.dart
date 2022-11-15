import 'package:auto_route/auto_route.dart';
import 'package:diplome_nick/data/model/flight.dart';
import 'package:diplome_nick/data/utils/extensions.dart';
import 'package:diplome_nick/data/utils/localization.dart';
import 'package:diplome_nick/data/utils/router.gr.dart';
import 'package:diplome_nick/data/utils/styles.dart';
import 'package:diplome_nick/main.dart';
import 'package:diplome_nick/ui/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeUserPage extends StatefulWidget {
  const HomeUserPage({Key? key}) : super(key: key);

  @override
  State<HomeUserPage> createState() => _HomeUserPageState();
}

class _HomeUserPageState extends State<HomeUserPage> {
  @override
  void initState() {
    appBloc.callStreams();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context, 'flights'),
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
              size: 26,
            )
          ),
        ],
        leading: IconButton(
          onPressed: (){
            context.router.push(SettingsPageRoute(isFullPage: true));
          },
          icon: const Icon(
            CupertinoIcons.settings,
            color: Colors.white,
          )
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: StreamBuilder(
          stream: appBloc.flightsStream,
          builder: (context, AsyncSnapshot<List<Flight>?> snapshot){
            if(snapshot.hasData){
              if(snapshot.data!.isNotEmpty){
                return GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCountOnWidth(context),
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index){
                    return FlightItem(flight: snapshot.data![index]);
                  },
                );
              }
              return const Center(child: Text("EMPTY LIST"));
            }
            return const LoadingView();
          },
        ),
      ),
    );
  }
}