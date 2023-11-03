import 'package:intl/intl.dart';

class TotalReservationsAnalytics {

  late List<dynamic> reservations;
  TotalReservationsAnalytics(this.reservations) {
    // Constructor code here
  }

  //Get at what time is a parking occupied the most (hour)
  int getMostOccupiedHour() {
    List<int> hours = [];
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm'); // Adjust the date format to match your input

    for (var reservation in reservations) {
      final entryTime = reservation['entry_time'];
      final dateTime = dateFormat.parse(entryTime);
      hours.add(dateTime.hour);
    }

    return hours.reduce((a, b) => a > b ? a : b);
  }

  //Get at what time is a parking occupied the least (hour)
int getLeastOccupiedHour() {
  List<int> hours = [];
  final dateFormat = DateFormat('yyyy-MM-dd HH:mm'); // Adjust the date format to match your input

  for (var reservation in reservations) {
    final entryTime = reservation['entry_time'];
    final dateTime = dateFormat.parse(entryTime);
    hours.add(dateTime.hour);
  }

  return hours.reduce((a, b) => a < b ? a : b);
}
  //Get reservation average duration
  double getAverageDuration() {
    double totalDuration = 0;
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm'); // Adjust the date format to match your input

    for (var reservation in reservations) {
      final entryTime = reservation['entry_time'];
      final exitTime = reservation['exit_time'];
      final dateTimeEntry = dateFormat.parse(entryTime);
      final dateTimeExit = dateFormat.parse(exitTime);
      totalDuration += dateTimeExit.difference(dateTimeEntry).inMinutes;
    }
    return totalDuration / reservations.length;
  }

  //Average cost of a reservation
  double getAverageCost() {
    double totalCost = 0;
    for (var reservation in reservations) {
      totalCost += double.parse(reservation['cost']);
    }
    return totalCost / reservations.length;
  }

  //Get the most expensive reservation
  double getMostExpensiveReservation() {
    double mostExpensive = 0;
    for (var reservation in reservations) {
      if (double.parse(reservation['cost']) > mostExpensive) {
        mostExpensive = double.parse(reservation['cost']);
      }
    }
    return mostExpensive;
  }

  //Get the cheapest reservation
  double getCheapestReservation() {
    double cheapest = double.infinity;
    for (var reservation in reservations) {
      if (double.parse(reservation['cost']) < cheapest) {
        cheapest = double.parse(reservation['cost']);
      }
    }
    return cheapest;
  }

  //Most popular parking
  String getMostPopularParking() {
    Map<String, int> parkingCount = {};
    for (var reservation in reservations) {
      if (parkingCount.containsKey(reservation['parking']['name'])) {
        parkingCount[reservation['parking']['name']] = parkingCount[reservation['parking']['name']]! + 1;
      } else {
        parkingCount[reservation['parking']['name']] = 1;
      }
    }
    String mostPopular = '';
    int mostPopularCount = 0;
    for (var parking in parkingCount.keys) {
      if (parkingCount[parking]! > mostPopularCount) {
        mostPopular = parking;
        mostPopularCount = parkingCount[parking]!;
      }
    }
    return mostPopular;
  }



}
