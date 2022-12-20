import 'package:diplome_nick/data/model/book.dart';
import 'package:diplome_nick/data/model/flight.dart';
import 'package:diplome_nick/data/model/ticket.dart';
import 'package:diplome_nick/data/model/user.dart';
import 'package:diplome_nick/data/utils/constants.dart';
import 'package:diplome_nick/data/utils/lists.dart';
import 'package:diplome_nick/main.dart';
import 'package:diplome_nick/ui/bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class AppBloc extends BaseBloc{
  List<Flight> currentFlights = [];
  List<Flight> currentTicketsFlights = [];
  List<Ticket> currentTickets = [];
  List<User> currentUsers = [];

  String filterFlightsStart = "";
  String filterFlightsEnd = "";
  String filterTicketsStart = "";
  String filterTicketsEnd = "";

  final _flights = BehaviorSubject<List<Flight>?>();
  final _tickets = BehaviorSubject<List<Ticket>?>();
  final _users = BehaviorSubject<List<User>?>();

  final _bookings = BehaviorSubject<List<Booking>?>();

  Stream<List<User>?> get usersStream => _users.stream;
  Stream<List<Flight>?> get flightsStream => _flights.stream;
  Stream<List<Ticket>?> get ticketsStream => _tickets.stream;
  Stream<List<Booking>?> get bookingsStream => _bookings.stream;

  Function(List<Flight>?) get loadAllFlights => _flights.sink.add;
  Function(List<User>?) get loadAllUsers => _users.sink.add;
  Function(List<Ticket>?) get loadAllTickets => _tickets.sink.add;
  Function(List<Booking>?) get loadAllBookings => _bookings.sink.add;

  Future<void> callUsersStreams() async{
    await loadAllUsers(null);
    final users = (await loadUsers())!.toList();
    currentUsers = users;
    await loadAllUsers(users);
  }

  callFlightsStream([String? start, String? end]) async{
    await loadAllFlights(null);
    final flights = (await loadFlights(start, end))!.toList();
    currentFlights = flights;
    await loadAllFlights(flights);
  }

  callTicketsStream([String? start, String? end]) async{
    await loadAllTickets(null);
    final tickets = (await loadTickets(start, end))!.toList();
    currentTickets = tickets;
    await loadAllTickets(tickets);
  }

  callBookingsStreams() async{
    await loadAllBookings((await loadMyOrders(firebaseBloc.fbAuth.currentUser!.uid))!.toList());
  }

  Flight? flightByTicketKey(String key) => currentTicketsFlights.
  firstWhere((element) => element.ticketsKey == key);

  Flight? flightByKey(String key) => currentTicketsFlights.
  firstWhere((element) => element.key == key);

  Future<List<Ticket>?> loadTickets([String? start, String? end]) async{
    final query = await FirebaseDatabase.instance.ref("tickets").once();
    if(query.snapshot.exists){
      final List<Ticket> tickets = [];
      final data = query.snapshot.children;
      for(var item in data){
        final ticket = Ticket.fromJson(item.key!, item.value as Map<String, dynamic>);
        tickets.add(ticket);
      }
      if(tickets.isNotEmpty && currentTicketsFlights.isNotEmpty){
        tickets.sort((a,b){
          return DateFormat(dateFormat24h).parse(currentTicketsFlights.firstWhere((element) => element.key == a.flightKey!).endDate!)
          .isBefore(DateFormat(dateFormat24h).parse(currentTicketsFlights.firstWhere((element) => element.key == b.flightKey!).endDate!)) ?
          (isAsAdministrator ? 1 : 0) : (isAsAdministrator ? 0 : 1);
        });
      }
      if(isAsAdministrator){
        if(start != null && end != null && currentFlights.isNotEmpty){
          if(start.isEmpty && end.isNotEmpty){
            final endVal = destinations.firstWhere((element) => element.value == end);
            return tickets.where((element) => currentTicketsFlights.firstWhere((flightEl)
            => flightEl.key == element.flightKey).titleEnd == endVal.title).toList();
          }
          else if(start.isNotEmpty && end.isEmpty){
            final startVal = destinations.firstWhere((element) => element.value == start);
            return tickets.where((element) => currentTicketsFlights.firstWhere((flightEl)
            => flightEl.key == element.flightKey).titleStart == startVal.title).toList();
          }
          else if(start.isNotEmpty && end.isNotEmpty){
            final startVal = destinations.firstWhere((element) => element.value == start);
            final endVal = destinations.firstWhere((element) => element.value == end);
            return tickets.where((element) => currentTicketsFlights.firstWhere((flightEl)
            => flightEl.key == element.flightKey).titleEnd == endVal.title
              && currentTicketsFlights.firstWhere((flightEl) => flightEl.key ==
              element.flightKey).titleStart == startVal.title).toList();
          }
          else{
            return tickets;
          }
        }
        else {
          return tickets;
        }
      }
      return tickets;
    }
    else{
      return [];
    }
  }

  Future<List<Booking>?> loadMyOrders(String userId) async{
    final query = await FirebaseDatabase.instance.ref("bookings").once();
    if(query.snapshot.exists){
      final List<Booking> bookings = [];
      final data = query.snapshot.children;
      for (var element in data) {
        for(var el in element.children){
          if((el.value as Map<String, dynamic>)['booked_by'] == userId){
            final book = Booking.fromJson(el.key!, el.value as Map<String, dynamic>);
            bookings.add(book);
          }
        }
      }
      return bookings;
    }
    else{
      return [];
    }
  }

  Future<List<User>?> loadUsers() async{
    final query = await FirebaseDatabase.instance.ref("users").once();
    if(query.snapshot.exists){
      final List<User> users = [];
      final data = query.snapshot.children;
      for(var item in data){
        final book = User.fromJson(item.key!, item.value as Map<String, dynamic>);
        users.add(book);
      }
      return users;
    }
    else{
      return [];
    }
  }

  Future<List<Flight>?> loadFlights([String? start, String? end, DateTime? date]) async{
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
          .isBefore(DateFormat(dateFormat24h).parse(b.endDate!)) ?
          (isAsAdministrator ? 1 : 0) : (isAsAdministrator ? 0 : 1);
        });
      }
      currentTicketsFlights = flights;
      if(isAsAdministrator){
        if(start != null && end != null){
          if(start.isEmpty && end.isNotEmpty){
            final endVal = destinations.firstWhere((element) => element.value == end);
            return flights.where((element) => element.titleEnd == endVal.title).toList();
          }
          else if(start.isNotEmpty && end.isEmpty){
            final startVal = destinations.firstWhere((element) => element.value == start);
            return flights.where((element) => element.titleStart == startVal.title).toList();
          }
          else if(start.isNotEmpty && end.isNotEmpty){
            final startVal = destinations.firstWhere((element) => element.value == start);
            final endVal = destinations.firstWhere((element) => element.value == end);
            return flights.where((element) => element.titleStart == startVal.title
              && element.titleEnd == endVal.title).toList();
          }
          else{
            return flights;
          }
        }
        else {
          return flights;
        }
      }
      else{
        if(start != null && end != null && date != null){
          final startVal = destinations.firstWhere((element) => element.value == start);
          final endVal = destinations.firstWhere((element) => element.value == end);
          return flights.where((element) =>
          startVal.title == element.titleStart && endVal.title == element.titleEnd &&
          DateFormat(dateFormat).parse(element.startDate!).isAtSameMomentAs(date)).toList();
        }
      }
      return flights;
    }
    else{
      return [];
    }
  }

  Future<void> addNewFlight(Flight flight, Ticket ticket) async{
    final flightsRef = FirebaseDatabase.instance.ref("flights");
    final flightsRefKey = flightsRef.push();
    await flightsRefKey.set({
      "start_title": flight.titleStart!,
      "end_title": flight.titleEnd!,
      "start_date": flight.startDate!,
      "end_date": flight.endDate!
    });
    final ticketKey = await createTickets(flightsRefKey.key!, ticket);
    await flightsRef.child(flightsRefKey.key!).update({"tickets_id": ticketKey});
    await callFlightsStream(filterFlightsStart, filterFlightsEnd);
    await callTicketsStream(filterTicketsStart, filterTicketsEnd);
  }

  Future<String> createTickets(String flightKey, Ticket ticket) async{
    final ref = FirebaseDatabase.instance.ref("tickets").push();
    await ref.set({
      "flight_id": flightKey,
      "economic_price": ticket.economicTicketsPrice,
      "economic_count": ticket.economicTicketsCount,
      "business_price": ticket.businessTicketsPrice,
      "business_count": ticket.businessTicketsCount,
    });
    return ref.key!;
  }

  Future<void> updateUser(String key, Map<String, Object?> item) async{
    final ref = FirebaseDatabase.instance.ref("users/$key");
    await ref.update(item);
  }

  Future<void> deleteFlight(String key, String ticketsKey) async{
    await FirebaseDatabase.instance.ref("flights/$key").remove();
    await FirebaseDatabase.instance.ref("tickets/$ticketsKey").remove();
    await FirebaseDatabase.instance.ref("bookings/$key").remove();
    await callFlightsStream(filterFlightsStart, filterFlightsEnd);
    await callTicketsStream(filterTicketsStart, filterTicketsEnd);
  }

  Future<void> cancelBook(Booking booking) async{
    await FirebaseDatabase.instance.ref("bookings/${booking.flightKey}/${booking.key}").remove();
    final ticketsRef = FirebaseDatabase.instance.ref("tickets/${booking.ticketsKey}");
    final fieldToUpd = booking.ticketType! == "business" ? 'business_count' : 'economic_count';
    final count = ((await ticketsRef.get()).value as Map)[fieldToUpd];
    ticketsRef.update({fieldToUpd: count + 1});
  }

  Future<void> bookTicket(String flightKey, String ticketsKey, bool isBusiness) async{
    final ref = FirebaseDatabase.instance.ref("bookings/$flightKey").push();
    await ref.set({
      "flight_id": flightKey,
      "tickets_id": ticketsKey,
      "booked_by": firebaseBloc.fbUser!.uid,
      "ticket_type": isBusiness ? "business" : "economic",
      "book_date": DateFormat(dateFormat24h).format(DateTime.now())
    });
    final ticketsRef = FirebaseDatabase.instance.ref("tickets/$ticketsKey");
    final fieldToUpd = isBusiness ? 'business_count' : 'economic_count';
    final count = ((await ticketsRef.get()).value as Map)[fieldToUpd];
    ticketsRef.update({fieldToUpd: count - 1});
    await callFlightsStream();
    await callTicketsStream();
  }

  Future<bool> alreadyBooked(String flightKey) async{
    final bookingsRef = await FirebaseDatabase.instance.ref("bookings/$flightKey").once();
    for (var element in bookingsRef.snapshot.children) {
      final el = (element.value as Map);
      if(el['flight_id'] == flightKey && el['booked_by'] == firebaseBloc.fbAuth.currentUser!.uid){
        return true;
      }
    }
    return false;
  }

  @override
  void dispose() {
    _tickets.close();
    _flights.close();
    _bookings.close();
  }
}