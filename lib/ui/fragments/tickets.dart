import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class TicketsFragment extends StatefulWidget {
  const TicketsFragment({Key? key}) : super(key: key);

  @override
  State<TicketsFragment> createState() => _TicketsFragmentState();
}

class _TicketsFragmentState extends State<TicketsFragment> {
  late DatabaseReference _ticketsDb;

  @override
  void initState() {
    _ticketsDb = FirebaseDatabase.instance.ref("tickets");
    //debugPrint("${_ticketsDb.child("1").get()}");
    _ticketsDb.once().then((child){
      debugPrint(child.snapshot.value.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "T I C K E T S",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600
        ),
      ),
    );
  }
}
