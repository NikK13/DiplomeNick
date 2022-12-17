import 'package:diplome_nick/data/model/ticket.dart';
import 'package:diplome_nick/data/utils/localization.dart';
import 'package:diplome_nick/main.dart';
import 'package:diplome_nick/ui/widgets/loading.dart';
import 'package:flutter/material.dart';

class TicketsFragment extends StatefulWidget {
  const TicketsFragment({Key? key}) : super(key: key);

  @override
  State<TicketsFragment> createState() => _TicketsFragmentState();
}

class _TicketsFragmentState extends State<TicketsFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: StreamBuilder(
          stream: appBloc.ticketsStream,
          builder: (context, AsyncSnapshot<List<Ticket>?> snapshot){
            if(snapshot.hasData){
              if(snapshot.data!.isNotEmpty){
                return ListView.builder(
                  shrinkWrap: true,
                  /*gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCountOnWidth(context),
                  ),*/
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index){
                    return TicketItem(ticket: snapshot.data![index]);
                  },
                );
              }
              return Center(child: Text(AppLocalizations.of(context, 'empty_request')));
            }
            return const LoadingView();
          },
        ),
      ),
    );
  }
}
