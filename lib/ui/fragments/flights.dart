import 'package:diplome_nick/data/model/flight.dart';
import 'package:diplome_nick/data/utils/extensions.dart';
import 'package:diplome_nick/data/utils/localization.dart';
import 'package:diplome_nick/data/utils/styles.dart';
import 'package:diplome_nick/main.dart';
import 'package:diplome_nick/ui/dialogs/new_flight_dialog.dart';
import 'package:diplome_nick/ui/widgets/bottom_dialog.dart';
import 'package:diplome_nick/ui/widgets/loading.dart';
import 'package:flutter/material.dart';

class FlightsFragment extends StatefulWidget {
  const FlightsFragment({Key? key}) : super(key: key);

  @override
  State<FlightsFragment> createState() => _FlightsFragmentState();
}

class _FlightsFragmentState extends State<FlightsFragment> {
  late Future<List<Flight>?> _flightsFuture;

  @override
  void initState() {
    _flightsFuture = appBloc.loadFlights();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: appColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        label: Text(
          AppLocalizations.of(context, 'add_flight'),
          style: const TextStyle(color: Colors.white),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
        onPressed: () async{
          showBottomSheetDialog(context, NewFlightDialog(
            updateList: () => setState(() {
              _flightsFuture = appBloc.loadFlights();
            }),
          ));
        },
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
        child: StreamBuilder(
          stream: appBloc.flightsStream,
          builder: (context, AsyncSnapshot<List<Flight>?> snapshot){
            if(snapshot.hasData){
              if(snapshot.data!.isNotEmpty){
                return ListView.builder(
                  shrinkWrap: true,
                  /*gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCountOnWidth(context),
                  ),*/
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index){
                    return FlightItem(
                      flight: snapshot.data![index]
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
