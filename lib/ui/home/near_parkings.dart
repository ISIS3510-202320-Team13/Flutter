import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:parkez/ui/utils/file_reader.dart';
import 'package:http/http.dart' as http;
import 'package:parkez/ui/theme/theme_constants.dart';


class NearParkinsPage extends StatefulWidget {
  const NearParkinsPage(
      {super.key, required this.latitude, required this.longitude});

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

class _NearParkinsPageState extends State<NearParkinsPage> {
  double latitude = 0.0;
  double longitude = 0.0;

  late Map choice = Map();
  late Map parkings = Map();

  @override
  void initState() {
    super.initState();

    latitude = widget.latitude;
    longitude = widget.longitude;
    _onListCreated();
    // Now you can use the latitude and longitude values as needed.
    print("Latitude: $latitude, Longitude: $longitude");
  }

  late GoogleMapController mapController;

  late final LatLng _center = LatLng(latitude, longitude);

  Future<http.Response> fetchNearParkings(double lat, double lon) {
    print('http://parkez.xyz:8082/parkings/near/bylatlon/$lat/$lon');
    return http.get(
        Uri.parse('http://parkez.xyz:8082/parkings/near/bylatlon/$lat/$lon'),
        headers: {"X-API-Key": "my_api_key"});
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

  void _onListCreated() {
    fetchNearParkings(latitude, longitude).then((dir) async {
      var res = jsonDecode(dir.body);
      setState(() {
        choice = res['choice'];
        res.remove("choice");
        parkings = res;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    late Marker choosed = Marker(
      markerId: MarkerId("Ups! No tienes conexion a internet"),
      position: LatLng(4.0, -74.0),
    );
    List<Marker> markers = [];

    if (choice["name"] != null) {
      choosed = Marker(
        markerId: MarkerId(choice["name"]),
        position: LatLng(choice["coordinates"]["latitude"],
            choice["coordinates"]["longitude"]),
      );

      for (String key in parkings.keys) {
        var parking = parkings[key];
        markers.add(
          Marker(
            markerId: MarkerId(parking["name"]),
            position: LatLng(parking["coordinates"]["latitude"],
                parking["coordinates"]["longitude"]),
          ),
        );
      }
    }

    return Stack(
      children: [
        Container(
            foregroundDecoration: BoxDecoration(
          color: Colors.white,
        )),
        Column(children: [
          SearchBarWText(),
          ListOfParkingLots(parkings: parkings, choice: choice),
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
    );
  }
}

class ListOfParkingLots extends StatelessWidget {
  const ListOfParkingLots({
    super.key,
    required this.choice,
    required this.parkings,
  });

  final Map choice;
  final Map parkings;

  @override
  Widget build(BuildContext context) {

    List<TileParkings> t_parking = [];

    for (String key in parkings.keys) {
      var parking = parkings[key];
      t_parking.add(
          TileParkings(
              uid: key,
              name: parking["name"],
              numberSpots: parking["availabilityCars"].toString(),
              price: parking["price"].toString(),
              distance: parking["distance"].toString(),
              colorText: colorB3,
              waitTime: ""),
      );
    }

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
                  ChoiceParking(choice: choice),
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

  final Map choice;

  @override
  Widget build(BuildContext context) {
    List<TabInfo> info = [
      const TabInfo(text: 'ParkEz Choice', colorTab: Colors.green)
    ];
    TileParkings choosed = TileParkings(
        uid: "0",
        name: "Ups! No tienes conexion a internet",
        numberSpots: "0",
        price: "0",
        distance: "0",
        colorText: colorB3,
        waitTime: "");


    if (choice["price_match"]!=null) {
      if (choice["price_match"]) {
        info.add(const TabInfo(text: 'Price Match', colorTab: Colors.green));
        choosed = TileParkings(
            uid: choice["uid"],
            name: choice["name"],
            numberSpots: choice["availabilityCars"].toString(),
            price: choice["price"].toString(),
            distance: choice["distance"].toString(),
            colorText: colorB3,
            waitTime: "");
      }

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
    required this.waitTime, required this.uid,
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
          print(uid);
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
