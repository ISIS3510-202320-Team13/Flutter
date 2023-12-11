import 'dart:math';

// Taken from https://github.com/shawnchan2014/haversine-dart/blob/a6b55779c5fb250a2fd84a4e0705c3d8965987dd/Haversine.dart#L1-L19
class Haversine {
  static final R = 6372.8; // In kilometers

  static double haversine(double lat1, lon1, lat2, lon2) {
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    lat1 = _toRadians(lat1);
    lat2 = _toRadians(lat2);
    double a =
        pow(sin(dLat / 2), 2) + pow(sin(dLon / 2), 2) * cos(lat1) * cos(lat2);
    double c = 2 * asin(sqrt(a));
    return R * c * 1000; // Convert to meters
  }

  static double _toRadians(double degree) {
    return degree * pi / 180;
  }
}
