import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'package:parkez/ui/theme/theme_constants.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';


class NearParkinsPage extends StatefulWidget {
  const NearParkinsPage({super.key, required this.latitude, required this.longitude});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final double latitude;
  final double longitude;

  @override
  State<NearParkinsPage> createState() => _NearParkinsPageState();
}

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }
}


class _NearParkinsPageState extends State<NearParkinsPage> {

  @override
  void initState() {
    super.initState();

    double latitude = widget.latitude;
    double longitude = widget.longitude;

    // Now you can use the latitude and longitude values as needed.
    print("Latitude: $latitude, Longitude: $longitude");
  }

  late GoogleMapController mapController;

  double latitude = 0.0;
  double longitude = 0.0;
  late final LatLng _center = LatLng(latitude, longitude);

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value){
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR$error");
    });
    return await Geolocator.getCurrentPosition();
  }

  Future<http.Response> fetchNearParkings(double lat,double lon) {
    print('http://parkez.xyz:8082/parkings/near/bylatlon/$lat/$lon');
    return http.get(Uri.parse('http://parkez.xyz:8082/parkings/near/bylatlon/$lat/$lon'), headers: {"X-API-Key": "my_api_key"});
  }

  TextEditingController dateInput = TextEditingController();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    rootBundle.loadString('assets/maps/map_style.txt').then((string) {
      mapController.setMapStyle(string);
    });

    getUserCurrentLocation().then((value) async {
      CameraPosition cameraPosition = CameraPosition(
          target: LatLng(value.latitude, value.longitude),
          zoom: 15.0
      );

      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    });
  }

  void _onListCreated() {
    getUserCurrentLocation().then((value) async {
      fetchNearParkings(value.latitude, value.longitude).then((dir) async {

        var res = jsonDecode(dir.body);

        for (String i in res.keys) {
          print(res[i]);
        }

      });
    });

  }

  @override
  Widget build(BuildContext context) {
    _onListCreated();
    return Stack(
      children: [
        Container(
            foregroundDecoration: BoxDecoration(
          color: Colors.white,
        )),
        Column(children: [
          SearchBarWText(),
          ListOfParkingLots(),
          Expanded(
            child: GoogleMap(
              zoomControlsEnabled: false,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              initialCameraPosition:
                  CameraPosition(target: _center, zoom: 15.5),
              markers: {
                const Marker(
                  markerId: MarkerId('SD'),
                  position: LatLng(4.604810, -74.065840),
                ),
                const Marker(
                  markerId: MarkerId('CityParking'),
                  position: LatLng(4.604882, -74.065214),
                ),
                const Marker(
                  markerId: MarkerId('CityU'),
                  position: LatLng(4.603608, -74.067100),
                ),
                const Marker(
                  markerId: MarkerId('Tequendama'),
                  position: LatLng(4.604004, -74.065796),
                ),
                const Marker(
                  markerId: MarkerId('Cinemateca'),
                  position: LatLng(4.603686, -74.067227),
                ),
                const Marker(
                  markerId: MarkerId('Aparcar'),
                  position: LatLng(4.601211, -74.068153),
                ),
              },
            ),
          ),
        ]),
      ],
    );
  }
}

class ListOfParkingLots extends StatelessWidget {
  const ListOfParkingLots({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                  const ChoiceParking(),
                  TileParkings(
                      name: "CityU",
                      numberSpots: "15",
                      price: "110",
                      distance: "300",
                      colorText: colorB3,
                      waitTime: ""
                  ),
                  TileParkings(
                      name: "Tequendama",
                      numberSpots: "23",
                      price: "120",
                      distance: "320",
                      colorText: colorB3,
                      waitTime: ""),
                  TileParkings(
                      name: "Cinemateca",
                      numberSpots: "0",
                      price: "90",
                      distance: "540",
                      colorText: Colors.red,
                      waitTime: " - 5 min espera"),
                  TileParkings(
                      name: "Aparcar",
                      numberSpots: "1",
                      price: "90",
                      distance: "712",
                      colorText: colorB3,
                      waitTime: ""),
                  TileParkings(
                      name: "Uniandes SD",
                      numberSpots: "12",
                      price: "110",
                      distance: "930",
                      colorText: colorB3,
                      waitTime: ""),
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
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TabInfo(text: 'ParkEz Choice', colorTab: Colors.green),
            TabInfo(text: 'Price Match', colorTab: Colors.green),
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
            child: TileParkings(
                name: "City Parking",
                numberSpots: "25",
                price: "90",
                distance: "110",
                colorText: colorB3,
                waitTime: ""),
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
  });

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
          print('tapped');
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
                    TextSpan(text: name, style: TextStyle(fontSize: 17.0,color: colorB1)),
                    TextSpan(
                        text: waitTime,
                        style: TextStyle(color: colorY1)),
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
