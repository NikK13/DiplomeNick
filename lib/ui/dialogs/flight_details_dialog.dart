import 'package:diplome_nick/data/model/flight.dart';
import 'package:diplome_nick/data/model/ticket.dart';
import 'package:diplome_nick/data/utils/constants.dart';
import 'package:diplome_nick/data/utils/extensions.dart';
import 'package:diplome_nick/data/utils/localization.dart';
import 'package:diplome_nick/data/utils/styles.dart';
import 'package:diplome_nick/main.dart';
import 'package:diplome_nick/ui/widgets/bottom_dialog.dart';
import 'package:diplome_nick/ui/widgets/button.dart';
import 'package:diplome_nick/ui/widgets/loading.dart';
import 'package:flutter/material.dart';

class FlightDetailsDialog extends StatefulWidget {
  final Flight? flight;

  const FlightDetailsDialog({Key? key, this.flight}) : super(key: key);

  @override
  State<FlightDetailsDialog> createState() => _FlightDetailsDialogState();
}

class _FlightDetailsDialogState extends State<FlightDetailsDialog> {
  Flight get flight => widget.flight!;

  Ticket get ticket => appBloc.currentTickets.firstWhere((element) => element.key == flight.ticketsKey);

  int? selectedRadio;

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width > 600 ? 600 :
      MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.flight,
                    color: appColor,
                    size: 24,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${flight.titleStart!} - ${flight.titleEnd!}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${AppLocalizations.of(context, 'departure')}: ",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Flexible(
                        child: Text(
                          flight.startDate!,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700
                          ),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${AppLocalizations.of(context, 'arrival')}: ",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Flexible(
                        child: Text(
                          flight.endDate!,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700
                          ),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Table(
              border: TableBorder.all(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).brightness == Brightness.light ?
                Colors.grey.shade800 : Colors.white,
                width: 1.5
              ),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(3),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: [
                    tableCell("", isTitle: true),
                    tableCell(AppLocalizations.of(context, 'economic_class'), isTitle: true),
                    tableCell(AppLocalizations.of(context, 'business_class'), isTitle: true),
                  ]
                ),
                TableRow(
                  children: [
                    tableCell(AppLocalizations.of(context, 'price'), isTitle: true),
                    tableCell("${ticket.economicTicketsPrice!} $currency"),
                    tableCell("${ticket.businessTicketsPrice!} $currency"),
                  ]
                ),
                TableRow(
                  children: [
                    tableCell(AppLocalizations.of(context, 'tickets_left').capitalize(), isTitle: true),
                    tableCell("${ticket.economicTicketsCount!}"),
                    tableCell(ticket.businessTicketsCount!.toString()),
                  ]
                )
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                RadioListTile(
                  value: 1,
                  title: Text(AppLocalizations.of(context, 'economic_class')),
                  groupValue: selectedRadio,
                  activeColor: appColor,
                  onChanged: (val) {
                    setSelectedRadio(val!);
                  },
                ),
                const SizedBox(height: 6),
                RadioListTile(
                  value: 2,
                  title: Text(AppLocalizations.of(context, 'business_class')),
                  groupValue: selectedRadio,
                  activeColor: appColor,
                  onChanged: (val) {
                    setSelectedRadio(val!);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          FutureBuilder(
            future: appBloc.alreadyBooked(flight.key!),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                if(snapshot.data!){
                  return Text(
                    AppLocalizations.of(context, 'booked_already'),
                    style: TextStyle(
                      color: Colors.greenAccent.shade700,
                      fontWeight: FontWeight.w700,
                      fontSize: 18
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: !_isLoading ? AppButton(
                    text: AppLocalizations.of(context, 'book'),
                    onPressed: () async{
                      if(selectedRadio != null){
                        setState(() => _isLoading = true);
                        bool isBusiness = selectedRadio == 2;
                        if(isBusiness){
                          if(ticket.businessTicketsCount! > 0){
                            await appBloc.bookTicket(
                              flight.key!,
                              flight.ticketsKey!,
                              true
                            );
                          }
                          else{
                            showInfoDialog(context, AppLocalizations.of(context, 'tickets_out'));
                          }
                        }
                        else{
                          if(ticket.economicTicketsCount! > 0){
                            await appBloc.bookTicket(
                              flight.key!,
                              flight.ticketsKey!,
                              false
                            );
                          }
                          else{
                            showInfoDialog(context, AppLocalizations.of(context, 'tickets_out'));
                          }
                        }
                        await appBloc.callTicketsStream();
                        setState(() => _isLoading = false);
                      }
                    }
                  ) : const LoadingView(),
                );
              }
              return const LoadingView();
            }
          ),
          const SizedBox(height: 14),
          TextButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context, 'close'),
              style: const TextStyle(
                color: appColor,
              ),
            )
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
