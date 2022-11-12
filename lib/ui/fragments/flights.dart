import 'package:flutter/material.dart';

class FlightsFragment extends StatelessWidget {
  const FlightsFragment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "F L I G H T S",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600
        ),
      ),
    );
  }
}
