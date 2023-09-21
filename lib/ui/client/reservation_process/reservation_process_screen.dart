import 'package:flutter/material.dart';
import 'package:parkez/ui/client/reservation_process/widgets/process_stepper.dart';
import 'package:parkez/ui/utils/helper_widgets.dart';

class ReservationProcessScreen extends StatelessWidget {
  const ReservationProcessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Reserve a Parking Spot'),
      body: ProcessStepper(),
    );
  }
}
