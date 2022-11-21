import 'package:diplome_nick/data/utils/constants.dart';
import 'package:diplome_nick/data/utils/localization.dart';
import 'package:diplome_nick/data/utils/styles.dart';
import 'package:diplome_nick/main.dart';
import 'package:flutter/material.dart';

class Ticket{
  String? key;
  String? flightKey;
  int? economicTicketsCount;
  double? economicTicketsPrice;
  int? businessTicketsCount;
  double? businessTicketsPrice;

  Ticket({
    this.key,
    this.flightKey,
    this.economicTicketsCount,
    this.economicTicketsPrice,
    this.businessTicketsCount,
    this.businessTicketsPrice
  });

  factory Ticket.fromJson(String key, Map<String, dynamic> json){
    return Ticket(
      key: key,
      flightKey: json['flight_id'],
      economicTicketsPrice: json['economic_price'],
      economicTicketsCount: json['economic_count'],
      businessTicketsPrice: json['business_price'],
      businessTicketsCount: json['business_count'],
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
          Row(
            children: [
              const Icon(
                Icons.airplane_ticket_outlined,
                color: appColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "${appBloc.flightByTicketKey(ticket!.key!)!.titleStart!} - ${appBloc.flightByTicketKey(ticket!.key!)!.titleEnd!}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "${AppLocalizations.of(context, 'economic_class')}:  ",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500
                ),
                textAlign: TextAlign.center,
              ),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      ticket!.economicTicketsCount!.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      " ${AppLocalizations.of(context, 'tickets_left')}, ",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "${ticket!.economicTicketsPrice} $currency",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "${AppLocalizations.of(context, 'business_class')}:  ",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500
                ),
                textAlign: TextAlign.center,
              ),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      ticket!.businessTicketsCount!.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      " ${AppLocalizations.of(context, 'tickets_left')}, ",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "${ticket!.businessTicketsPrice} $currency",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}