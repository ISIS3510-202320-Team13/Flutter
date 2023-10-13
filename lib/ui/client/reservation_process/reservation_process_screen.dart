import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkez/data/models/reservations/parking.dart';
import 'package:parkez/data/models/reservations/payment.dart';
import 'package:parkez/data/models/reservations/reservation.dart';
import 'package:parkez/data/repositories/parking_reservation_repository.dart';
import 'package:parkez/logic/reservation/bloc/parking_reservation_bloc.dart';
import 'package:parkez/logic/reservation/time_reservation/cubit/time_reservation_cubit.dart';
import 'package:parkez/ui/client/reservation_process/widgets/parking_view.dart';
import 'package:parkez/ui/client/reservation_process/widgets/reservation_view.dart';
import 'package:parkez/ui/utils/helper_widgets.dart';

import 'widgets/payment_view.dart';
import 'widgets/checkout_view.dart';

class ParkingReservation extends StatelessWidget {
  final Parking selectedParking;

  const ParkingReservation({
    super.key,
    required this.selectedParking,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ParkingReservationBloc(
            parkingReservationRepository:
                context.read<ParkingReservationRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => TimeReservationCubit(),
        ),
      ],
      child: ReservationProcessScreen(selectedParking: selectedParking),
    );
  }
}

class ReservationProcessScreen extends StatefulWidget {
  final Parking selectedParking;
  ReservationProcessScreen({super.key, required this.selectedParking});

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
                BlocProvider.of<ParkingReservationBloc>(context).add(
                    ParkingReservationParkingSelected(widget.selectedParking));
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
              content: ParkingDetailsView(parking: widget.selectedParking),
            ),
            Step(
                isActive: _currentStep == ReservationStep.reservation,
                // label: const Text('Reservation Details'),
                title: const Text(''),
                content: ReservationDetailsView(
                  onReservationUpdated: (reservation) {
                    print("RESERVATION UPDATED");
                    BlocProvider.of<ParkingReservationBloc>(context).add(
                      ParkingReservationReservationDetailsSelected(
                        reservation,
                      ),
                    );
                  },
                )),
            Step(
              isActive: _currentStep == ReservationStep.payment,
              // label: const Text('Payment'),
              title: const Text(''),
              content: const PaymentView(),
            ),
            Step(
              isActive: _currentStep == ReservationStep.checkout,
              // label: const Text('Checkout'),
              title: const Text(''),
              // content: Center(child: const Text('Checkout')),
              content: const CheckoutView(),
            ),
          ],
        ),
      ),
    );
  }
}
