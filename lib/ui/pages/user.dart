import 'package:auto_route/auto_route.dart';
import 'package:diplome_nick/data/model/ticket.dart';
import 'package:diplome_nick/data/utils/extensions.dart';
import 'package:diplome_nick/data/utils/localization.dart';
import 'package:diplome_nick/data/utils/router.gr.dart';
import 'package:diplome_nick/data/utils/styles.dart';
import 'package:diplome_nick/main.dart';
import 'package:diplome_nick/ui/widgets/loading.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeUserPage extends StatefulWidget {
  const HomeUserPage({Key? key}) : super(key: key);

  @override
  State<HomeUserPage> createState() => _HomeUserPageState();
}

class _HomeUserPageState extends State<HomeUserPage> {
  late Future<List<Ticket>?> _ticketsFuture;

  @override
  void initState() {
    _ticketsFuture = _loadTickets();
    super.initState();
  }

  Future<List<Ticket>?> _loadTickets() async{
    final query = await FirebaseDatabase.instance.ref("tickets").once();
    if(query.snapshot.exists){
      final List<Ticket> tickets = [];
      final data = query.snapshot.children;
      for(var item in data){
        final ticket = Ticket.fromJson(item.value as Map<String, dynamic>);
        tickets.add(ticket);
      }
      return tickets;
    }
    else{
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context, 'tickets'),
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
        child: FutureBuilder(
          future: _ticketsFuture,
          builder: (context, AsyncSnapshot<List<Ticket>?> snapshot){
            if(snapshot.hasData){
              if(snapshot.data!.isNotEmpty){
                return GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCountOnWidth(context),
                    childAspectRatio: 1
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index){
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(width: 1, color: Colors.grey)
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      padding: const EdgeInsets.all(15),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              snapshot.data![index].title!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              snapshot.data![index].date!,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400
                              ),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    );
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