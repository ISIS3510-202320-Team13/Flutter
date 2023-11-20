import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkez/data/models/reservations/parking.dart';
import 'package:parkez/data/models/reservations/payment.dart';
import 'package:parkez/data/models/reservations/reservation.dart';
import 'package:parkez/data/repositories/reservation_repository.dart';
import 'package:parkez/data/repositories/user_repository.dart';
import 'package:parkez/logic/reservation/bloc/parking_reservation_bloc.dart';
import 'package:parkez/logic/reservation/reservation_controller.dart';
import 'package:parkez/logic/reservation/time_reservation/cubit/time_reservation_cubit.dart';
import 'package:parkez/ui/reservation_process/widgets/parking_view.dart';
import 'package:parkez/ui/reservation_process/widgets/reservation_view.dart';
import 'package:parkez/ui/utils/helper_widgets.dart';

import 'widgets/payment_view.dart';
import 'widgets/checkout_view.dart';

class ReservationProcessScreen extends StatelessWidget {
  final Parking selectedParking;

  const ReservationProcessScreen({
    super.key,
    required this.selectedParking,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ParkingReservationBloc>(
          create: (_) => ParkingReservationBloc(
            reservationController: ReservationController(
              reservationRepository: ReservationRepository(),
              userRepository: UserRepository(),
            ),
          ),
        ),
        BlocProvider<TimeReservationCubit>(
          create: (_) => TimeReservationCubit(),
        ),
      ],
      child: ReservationProcess(selectedParking: selectedParking),
    );
  }
}

class ReservationProcess extends StatefulWidget {
  final Parking selectedParking;
  ReservationProcess({super.key, required this.selectedParking});

  @override
  State<ReservationProcess> createState() => _ReservationProcessState();
}

class _ReservationProcessState extends State<ReservationProcess> {
  final Payment mockPayment = const Payment(
      id: '1', price: 13000, paymentMethod: PaymentMethods.creditCard);

  ReservationStep _currentStep = ReservationStep.parking;
  Reservation _reservation = Reservation.empty;
  DateTime? _startDatetime;
  double? _duration;

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
                print("PARKING SELECTED");
                BlocProvider.of<ParkingReservationBloc>(context).add(
                    ParkingReservationParkingSelected(widget.selectedParking));
                break;
              case ReservationStep.reservation:
                print("RESERVATION SELECTED");

                _reservation = _reservation.copyWith(
                    timeToReserve: _duration, startDatetime: _startDatetime);

                BlocProvider.of<ParkingReservationBloc>(context).add(
                  ParkingReservationReservationDetailsSelected(
                    _reservation,
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
              title: const Text(''),
              content: ParkingDetailsView(parking: widget.selectedParking),
            ),
            Step(
                isActive: _currentStep == ReservationStep.reservation,
                title: const Text(''),
                content: ReservationDetailsView(
                  onDateUpdated: (datetime) {
                    _startDatetime = datetime;
                  },
                  onDurationUpdated: (duration) {
                    _duration = duration;
                  },
                )),
            Step(
              isActive: _currentStep == ReservationStep.payment,
              title: const Text(''),
              content: const PaymentView(),
            ),
            Step(
              isActive: _currentStep == ReservationStep.checkout,
              title: const Text(''),
              content: const CheckoutView(),
            ),
          ],
        ),
      ),
    );
  }
}