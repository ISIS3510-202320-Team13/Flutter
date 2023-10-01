import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:parkez/ui/theme/theme_constants.dart';

class HomePage extends StatelessWidget {
  late GoogleMapController mapController;


  LatLng _center = const LatLng(4.602796, -74.065841);

  HomePage({super.key});

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value){
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR$error");
    });
    return await Geolocator.getCurrentPosition();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    rootBundle.loadString('assets/map_style.txt').then((string) {
      mapController.setMapStyle(string);

      getUserCurrentLocation().then((value) async {
        print(value.latitude.toString() + " " + value.longitude.toString());

        CameraPosition cameraPosition = CameraPosition(
          target: LatLng(value.latitude, value.longitude),
            zoom: 18.0, tilt: 70
        );

        controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

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
        ubicationCard(colorB1: colorB1, colorB2: colorB2),
      ],
    );
  }
}

class ubicationCard extends StatelessWidget {
  const ubicationCard({
    super.key,
    required this.colorB1,
    required this.colorB2,
  });

  final Color colorB1;
  final Color colorB2;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
        child: SizedBox(
          width: 350.0,
          height: 100.0,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
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
                        texto: "Cra. 1 #22-37, Bogotá",
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
                      iconButon(colorB1: colorB1, buscar: Icons.search, colorB3: colorB3, colorY1: colorY1),
                      textFastActions(
                          texto: "Buscar", colorB1: colorB1, tamanioFuente: 12),
                    ],
                  ),
                  Column(
                    children: [
                      iconButon(colorB1: colorB1, buscar: Icons.work, colorB3: colorB3, colorY1: colorY1),
                      textFastActions(
                          texto: "Trabajo",
                          colorB1: colorB1,
                          tamanioFuente: 12),
                    ],
                  ),
                  Column(
                    children: [
                      iconButon(colorB1: colorB1, buscar: Icons.star, colorB3: colorB3, colorY1: colorY1),
                      textFastActions(
                          texto: "Favoritos",
                          colorB1: colorB1,
                          tamanioFuente: 12),
                    ],
                  ),
                  Column(
                    children: [
                      iconButon(colorB1: colorB1, buscar: Icons.people, colorB3: colorB3, colorY1: colorY1),
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
                onTap: () {},
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
