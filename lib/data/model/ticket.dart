import 'package:diplome_nick/data/utils/extensions.dart';
import 'package:diplome_nick/data/utils/styles.dart';
import 'package:diplome_nick/main.dart';
import 'package:flutter/material.dart';

class Ticket{
  String? key;
  String? flightKey;
  int? ticketsCount;

  Ticket({this.key, this.flightKey, this.ticketsCount});

  factory Ticket.fromJson(String key, Map<String, dynamic> json){
    return Ticket(
      key: key,
      flightKey: json['flight_id'],
      ticketsCount: json['tickets_count']
    );
  }
}

class TicketItem extends StatelessWidget {
  final Ticket? ticket;

  const TicketItem({Key? key, this.ticket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const Icon(
            Icons.airplane_ticket_outlined,
            color: appColor,
            size: 16,
          ),
          const SizedBox(height: 4),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                "${appBloc.flightByKey(ticket!.key!)!.titleStart!} - ${appBloc.flightByKey(ticket!.key!)!.titleEnd!}",
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
            flex: 3,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ticket!.ticketsCount!.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "tickets left",
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            ),
          ),
        ],
      ),
    );
  }
}