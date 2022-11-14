import 'package:diplome_nick/data/utils/extensions.dart';
import 'package:diplome_nick/data/utils/localization.dart';
import 'package:diplome_nick/data/utils/styles.dart';
import 'package:flutter/material.dart';

class Flight{
  int? id;
  String? titleStart;
  String? titleEnd;
  String? startDate;
  String? endDate;

  Flight({
    this.id,
    this.startDate,
    this.endDate,
    this.titleEnd,
    this.titleStart
  });

  factory Flight.fromJson(Map<String, dynamic> json){
    return Flight(
      id: json['id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      titleStart: json['start_title'],
      titleEnd: json['end_title'],
    );
  }
}

class FlightItem extends StatelessWidget {
  final Flight? flight;

  const FlightItem({Key? key, this.flight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 1, color: Colors.grey)
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.flight,
                  color: appColor,
                  size: 24,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "${flight!.titleStart!} - ${flight!.titleEnd!}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                getIconButton(child: const Icon(
                  Icons.clear,
                  size: 14,
                  color: Colors.white,
                ), color: appColor,
                context: context)
              ],
            ),
            const SizedBox(height: 4),
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      "${AppLocalizations.of(context, 'departure')}: ",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Flexible(
                      child: Text(
                        flight!.startDate!,
                        style: const TextStyle(
                          fontSize: 12,
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
                  children: [
                    Text(
                      "${AppLocalizations.of(context, 'arrival')}: ",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Flexible(
                      child: Text(
                        flight!.endDate!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 4),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
