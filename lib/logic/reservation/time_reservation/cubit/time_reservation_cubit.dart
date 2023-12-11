import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:parkez/data/models/reservations/date_reservation.dart';
import 'package:parkez/data/models/reservations/duration_reservation.dart';
import 'package:parkez/data/models/reservations/reservation.dart';

part 'time_reservation_state.dart';

class TimeReservationCubit extends Cubit<TimeReservationState> {
  TimeReservationCubit() : super(const TimeReservationState());

  void dateChanged(String value, Function onDateUpdated) {
    final date = DateTimeReservation.dirty(value);

    if (date.value.isNotEmpty) {
      onDateUpdated(DateTime.parse(date.value));
    }

    emit(
      state.copyWith(
        date: date,
        isValid: Formz.validate([
          date,
          state.duration,
        ]),
      ),
    );
  }

  void durationChanged(String value, Function onDurationUpdated) {
    final duration = DurationReservation.dirty(value);

    if (duration.value.isNotEmpty) {
      onDurationUpdated(double.parse(duration.value));
    }

    emit(
      state.copyWith(
        duration: duration,
        isValid: Formz.validate([
          state.date,
          duration,
        ]),
      ),
    );
  }

  Future<void> submit(
      void Function(Reservation reservation) onReservationConfirmed) async {
    print("RESERVATION SUBMITTED IN CUBIT");
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      print("time_reservation_cubit:44 before reservation");
      onReservationConfirmed(
        Reservation(
          id: '',
          startDatetime: DateTime.parse(state.date.value),
          endDatetime: DateTime.parse(state.date.value)
              .add(Duration(minutes: int.parse(state.duration.value))),
          timeToReserve: double.parse(state.duration.value),
          cost: double.parse(state.duration.value) * 2000,
        ),
      );
      print("time_reservation_cubit:55 After");
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
