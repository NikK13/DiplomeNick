import 'package:diplome_nick/data/utils/extensions.dart';
import 'package:diplome_nick/data/utils/localization.dart';
import 'package:diplome_nick/data/utils/styles.dart';
import 'package:diplome_nick/main.dart';
import 'package:diplome_nick/ui/dialogs/flight_details_dialog.dart';
import 'package:diplome_nick/ui/widgets/bottom_dialog.dart';
import 'package:flutter/material.dart';

class Flight{
  String? key;
  String? ticketsKey;
  String? titleStart;
  String? titleEnd;
  String? startDate;
  String? endDate;

  Flight({
    this.key,
    this.startDate,
    this.ticketsKey,
    this.endDate,
    this.titleEnd,
    this.titleStart
  });

  factory Flight.fromJson(String key, Map<String, dynamic> json){
    return Flight(
      key: key,
      startDate: json['start_date'],
      endDate: json['end_date'],
      titleStart: json['start_title'],
      titleEnd: json['end_title'],
      ticketsKey: json['tickets_id']
    );
  }
}

class FlightItem extends StatelessWidget {
  final Flight? flight;

  const FlightItem({Key? key, this.flight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        if(!isAsAdministrator){
          showBottomSheetDialog(context, FlightDetailsDialog(
            flight: flight,
          ));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(width: 1, color: Colors.grey)
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isAsAdministrator ?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.flight,
                  color: appColor,
                  size: 24,
                ),
                getIconButton(child: const Icon(
                  Icons.clear,
                  size: 12,
                  color: Colors.white,
                ), color: appColor,
                onTap: () async{
                  await appBloc.deleteFlight(flight!.key!, flight!.ticketsKey!);
                },
                context: context)
              ],
            ) : const Icon(
              Icons.flight,
              color: appColor,
              size: 18,
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Center(
                child: Text(
                  "${flight!.titleStart!} - ${flight!.titleEnd!}",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Row(
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
                            flight!.startDate!,
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
                  ),
                  const SizedBox(height: 4),
                  Flexible(
                    child: Row(
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
                            flight!.endDate!,
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
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
