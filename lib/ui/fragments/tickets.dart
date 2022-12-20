import 'package:diplome_nick/data/model/ticket.dart';
import 'package:diplome_nick/data/utils/lists.dart';
import 'package:diplome_nick/data/utils/localization.dart';
import 'package:diplome_nick/main.dart';
import 'package:diplome_nick/ui/widgets/dropdown.dart';
import 'package:diplome_nick/ui/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class TicketsFragment extends StatefulWidget {
  const TicketsFragment({Key? key}) : super(key: key);

  @override
  State<TicketsFragment> createState() => _TicketsFragmentState();
}

class _TicketsFragmentState extends State<TicketsFragment> {
  late ListItem _placeStart, _placeFinish;

  late List<ListItem> _allDestinations;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _allDestinations = [...destinations];
      _allDestinations.insert(0, ListItem(AppLocalizations.of(context, 'all'), ""));
      _placeStart = _allDestinations[0];
      _placeFinish = _allDestinations[0];
      appBloc.filterTicketsStart = _placeStart.value;
      appBloc.filterTicketsEnd = _placeFinish.value;
      appBloc.callTicketsStream(appBloc.filterTicketsStart, appBloc.filterTicketsEnd);
    });
    super.initState();
  }

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
                                  appBloc.filterTicketsStart = _placeStart.value;
                                  appBloc.callTicketsStream(appBloc.filterTicketsStart, appBloc.filterTicketsEnd);
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
                                  appBloc.filterTicketsEnd = _placeFinish.value;
                                  appBloc.callTicketsStream(appBloc.filterTicketsStart, appBloc.filterTicketsEnd);
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
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index){
                          return TicketItem(ticket: snapshot.data![index]);
                        },
                      ),
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
                              appBloc.filterTicketsStart = _placeStart.value;
                              appBloc.callTicketsStream(appBloc.filterTicketsStart, appBloc.filterTicketsEnd);
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
                              appBloc.filterTicketsEnd = _placeFinish.value;
                              appBloc.callTicketsStream(appBloc.filterTicketsStart, appBloc.filterTicketsEnd);
                            },
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
