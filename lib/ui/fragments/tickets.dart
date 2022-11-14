import 'package:diplome_nick/data/model/ticket.dart';
import 'package:diplome_nick/data/utils/extensions.dart';
import 'package:diplome_nick/data/utils/styles.dart';
import 'package:diplome_nick/main.dart';
import 'package:diplome_nick/ui/widgets/loading.dart';
import 'package:flutter/material.dart';

class TicketsFragment extends StatefulWidget {
  const TicketsFragment({Key? key}) : super(key: key);

  @override
  State<TicketsFragment> createState() => _TicketsFragmentState();
}

class _TicketsFragmentState extends State<TicketsFragment> {
  late Future<List<Ticket>?> _ticketsFuture;

  @override
  void initState() {
    _ticketsFuture = appBloc.loadTickets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: appColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60)
        ),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: (){

        },
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
                    childAspectRatio: 1.35
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
