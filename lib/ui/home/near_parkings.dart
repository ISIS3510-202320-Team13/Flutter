import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parkez/ui/theme/theme_constants.dart';

class NearParkinsPage extends StatelessWidget {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(4.603492, -74.066089);

  TextEditingController dateInput = TextEditingController();

  NearParkinsPage({super.key});

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    rootBundle.loadString('assets/maps/map_style.txt').then((string) {
      mapController.setMapStyle(string);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  TileParkings(
                      name: "City Parking",
                      numberSpots: "25",
                      price: "90",
                      distance: "110",
                      colorText: colorB3),
                  TileParkings(
                      name: "CityU",
                      numberSpots: "15",
                      price: "110",
                      distance: "300",
                      colorText: colorB3),
                  TileParkings(
                      name: "Tequendama",
                      numberSpots: "23",
                      price: "120",
                      distance: "320",
                      colorText: colorB3),
                  TileParkings(
                      name: "Cinemateca",
                      numberSpots: "0",
                      price: "90",
                      distance: "540",
                      colorText: Colors.red),
                  TileParkings(
                      name: "Aparcar",
                      numberSpots: "1",
                      price: "90",
                      distance: "712",
                      colorText: colorB3),
                  TileParkings(
                      name: "Uniandes SD",
                      numberSpots: "12",
                      price: "110",
                      distance: "930",
                      colorText: colorB3),
                ],
              ),
            ),
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
                    side: MaterialStateProperty.all(
                        BorderSide(color: colorB3)),
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
  });

  final String name;
  final String numberSpots;
  final String price;
  final String distance;
  final Color colorText;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          print('Tile pressed');
        },
        child: Card(
          color: colorBackground,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: ListTile(
              title: Text(
                name,
                style: TextStyle(
                  color: colorB1,
                  decoration: TextDecoration.none,
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
                    TextSpan(text: numberSpots, style: TextStyle(color: colorText)),
                    TextSpan(
                        text: ' cupos disponibles',
                        style: TextStyle(color: colorText)),
                    TextSpan(
                        text: ' - ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: price, style: TextStyle(color: colorB2)),
                    TextSpan(text: '/min', style: TextStyle(color: colorB2)),
                    TextSpan(
                        text: ' - ', style: TextStyle(fontWeight: FontWeight.bold)),
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
