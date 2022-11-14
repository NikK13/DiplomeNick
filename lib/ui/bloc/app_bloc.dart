import 'package:diplome_nick/data/model/flight.dart';
import 'package:diplome_nick/data/model/ticket.dart';
import 'package:diplome_nick/data/utils/constants.dart';
import 'package:diplome_nick/ui/bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class AppBloc extends BaseBloc{
  Future<List<Ticket>?> loadTickets() async{
    final query = await FirebaseDatabase.instance.ref("tickets").once();
    if(query.snapshot.exists){
      final List<Ticket> tickets = [];
      final data = query.snapshot.children;
      for(var item in data){
        final ticket = Ticket.fromJson(item.value as Map<String, dynamic>);
        tickets.add(ticket);
      }
      return tickets;
    }
    else{
      return [];
    }
  }

  Future<List<Flight>?> loadFlights() async{
    final query = await FirebaseDatabase.instance.ref("flights").once();
    if(query.snapshot.exists){
      final List<Flight> flights = [];
      final data = query.snapshot.children;
      for(var item in data){
        final flight = Flight.fromJson(item.value as Map<String, dynamic>);
        flights.add(flight);
      }
      if(flights.isNotEmpty){
        flights.sort((a,b){
          return DateFormat(dateFormat24h).parse(a.endDate!)
              .isBefore(DateFormat(dateFormat24h).parse(b.endDate!)) ? 1 : 0;
        });
      }
      return flights;
    }
    else{
      return [];
    }
  }

  Future<void> addNewFlight(String start, String end, String startDate, String endDate) async{
    await FirebaseDatabase.instance.ref("flights").push().set({
      "start_title": start,
      "end_title": end,
      "start_date": startDate,
      "end_date": endDate
    });
  }

  @override
  void dispose() {}
}