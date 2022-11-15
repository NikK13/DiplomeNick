import 'package:diplome_nick/data/model/flight.dart';
import 'package:diplome_nick/data/utils/localization.dart';
import 'package:diplome_nick/data/utils/styles.dart';
import 'package:diplome_nick/main.dart';
import 'package:diplome_nick/ui/widgets/button.dart';
import 'package:diplome_nick/ui/widgets/dialog.dart';
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

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: "Details",
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const Icon(
              Icons.flight,
              color: appColor,
              size: 24,
            ),
            const SizedBox(height: 24),
            Text(
              "${flight.titleStart!}\n-\n${flight.titleEnd!}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${AppLocalizations.of(context, 'departure')}: ",
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Flexible(
                      child: Text(
                        flight.startDate!,
                        style: const TextStyle(
                          fontSize: 10,
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
                        fontSize: 10,
                        fontWeight: FontWeight.w700
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Flexible(
                      child: Text(
                        flight.endDate!,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                FutureBuilder(
                  future: appBloc.alreadyBooked(flight.key!),
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      if(snapshot.data!){
                        return const Text("ALREADY BOOKED");
                      }
                      return AppButton(
                        text: "Book ticket",
                        onPressed: () async{
                          Navigator.pop(context);
                          await appBloc.bookTicket(flight.key!, flight.ticketsKey!);
                        }
                      );
                    }
                    return const LoadingView();
                  }
                ),
                const SizedBox(height: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
