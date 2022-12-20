import 'package:diplome_nick/data/model/flight.dart';
import 'package:diplome_nick/data/utils/lists.dart';
import 'package:diplome_nick/data/utils/localization.dart';
import 'package:diplome_nick/data/utils/styles.dart';
import 'package:diplome_nick/main.dart';
import 'package:diplome_nick/ui/dialogs/new_flight_dialog.dart';
import 'package:diplome_nick/ui/widgets/bottom_dialog.dart';
import 'package:diplome_nick/ui/widgets/dropdown.dart';
import 'package:diplome_nick/ui/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class FlightsFragment extends StatefulWidget {
  const FlightsFragment({Key? key}) : super(key: key);

  @override
  State<FlightsFragment> createState() => _FlightsFragmentState();
}

class _FlightsFragmentState extends State<FlightsFragment> {
  late ListItem _placeStart, _placeFinish;

  late List<ListItem> _allDestinations;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _allDestinations = [...destinations];
      _allDestinations.insert(0, ListItem(AppLocalizations.of(context, 'all'), ""));
      _placeStart = _allDestinations[0];
      _placeFinish = _allDestinations[0];
      appBloc.filterFlightsStart = _placeStart.value;
      appBloc.filterFlightsEnd = _placeFinish.value;
      appBloc.callFlightsStream(appBloc.filterFlightsStart , appBloc.filterFlightsEnd);
    });
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
          showBottomSheetDialog(context, const NewFlightDialog());
        },
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
        child: StreamBuilder(
          stream: appBloc.flightsStream,
          builder: (context, AsyncSnapshot<List<Flight>?> snapshot){
            if(snapshot.hasData){
              if(snapshot.data!.isNotEmpty){
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: DropdownPicker(
                                borderRadius: 16,
                                title: '${AppLocalizations.of(context, 'departure')}:*',
                                myValue: _placeStart.value,
                                items: _allDestinations,
                                darkColor: const Color(0xFF242424),
                                onChange: (newVal){
                                  final place = _allDestinations.firstWhere((element) => element.value == newVal);
                                  setState(() => _placeStart = place);
                                  appBloc.filterFlightsStart = _placeStart.value;
                                  appBloc.callFlightsStream(appBloc.filterFlightsStart, appBloc.filterFlightsEnd);                                },
                                onSubmit: null,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: DropdownPicker(
                                borderRadius: 16,
                                title: '${AppLocalizations.of(context, 'arrival')}:*',
                                myValue: _placeFinish.value,
                                items: _allDestinations,
                                darkColor: const Color(0xFF242424),
                                onChange: (newVal){
                                  final place = _allDestinations.firstWhere((element) => element.value == newVal);
                                  setState(() => _placeFinish = place);
                                  appBloc.filterFlightsEnd = _placeFinish.value;
                                  appBloc.callFlightsStream(appBloc.filterFlightsStart, appBloc.filterFlightsEnd);
                                },
                                onSubmit: null,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index){
                          return FlightItem(
                            flight: snapshot.data![index]
                          );
                        },
                      )
                    ],
                  ),
                );
              }
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownPicker(
                            borderRadius: 16,
                            title: '${AppLocalizations.of(context, 'departure')}:*',
                            myValue: _placeStart.value,
                            items: _allDestinations,
                            darkColor: const Color(0xFF242424),
                            onChange: (newVal){
                              final place = _allDestinations.firstWhere((element) => element.value == newVal);
                              setState(() => _placeStart = place);
                              appBloc.filterFlightsStart = _placeStart.value;
                              appBloc.callFlightsStream(appBloc.filterFlightsStart, appBloc.filterFlightsEnd);
                            },
                            onSubmit: null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropdownPicker(
                            borderRadius: 16,
                            title: '${AppLocalizations.of(context, 'arrival')}:*',
                            myValue: _placeFinish.value,
                            items: _allDestinations,
                            darkColor: const Color(0xFF242424),
                            onChange: (newVal){
                              final place = _allDestinations.firstWhere((element) => element.value == newVal);
                              setState(() => _placeFinish = place);
                              appBloc.filterFlightsEnd = _placeFinish.value;
                              appBloc.callFlightsStream(appBloc.filterFlightsStart, appBloc.filterFlightsEnd);                            },
                            onSubmit: null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Center(child: Text(AppLocalizations.of(context, 'empty_request')))
                  ),
                ],
              );
            }
            return const LoadingView();
          },
        ),
      ),
    );
  }
}
