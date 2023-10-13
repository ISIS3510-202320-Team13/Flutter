import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkez/data/models/reservations/parking.dart';
import 'package:parkez/data/models/reservations/payment.dart';
import 'package:parkez/data/models/reservations/reservation.dart';
import 'package:parkez/data/repositories/parking_reservation_repository.dart';
import 'package:parkez/logic/reservation/bloc/parking_reservation_bloc.dart';
import 'package:parkez/ui/utils/helper_widgets.dart';

import 'widgets/payment_view.dart';
import 'widgets/checkout_view.dart';

class ParkingReservation extends StatelessWidget {
  const ParkingReservation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ParkingReservationBloc(
        parkingReservationRepository:
            context.read<ParkingReservationRepository>(),
      ),
      child: ReservationProcessScreen(),
    );
  }
}

class ReservationProcessScreen extends StatefulWidget {
  ReservationProcessScreen({super.key});

  @override
  State<ReservationProcessScreen> createState() =>
      _ReservationProcessScreenState();
}

class _ReservationProcessScreenState extends State<ReservationProcessScreen> {
  // TODO: This should be passed in from the previous screen
  final Parking mockParking = const Parking(
    id: '1',
    name: 'Parking 1',
  );

  final Reservation mockReservation = Reservation(
    id: '1',
    startDatetime: DateTime.now(),
    endDatetime: DateTime.now().add(const Duration(hours: 1)),
  );

  final Payment mockPayment = const Payment(
      id: '1', price: 13000, paymentMethod: PaymentMethods.creditCard);

  ReservationStep _currentStep = ReservationStep.parking;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Reserve a Parking Spot'),
      body: BlocListener<ParkingReservationBloc, ParkingReservationState>(
        listener: (context, state) {
          if (state.step == ReservationStep.confirmation ||
              state.step == ReservationStep.cancelled) {
            Navigator.of(context).pop();
            return;
          }
          _currentStep = state.step;
          setState(() {});
          print("CHANGE TO STEP: $_currentStep");
        },
        child: Stepper(
          type: StepperType.horizontal,
          currentStep: _currentStep.index,
          onStepCancel: () {
            print("CANCEL REQUESTED");
            BlocProvider.of<ParkingReservationBloc>(context)
                .add(ParkingReservationCancelRequested());
          },
          onStepContinue: () {
            print("ON STEP CONTINUE");
            switch (_currentStep) {
              case ReservationStep.parking:
                // TODO: Don't do a mock parking
                print("PARKING SELECTED");
                BlocProvider.of<ParkingReservationBloc>(context)
                    .add(ParkingReservationParkingSelected(mockParking));
                break;
              case ReservationStep.reservation:
                print("RESERVATION SELECTED");
                BlocProvider.of<ParkingReservationBloc>(context).add(
                  ParkingReservationReservationDetailsSelected(
                    mockReservation,
                  ),
                );
                break;
              case ReservationStep.payment:
                print("PAYMENT SELECTED");
                BlocProvider.of<ParkingReservationBloc>(context).add(
                  ParkingReservationPaymentDetailsSelected(
                    mockPayment,
                  ),
                );
                break;
              case ReservationStep.checkout:
                print("CHECKOUT ");
                BlocProvider.of<ParkingReservationBloc>(context)
                    .add(ParkingReservationCheckoutSubmitted());
                break;
              default:
                break;
            }
          },
          steps: [
            Step(
              isActive: _currentStep == ReservationStep.parking,
              // label: const Text('Parking Details'),
              title: const Text(''),
              content: Center(child: const Text('Parking Details')),
            ),
            Step(
              isActive: _currentStep == ReservationStep.reservation,
              // label: const Text('Reservation Details'),
              title: const Text(''),
              content: Center(child: const Text('Reservation Details')),
            ),
            Step(
              isActive: _currentStep == ReservationStep.payment,
              // label: const Text('Payment'),
              title: const Text(''),
              content: Container(child: PaymentView()),
            ),
            Step(
              isActive: _currentStep == ReservationStep.checkout,
              // label: const Text('Checkout'),
              title: const Text(''),
              // content: Center(child: const Text('Checkout')),
              content: Container(child: CheckoutView()),
            ),
          ],
        ),
      ),
    );
  }
}
