import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:parkez/logic/reservation/time_reservation/cubit/time_reservation_cubit.dart';

class ReservationDetailsView extends StatefulWidget {
  final void Function(DateTime datetime) onDateUpdated;
  final void Function(double duration) onDurationUpdated;

  ReservationDetailsView(
      {Key? key, required this.onDateUpdated, required this.onDurationUpdated})
      : super(key: key);

  @override
  State<ReservationDetailsView> createState() => _ReservationDetailsViewState();
}

class _ReservationDetailsViewState extends State<ReservationDetailsView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print("RESERVATION DETAILS BUILDER");

    return BlocListener<TimeReservationCubit, TimeReservationState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                  content: Text(state.errorMessage ?? 'Reservation Failure')),
            );
          return;
        }
        if (state.status.isSuccess) {
          print("Submitted");
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DateTimePicker(onDateUpdated: widget.onDateUpdated),
              const SizedBox(height: 8),
              _DurationInput(onDurationUpdated: widget.onDurationUpdated),
            ],
          ),
        ),
      ),
    );
  }
}

class DateTimePicker extends StatelessWidget {
  final Function(DateTime datetime) onDateUpdated;
  const DateTimePicker({super.key, required this.onDateUpdated});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimeReservationCubit, TimeReservationState>(
      buildWhen: (previous, current) => previous.date != current.date,
      builder: (context, state) {
        return GestureDetector(
          onTap: () => onDateTap(context, state),
          child: AbsorbPointer(
            child: TextFormField(
              key: const Key('timeReservationForm_dateInput_textField'),
              decoration: InputDecoration(
                labelText: 'Date',
                helperText: '',
                errorText:
                    state.date.displayError != null ? 'invalid date' : null,
              ),
              controller: TextEditingController(
                text: state.date.value.toString(),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> onDateTap(
      BuildContext context, TimeReservationState state) async {
    final selectedDate = await showDateTimePicker(
      context: context,
    );

    print("Selected Date: $selectedDate");

    if (selectedDate != null) {
      context
          .read<TimeReservationCubit>()
          .dateChanged(selectedDate.toString(), onDateUpdated);
    }
  }

  Future<DateTime?> showDateTimePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    initialDate ??= DateTime.now();
    firstDate ??= DateTime.now();
    lastDate ??= firstDate.add(const Duration(days: 7));

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate == null) return null;

    if (!context.mounted) return selectedDate;

    final TimeOfDay? selectedTime = await showTimePicker(
        context: context, initialTime: TimeOfDay.fromDateTime(selectedDate));

    return selectedTime == null
        ? selectedDate
        : DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
  }
}

class _DurationInput extends StatelessWidget {
  final Function(double duration) onDurationUpdated;

  const _DurationInput({Key? key, required this.onDurationUpdated})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimeReservationCubit, TimeReservationState>(
      buildWhen: (previous, current) => previous.duration != current.duration,
      builder: (context, state) {
        return TextField(
          key: const Key('timeReservationForm_durationInput_textField'),
          onChanged: (duration) => context
              .read<TimeReservationCubit>()
              .durationChanged(duration, onDurationUpdated),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Duration (in minutes)',
            helperText: '',
            errorText:
                state.duration.displayError != null ? 'invalid duration' : null,
          ),
        );
      },
    );
  }
}
