import 'package:parkez/data/models/reservations/reservation.dart';
import 'package:parkez/data/repositories/reservation_repository.dart';
import 'package:parkez/data/repositories/user_repository.dart';

class ReservationController {
  String? parkingId;
  Reservation currentRes;

  final ReservationRepository _reservationRepository;
  final UserRepository _userRepository;

  ReservationController({
    ReservationRepository? reservationRepository,
    UserRepository? userRepository,
    this.parkingId,
    Reservation? currentRes,
  })  : _reservationRepository =
            reservationRepository ?? ReservationRepository(),
        _userRepository = userRepository ?? UserRepository(),
        currentRes = currentRes ?? Reservation.empty;

  void setParkingId(String parkingId) {
    this.parkingId = parkingId;
  }

  void updateReservation({duration, startDatetime}) {
    currentRes = currentRes.copyWith(
      timeToReserve: duration,
      startDatetime: startDatetime,
    );
  }

  void selectReservation({required Reservation reservation}) {
    currentRes = reservation;
  }

  Future<Reservation> reserveParkingSpot() async {
    // 1. Create a new reservation

    String userId = await _userRepository.getUserId() ?? "";

    if (parkingId == null) {
      throw Exception("Parking ID is null");
    }

    if (userId == "") {
      throw Exception("User ID is null");
    }

    if (currentRes.isEmpty) {
      throw Exception("Reservation is empty");
    }

    Reservation oldRes = Reservation(
      id: "",
      cost: currentRes.cost,
      startDatetime: currentRes.startDatetime,
      endDatetime: currentRes.endDatetime,
      parkingId: parkingId,
      status: "Reserved",
      userId: userId,
      timeToReserve: currentRes.timeToReserve,
    );

    // 2. Update the parking spot to be reserved
    // TODO

    return await _reservationRepository.addReservation(oldRes);
  }

  void cancelReservation() {
    parkingId = null;
    currentRes = Reservation.empty;
  }
}
