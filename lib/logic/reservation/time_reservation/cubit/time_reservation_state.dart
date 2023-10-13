part of 'time_reservation_cubit.dart';

class TimeReservationState extends Equatable {
  final DateTimeReservation date;
  final DurationReservation duration;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;

  const TimeReservationState({
    this.date = const DateTimeReservation.pure(),
    this.duration = const DurationReservation.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.errorMessage,
  });

  TimeReservationState copyWith({
    DateTimeReservation? date,
    DurationReservation? duration,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return TimeReservationState(
      date: date ?? this.date,
      duration: duration ?? this.duration,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [date, duration, status, isValid, errorMessage];
}
