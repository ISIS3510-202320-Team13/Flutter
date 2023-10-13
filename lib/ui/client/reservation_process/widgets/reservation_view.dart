import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:parkez/data/models/reservations/reservation.dart';
import 'package:parkez/logic/reservation/time_reservation/cubit/time_reservation_cubit.dart';

class ReservationDetailsView extends StatefulWidget {
  final void Function(Reservation reservation) onReservationUpdated;

  ReservationDetailsView({
    Key? key,
    required this.onReservationUpdated,
  }) : super(key: key);

  @override
  State<ReservationDetailsView> createState() => _ReservationDetailsViewState();
}

class _ReservationDetailsViewState extends State<ReservationDetailsView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<TimeReservationCubit, TimeReservationState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          // The following generates an error:
          context
              .read<TimeReservationCubit>()
              .submit(widget.onReservationUpdated);
          print("Submitted");
        } else if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                  content: Text(state.errorMessage ?? 'Reservation Failure')),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DateTimePicker(),
              const SizedBox(height: 8),
              _DurationInput(),
              // TODO: Check how to handle the submit of the form
              // from the parent widget
            ],
          ),
        ),
      ),
    );
  }
}

class DateTimePicker extends StatelessWidget {
  const DateTimePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimeReservationCubit, TimeReservationState>(
      buildWhen: (previous, current) => previous.date != current.date,
      builder: (context, state) {
        return TextField(
          key: const Key('timeReservationForm_dateInput_textField'),
          onChanged: (date) =>
              context.read<TimeReservationCubit>().dateChanged(date),
          keyboardType: TextInputType.datetime,
          decoration: InputDecoration(
            labelText: 'date',
            helperText: 'YYYY-MM-DD HH:MM',
            errorText: state.date.displayError != null ? 'invalid date' : null,
          ),
        );
      },
    );
  }
}

class _DurationInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimeReservationCubit, TimeReservationState>(
      buildWhen: (previous, current) => previous.duration != current.duration,
      builder: (context, state) {
        return TextField(
          key: const Key('timeReservationForm_durationInput_textField'),
          onChanged: (duration) =>
              context.read<TimeReservationCubit>().durationChanged(duration),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'duration',
            helperText: '',
            errorText:
                state.duration.displayError != null ? 'invalid duration' : null,
          ),
        );
      },
    );
  }
}
