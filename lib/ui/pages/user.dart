import 'package:auto_route/auto_route.dart';
import 'package:diplome_nick/data/model/flight.dart';
import 'package:diplome_nick/data/utils/app.dart';
import 'package:diplome_nick/data/utils/constants.dart';
import 'package:diplome_nick/data/utils/lists.dart';
import 'package:diplome_nick/data/utils/localization.dart';
import 'package:diplome_nick/data/utils/router.gr.dart';
import 'package:diplome_nick/data/utils/styles.dart';
import 'package:diplome_nick/main.dart';
import 'package:diplome_nick/ui/widgets/bottom_dialog.dart';
import 'package:diplome_nick/ui/widgets/button.dart';
import 'package:diplome_nick/ui/widgets/dropdown.dart';
import 'package:diplome_nick/ui/widgets/input.dart';
import 'package:diplome_nick/ui/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class HomeUserPage extends StatefulWidget {
  const HomeUserPage({Key? key}) : super(key: key);

  @override
  State<HomeUserPage> createState() => _HomeUserPageState();
}

class _HomeUserPageState extends State<HomeUserPage> {
  late ListItem _placeStart, _placeFinish;

  final _dateController = TextEditingController();

  Future<List<Flight>?>? requestFlight;

  @override
  void initState() {
    _placeStart = destinations.first;
    _placeFinish = destinations[1];
    appBloc.callStreams();
    super.initState();
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: FutureBuilder(
          future: firebaseBloc.userIsEnabled(firebaseBloc.fbAuth.currentUser!),
          builder: (context, AsyncSnapshot<bool?> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 16),
                          const Text(
                            App.appName,
                            style: TextStyle(
                              fontSize: 30,
                              color: appColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: (){
                                    context.router.push(const MyBookingsPageRoute());
                                  },
                                  child: Text(
                                    AppLocalizations.of(context, 'bookings'),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: appColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: () async{
                                    context.router.push(SettingsPageRoute(isFullPage: true));
                                  },
                                  icon: const Icon(
                                    Icons.settings,
                                    color: appColor,
                                    size: 32,
                                  )
                                ),
                                IconButton(
                                  onPressed: () async{
                                    await firebaseBloc.signOutUser();
                                    loadingFuture = Future.value(true);
                                    context.router.replaceAll([const LoginPageRoute()]);
                                  },
                                  icon: const Icon(
                                    Icons.logout,
                                    color: appColor,
                                    size: 32,
                                  )
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 32),
                      Text(
                        AppLocalizations.of(context, 'tickets_search'),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(
                          height: 72,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: DropdownPicker(
                                  title: '${AppLocalizations.of(context, 'departure')}:*',
                                  myValue: _placeStart.value,
                                  items: destinations,
                                  darkColor: const Color(0xFF242424),
                                  onChange: (newVal){
                                    final place = destinations.firstWhere((element) => element.value == newVal);
                                    if(place.value != _placeFinish.value){
                                      setState(() => _placeStart = place);
                                    }
                                  },
                                  onSubmit: null,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: DropdownPicker(
                                  title: '${AppLocalizations.of(context, 'arrival')}:*',
                                  myValue: _placeFinish.value,
                                  items: destinations,
                                  darkColor: const Color(0xFF242424),
                                  onChange: (newVal){
                                    final place = destinations.firstWhere((element) => element.value == newVal);
                                    if(place.value != _placeStart.value){
                                      setState(() => _placeFinish = place);
                                    }
                                  },
                                  onSubmit: null,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: InputField(
                                  hint: AppLocalizations.of(context, 'departure_date'),
                                  controller: _dateController,
                                  inputType: TextInputType.number,
                                  onTap: (){
                                    DatePicker.showDatePicker(
                                      context,
                                      locale: LocaleType.ru,
                                      minTime: DateTime(2023, 2, 1),
                                      onConfirm: (DateTime date){
                                        _dateController.text = DateFormat(dateFormat).format(date).toString();
                                      }
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      AppButton(
                        text: AppLocalizations.of(context, 'start'),
                        onPressed: () async{
                          if(_dateController.text.trim().isNotEmpty){
                            debugPrint("${_placeStart.title} - ${_placeFinish.title}");
                            requestFlight = appBloc.loadFlights(
                              _placeStart.title, _placeFinish.title,
                              DateFormat(dateFormat).parse(_dateController.text)
                            );
                            setState(() {});
                          }
                          else{
                            showInfoDialog(context, AppLocalizations.of(context, 'choose_date'));
                          }
                        }
                      ),
                      const SizedBox(height: 24),
                      FutureBuilder(
                        future: requestFlight,
                        builder: (context, AsyncSnapshot<List<Flight>?> snapshot){
                          if(snapshot.hasData){
                            if(snapshot.data!.isNotEmpty){
                              return Column(
                                children: [
                                  const SizedBox(height: 24),
                                  Text(
                                    AppLocalizations.of(context, 'flights'),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index){
                                      return FlightItem(
                                        flight: snapshot.data![index]
                                      );
                                    },
                                  ),
                                ],
                              );
                            }
                            return Column(
                              children: [
                                const SizedBox(height: 24),
                                Text(
                                  AppLocalizations.of(context, 'flights'),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24
                                  ),
                                ),
                                const SizedBox(height: 26),
                                Center(child: Text(AppLocalizations.of(context, 'empty_request')))
                              ],
                            );
                          }
                          return const SizedBox();
                        },
                      )
                    ],
                  ),
                );
              }
              else{
                return Center(
                  child: Text(
                    AppLocalizations.of(context, 'banned'),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }
            }
            return const LoadingView();
          }
        )
      ),
    );
  }
}