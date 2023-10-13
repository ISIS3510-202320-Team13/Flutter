import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:parkez/ui/home/near_parkings.dart';
import 'package:parkez/ui/client/reservation_process/reservation_process_screen.dart';
import 'package:parkez/ui/theme/theme_constants.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  HomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  String fullAdress = "Cargando...";

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState  extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    _onHomeCreated();
  }

  late GoogleMapController mapController;
  String fullAdress = "Cargando...";

  LatLng _center = const LatLng(4.602796, -74.065841);

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value){
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR$error");
    });
    return await Geolocator.getCurrentPosition();
  }

  Future<http.Response> fetchDir(double lat,double lon) {
    print('http://3.211.168.157:8000/address/bylatlon/$lat/$lat');
    return http.get(Uri.parse('http://3.211.168.157:8000/address/bylatlon/$lat/$lon'));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    rootBundle.loadString('assets/maps/map_style.txt').then((string) {
      mapController.setMapStyle(string);

      getUserCurrentLocation().then((value) async {
        CameraPosition cameraPosition = CameraPosition(
          target: LatLng(value.latitude, value.longitude),
            zoom: 18.0, tilt: 70
        );

        controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      });
    });
  }

void _onHomeCreated() {
  getUserCurrentLocation().then((value) async {
    fetchDir(value.latitude, value.longitude).then((dir) async {
      var res = jsonDecode(dir.body)["loc"];

      setState(() {
        fullAdress = '${res["road"]}, ${res["house_number"]}, ${res["city"]}';
      });
      print(fullAdress);
    });
  });

  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: GoogleMap(
            zoomControlsEnabled: false,
            onMapCreated: _onMapCreated,
            mapType: MapType.normal,
            myLocationEnabled: true,
            compassEnabled: true,
            initialCameraPosition:
                CameraPosition(target: _center, zoom: 18.0, tilt: 70),
          ),
        ),
        fastActionMenu(colorB1: colorB1, colorB3: colorB3, colorY1: colorY1),
        ubicationCard(fullAdress: fullAdress, colorB1: colorB1, colorB2: colorB2),
      ],
    );
  }
}

class ubicationCard extends StatelessWidget {
  ubicationCard({
    super.key,
    required this.colorB1,
    required this.colorB2,
    required this.fullAdress,
  });

  final Color colorB1;
  final Color colorB2;
  late String fullAdress;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
        child: Material(
          child: InkResponse(
            radius: 350.0,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NearParkinsPage()),
              );
            },
            child: SizedBox(
              width: 350.0,
              height: 100.0,
              // make this container a button
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textFastActions(
                            texto: fullAdress,
                            colorB1: colorB1,
                            tamanioFuente: 15),
                        textFastActions(
                            texto: "25 puestos disponibles",
                            colorB1: colorB2,
                            tamanioFuente: 12),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 5, 0),
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Image.asset('assets/cuadrito.png', scale: 1.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class fastActionMenu extends StatelessWidget {
  const fastActionMenu({
    super.key,
    required this.colorB1,
    required this.colorB3,
    required this.colorY1,
  });

  final Color colorB1;
  final Color colorB3;
  final Color colorY1;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
        child: SizedBox(
          width: 350.0,
          height: 200.0,
          child: Column(
            children: [
              Text(
                'Buscar en:',
                style: TextStyle(
                  fontSize: 15,
                  color: colorB1,
                  decoration: TextDecoration.none,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      iconButon(
                          colorB1: colorB1,
                          buscar: Icons.search,
                          colorB3: colorB3,
                          colorY1: colorY1),
                      textFastActions(
                          texto: "Buscar", colorB1: colorB1, tamanioFuente: 12),
                    ],
                  ),
                  Column(
                    children: [
                      iconButon(
                          colorB1: colorB1,
                          buscar: Icons.work,
                          colorB3: colorB3,
                          colorY1: colorY1),
                      textFastActions(
                          texto: "Trabajo",
                          colorB1: colorB1,
                          tamanioFuente: 12),
                    ],
                  ),
                  Column(
                    children: [
                      iconButon(
                          colorB1: colorB1,
                          buscar: Icons.star,
                          colorB3: colorB3,
                          colorY1: colorY1),
                      textFastActions(
                          texto: "Favoritos",
                          colorB1: colorB1,
                          tamanioFuente: 12),
                    ],
                  ),
                  Column(
                    children: [
                      iconButon(
                          colorB1: colorB1,
                          buscar: Icons.people,
                          colorB3: colorB3,
                          colorY1: colorY1),
                      textFastActions(
                          texto: "Recomendados",
                          colorB1: colorB1,
                          tamanioFuente: 12),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class textFastActions extends StatelessWidget {
  const textFastActions({
    super.key,
    required this.texto,
    required this.colorB1,
    required this.tamanioFuente,
  });

  final String texto;
  final Color colorB1;
  final double tamanioFuente;

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: TextStyle(
        fontSize: tamanioFuente,
        color: colorB1,
        decoration: TextDecoration.none,
      ),
    );
  }
}

class iconButon extends StatelessWidget {
  const iconButon({
    super.key,
    required this.colorB1,
    required this.buscar,
    required this.colorB3,
    required this.colorY1,
  });

  final Color colorB1;
  final IconData buscar;
  final Color colorB3;
  final Color colorY1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 2, color: colorB1),
            borderRadius: BorderRadius.circular(100),
          ),
          child: ClipOval(
            child: Material(
              color: Colors.white, // Button color
              child: InkWell(
                splashColor: colorB3, // Splash color
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ReservationProcessScreen(),
                    ),
                  );
                },
                child: SizedBox(
                    width: 56,
                    height: 56,
                    child: Icon(
                      buscar,
                      color: colorB1,
                    )),
              ),
            ),
          )),
    );
  }
}
