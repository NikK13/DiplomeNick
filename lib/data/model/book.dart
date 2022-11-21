import 'package:diplome_nick/data/utils/localization.dart';
import 'package:diplome_nick/main.dart';
import 'package:flutter/material.dart';

class Booking{
  String? key;
  String? flightKey;
  String? bookDate;

  Booking({this.key, this.flightKey, this.bookDate});

  factory Booking.fromJson(String key, Map<String, dynamic> json){
    return Booking(
      key: key,
      bookDate: json['book_date'],
      flightKey: json['flight_id']
    );
  }
}

class BookedItem extends StatelessWidget {
  final Booking? booking;

  const BookedItem({Key? key, this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{

      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(width: 1, color: Colors.grey)
        ),
        //width: 300,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${appBloc.flightByKey(booking!.flightKey!)!.titleStart!} - ${appBloc.flightByKey(booking!.flightKey!)!.titleEnd!}",
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "${AppLocalizations.of(context, 'departure')}: ",
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      appBloc.flightByKey(booking!.flightKey!)!.startDate!,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "${AppLocalizations.of(context, 'arrival')}: ",
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      appBloc.flightByKey(booking!.flightKey!)!.endDate!,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.center,
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
