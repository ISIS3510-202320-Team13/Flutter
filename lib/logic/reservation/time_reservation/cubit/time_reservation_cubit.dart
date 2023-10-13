import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:parkez/data/models/reservations/date_reservation.dart';
import 'package:parkez/data/models/reservations/duration_reservation.dart';
import 'package:parkez/data/models/reservations/reservation.dart';

part 'time_reservation_state.dart';

class TimeReservationCubit extends Cubit<TimeReservationState> {
  TimeReservationCubit() : super(const TimeReservationState());

  void dateChanged(String value) {
    final date = DateTimeReservation.dirty(value);
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

  void durationChanged(String value) {
    final duration = DurationReservation.dirty(value);
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
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      onReservationConfirmed(
        // TODO: Check how the fk to get the id
        Reservation(
          id: '1',
          startDatetime: DateTime.parse(state.date.value),
          endDatetime: DateTime.parse(state.date.value)
              .add(Duration(minutes: int.parse(state.duration.value))),
        ),
      );
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
