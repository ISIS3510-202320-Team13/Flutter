import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkez/data/models/parking.dart';
import 'package:parkez/data/repositories/parking_repository.dart';
import 'package:parkez/data/utils/type_conversions.dart';
import 'package:parkez/logic/calls/apiCall.dart';
import 'package:parkez/logic/geolocation/bloc/location_bloc.dart';
import 'package:parkez/logic/geolocation/harvesine.dart';

import 'package:parkez/ui/theme/theme_constants.dart';
import 'package:parkez/ui/reservation_process/reservation_process_screen.dart';

class NearParkinsPage extends StatefulWidget {
  const NearParkinsPage(
      {super.key, required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  @override
  State<NearParkinsPage> createState() => _NearParkinsPageState();
}

class _NearParkinsPageState extends State<NearParkinsPage> {
  double latitude = 0.0;
  double longitude = 0.0;

  final ParkingRepository _parkingRepository = ParkingRepository();
  final ApiCall _api = ApiCall();

  late Parking choice = Parking.empty;
  late List<Parking> parkings = [];

  @override
  void initState() {
    super.initState();

    latitude = widget.latitude;
    longitude = widget.longitude;
    _onListCreated();
  }

  late GoogleMapController mapController;

  late final LatLng _center = LatLng(latitude, longitude);

  Future<Map<String, dynamic>> _fetchNearParkingsAPI(
      double lat, double lon) async {
    try {
      Map<String, dynamic> res = await _api
          .fetch('http://parkez.xyz:8082/parkings/near/bylatlon/$lat/$lon');

      if (res.containsKey('error')) {
        throw Exception('Failed to load parkings: ${res['error']}');
      } else if (res.isEmpty) {
        return {};
      }

      choice = res['choice'];
      res.remove("choice");
      return {
        'choice': choice,
        'parkings': res,
      };
    } catch (e) {
      print(e);
      throw Exception('Failed to load parkings: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> _fetchNearParkingsRepository(
      double lat, double lon) async {
    List<Parking> parkingList =
        await _parkingRepository.getNearParkings(latitude, longitude);

    if (parkingList.isEmpty) {
      return {};
    }

    Parking choice = parkingList.reduce((a, b) => b.isEmpty
        ? a
        : a.isEmpty
            ? b
            : a.price! < b.price!
                ? a
                : b);

    parkingList.remove(choice);

    return {
      'choice': choice,
      'parkings': parkingList,
    };
  }

  Future<Map<String, dynamic>> fetchNearParkings(double lat, double lon) async {
    Map<String, dynamic> res;
    try {
      res = await _fetchNearParkingsRepository(lat, lon);
    } catch (e) {
      print(e);
      res = await _fetchNearParkingsAPI(lat, lon);
    }
    if (res.isEmpty) {
      return {'choice': Parking.notFound, 'parkings': List<Parking>.empty()};
    }
    return res;
  }

  TextEditingController dateInput = TextEditingController();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    rootBundle.loadString('assets/maps/map_style.txt').then((string) {
      mapController.setMapStyle(string);
    });

    CameraPosition cameraPosition =
        CameraPosition(target: LatLng(latitude, longitude), zoom: 15.0);

    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  void _onListCreated() async {
    Trace fetchNearParkingsTrace =
        FirebasePerformance.instance.newTrace("fetch_near_parkings_duration");
    await fetchNearParkingsTrace.start();

    var fetchResult = await fetchNearParkings(latitude, longitude);

    setState(() {
      choice = fetchResult['choice'];
      parkings = fetchResult['parkings'];
    });

    await fetchNearParkingsTrace.stop();
  }

  @override
  Widget build(BuildContext context) {
    late Marker choosed = Marker(
      markerId: MarkerId("Ups! Looks like you don't have internet connection"),
      position: LatLng(4.0, -74.0),
    );
    List<Marker> markers = [];

    if (choice.isNotEmpty && choice != Parking.notFound) {
      choosed = Marker(
        markerId: MarkerId(choice.name!),
        position:
            LatLng(choice.coordinates!.latitude, choice.coordinates!.longitude),
      );

      for (Parking parking in parkings) {
        markers.add(
          Marker(
            markerId: MarkerId(parking.name!),
            position: LatLng(
                parking.coordinates!.latitude, parking.coordinates!.longitude),
          ),
        );
      }
    }

    return BlocProvider(
      create: (context) => LocationBloc()..add(const LocationStarted()),
      child: Stack(
        children: [
          Container(
              foregroundDecoration: BoxDecoration(
            color: Colors.white,
          )),
          Column(children: [
            SearchBarWText(),
            BlocListener<LocationBloc, LocationState>(
              listener: (context, state) {
                if (state is LocationLoadSuccess) {
                  latitude = state.position.latitude;
                  longitude = state.position.longitude;
                  print("Location updated: $latitude, $longitude");
                }
              },
              child: ListOfParkingLots(
                parkings: parkings,
                choice: choice,
                userLatitude: latitude != 0.0 ? latitude : widget.latitude,
                userLongitude: longitude != 0.0 ? longitude : widget.longitude,
              ),
            ),
            Expanded(
              child: GoogleMap(
                zoomControlsEnabled: false,
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                initialCameraPosition:
                    CameraPosition(target: _center, zoom: 15.5),
                markers: {
                  choosed,
                  for (Marker i in markers) i,
                },
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

class ListOfParkingLots extends StatelessWidget {
  const ListOfParkingLots(
      {super.key,
      required this.choice,
      required this.parkings,
      required this.userLatitude,
      required this.userLongitude});

  final Parking choice;
  final List<Parking> parkings;

  final double userLatitude;
  final double userLongitude;

  @override
  Widget build(BuildContext context) {
    List<TileParkings> t_parking = [];

    for (Parking parking in parkings) {
      t_parking.add(
        TileParkings(
            uid: parking.id,
            name: parking.name!,
            numberSpots: parking.carSpotsAvailable!.toString(),
            price: parking.price!.toString(),
            distance: Haversine.haversine(
                    userLatitude,
                    userLongitude,
                    parking.coordinates!.latitude,
                    parking.coordinates!.longitude)
                .round()
                .toString(),
            colorText: colorB3,
            waitTime: ""),
      );
    }

    return choice.isEmpty
        ? const CircularProgressIndicator()
        : Expanded(
            flex: 2,
            child: Material(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 380.0,
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        choice == Parking.notFound
                            ? const Center(child: Text('No parkings found'))
                            : ChoiceParking(choice: choice),
                        for (TileParkings i in t_parking) i,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}

class ChoiceParking extends StatelessWidget {
  const ChoiceParking({
    super.key,
    required this.choice,
  });

  final Parking choice;

  @override
  Widget build(BuildContext context) {
    List<TabInfo> info = [
      const TabInfo(text: 'ParkEz Choice', colorTab: Colors.green)
    ];
    TileParkings choosed = TileParkings(
        uid: "0",
        name: "Ups! Looks like you don't have internet connection",
        numberSpots: "0",
        price: "0",
        distance: "0",
        colorText: colorB3,
        waitTime: "");

    if (choice == Parking.notFound) {
      choosed = TileParkings(
        uid: "0",
        name: "No parkings found",
        numberSpots: "0",
        price: "0",
        distance: "0",
        colorText: colorB3,
        waitTime: "",
      );
    }

    if (choice.isNotEmpty && choice != Parking.notFound) {
      Position userPosition;
      var locationState = BlocProvider.of<LocationBloc>(context).state;
      if (locationState is LocationLoadSuccess) {
        userPosition = locationState.position;
      } else {
        throw Exception('Failed to load user position');
      }

      info.add(const TabInfo(text: 'Price Match', colorTab: Colors.green));
      choosed = TileParkings(
        uid: choice.id,
        name: choice.name!,
        numberSpots: choice.carSpotsAvailable!.toString(),
        price: choice.price!.toString(),
        distance: Haversine.haversine(
                userPosition.latitude,
                userPosition.longitude,
                choice.coordinates!.latitude,
                choice.coordinates!.longitude)
            .round()
            .toString(),
        colorText: colorB3,
        waitTime: "",
      );
      // }
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (TabInfo i in info) i,
            TabInfo(text: 'Top 5 Ranked', colorTab: colorB2),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.green, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: choosed,
          ),
        ),
      ],
    );
  }
}

class TabInfo extends StatelessWidget {
  const TabInfo({
    super.key,
    required this.text,
    required this.colorTab,
  });

  final String text;
  final Color colorTab;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8.0), topLeft: Radius.circular(8.0)),
        color: colorTab,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 2, 5, 0),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.white,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}

class SearchBarWText extends StatelessWidget {
  const SearchBarWText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 0,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Buscar en:',
                      style: TextStyle(
                        fontSize: 15,
                        color: colorB3,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  SearchBar(
                    shape: MaterialStateProperty.all(
                        const ContinuousRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    )),
                    side: MaterialStateProperty.all(BorderSide(color: colorB3)),
                    shadowColor: MaterialStateProperty.all(
                        Colors.white.withOpacity(0.5)),
                    hintText: 'Type keyword',
                    hintStyle: MaterialStateProperty.all(
                        const TextStyle(color: Colors.grey)),
                    leading: Icon(Icons.search, color: colorB3),
                    // other arguments
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

class TileParkings extends StatelessWidget {
  const TileParkings({
    super.key,
    required this.name,
    required this.numberSpots,
    required this.price,
    required this.distance,
    required this.colorText,
    required this.waitTime,
    required this.uid,
  });
  final String uid;
  final String name;
  final String waitTime;
  final String numberSpots;
  final String price;
  final String distance;
  final Color colorText;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ReservationProcessScreen(
                      selectedParking: Parking.fromChambonada(
                          uid, name, waitTime, numberSpots, price, distance),
                      parkingDistance: parseDouble(distance) ?? 0.0,
                    )),
          );
        },
        child: Card(
          color: colorBackground,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: ListTile(
              title: RichText(
                text: TextSpan(
                  // Note: Styles for TextSpans must be explicitly defined.
                  // Child text spans will inherit styles from parent
                  children: <TextSpan>[
                    TextSpan(
                        text: name,
                        style: TextStyle(fontSize: 17.0, color: colorB1)),
                    TextSpan(text: waitTime, style: TextStyle(color: colorY1)),
                  ],
                ),
              ),
              subtitle: RichText(
                text: TextSpan(
                  // Note: Styles for TextSpans must be explicitly defined.
                  // Child text spans will inherit styles from parent
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: numberSpots, style: TextStyle(color: colorText)),
                    TextSpan(
                        text: ' cupos disponibles',
                        style: TextStyle(color: colorText)),
                    TextSpan(
                        text: ' - ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: price, style: TextStyle(color: colorB2)),
                    TextSpan(text: '/min', style: TextStyle(color: colorB2)),
                    TextSpan(
                        text: ' - ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: distance, style: TextStyle(color: colorB1)),
                    TextSpan(text: ' mts', style: TextStyle(color: colorB1)),
                  ],
                ),
              ),
              leading: Icon(
                Icons.local_parking,
                size: 40,
                color: colorB1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
