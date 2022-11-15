import 'package:diplome_nick/data/model/flight.dart';
import 'package:diplome_nick/data/model/ticket.dart';
import 'package:diplome_nick/data/utils/constants.dart';
import 'package:diplome_nick/main.dart';
import 'package:diplome_nick/ui/bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class AppBloc extends BaseBloc{
  final List<Flight> currentFlights = [];
  final List<Ticket> currentTickets = [];

  final _flights = BehaviorSubject<List<Flight>?>();
  final _tickets = BehaviorSubject<List<Ticket>?>();

  Stream<List<Flight>?> get flightsStream => _flights.stream;
  Stream<List<Ticket>?> get ticketsStream => _tickets.stream;

  Function(List<Flight>?) get loadAllFlights => _flights.sink.add;
  Function(List<Ticket>?) get loadAllTickets => _tickets.sink.add;

  Future<void> callStreams() async{
    if(currentFlights.isNotEmpty){
      currentFlights.clear();
    }
    if(currentTickets.isNotEmpty){
      currentTickets.clear();
    }
    currentFlights.addAll((await loadFlights())!.toList());
    currentTickets.addAll((await loadTickets())!.toList());
    await loadAllFlights(currentFlights);
    await loadAllTickets(currentTickets);
  }

  Flight? flightByKey(String key) => currentFlights.
  firstWhere((element) => element.ticketsKey == key);

  Future<List<Ticket>?> loadTickets() async{
    final query = await FirebaseDatabase.instance.ref("tickets").once();
    if(query.snapshot.exists){
      final List<Ticket> tickets = [];
      final data = query.snapshot.children;
      for(var item in data){
        final ticket = Ticket.fromJson(item.key!, item.value as Map<String, dynamic>);
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
        final flight = Flight.fromJson(item.key!, item.value as Map<String, dynamic>);
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
    final flightsRef = FirebaseDatabase.instance.ref("flights");
    final flightsRefKey = flightsRef.push();
    await flightsRefKey.set({
      "start_title": start,
      "end_title": end,
      "start_date": startDate,
      "end_date": endDate
    });
    final ticketKey = await createTickets(flightsRefKey.key!);
    await flightsRef.child(flightsRefKey.key!).update({"tickets_id": ticketKey});
    await callStreams();
  }

  Future<String> createTickets(String flightKey, [int? count]) async{
    final ref = FirebaseDatabase.instance.ref("tickets").push();
    await ref.set({
      "flight_id": flightKey,
      "tickets_count": count ?? 80
    });
    return ref.key!;
  }

  Future<void> deleteFlight(String key, String ticketsKey) async{
    await FirebaseDatabase.instance.ref("flights/$key").remove();
    await FirebaseDatabase.instance.ref("tickets/$ticketsKey").remove();
    await callStreams();
  }

  Future<void> bookTicket(String flightKey, String ticketsKey) async{
    final ref = FirebaseDatabase.instance.ref("bookings/$flightKey").push();
    await ref.set({
      "flight_id": flightKey,
      "booked_by": firebaseBloc.fbUser!.uid,
      "book_date": DateFormat(dateFormat24h).format(DateTime.now())
    });
    final userRef = FirebaseDatabase.instance.ref("users/${firebaseBloc.fbUser!.uid}/bookings").push();
    await userRef.set({
      "flight_id": flightKey,
      "book_date": DateFormat(dateFormat24h).format(DateTime.now())
    });
    final ticketsRef = FirebaseDatabase.instance.ref("tickets/$ticketsKey");
    final count = ((await ticketsRef.get()).value as Map)['tickets_count'];
    ticketsRef.update({"tickets_count": count - 1});
    await callStreams();
  }

  Future<bool> alreadyBooked(String flightKey) async{
    final bookingsRef = await FirebaseDatabase.instance.ref("users/${firebaseBloc.fbUser!.uid}/bookings").once();
    for (var element in bookingsRef.snapshot.children) {
      if((element.value as Map)['flight_id'] == flightKey){
        return true;
      }
    }
    return false;
  }

  @override
  void dispose() {
    _tickets.close();
    _flights.close();
  }
}