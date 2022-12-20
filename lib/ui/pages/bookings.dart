import 'package:diplome_nick/data/model/book.dart';
import 'package:diplome_nick/data/utils/localization.dart';
import 'package:diplome_nick/main.dart';
import 'package:diplome_nick/ui/widgets/loading.dart';
import 'package:flutter/material.dart';

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({Key? key}) : super(key: key);

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {

  @override
  void initState() {
    appBloc.callBookingsStreams();
    super.initState();
  }

  @override
  void dispose() {
    appBloc.callBookingsStreams();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16, right: 16, top: 16
          ),
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context, 'bookings'),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: StreamBuilder(
                  stream: appBloc.bookingsStream,
                  builder: (context, AsyncSnapshot<List<Booking>?> snapshot){
                    if(snapshot.hasData){
                      if(snapshot.data!.isNotEmpty){
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index){
                            return BookedItem(
                              booking: snapshot.data![index],
                            );
                          },
                        );
                      }
                      return Center(child: Text(AppLocalizations.of(context, 'empty_request')));
                    }
                    return const LoadingView();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
