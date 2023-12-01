import 'dart:convert';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:parkez/data/local/user_local_database.dart';
import 'package:parkez/data/models/user.dart';
import 'package:parkez/data/repositories/user_repository.dart';

import 'package:parkez/logic/auth/bloc/authentication_bloc.dart';
import 'package:parkez/logic/geolocation/bloc/location_bloc.dart';
import 'package:parkez/ui/home/near_parkings.dart';
import 'package:parkez/ui/home/show_parkingList.dart';
import 'package:parkez/ui/utils/file_reader.dart';
import 'package:parkez/ui/theme/theme_constants.dart';

import 'package:http/http.dart' as http;
import 'package:parkez/logic/calls/apiCall.dart';

import 'package:parkez/ui/commonFeatures/profile/profile.dart';
import 'package:connectivity/connectivity.dart';

import '../../data/local/user_local_database.dart';
import '../commonFeatures/activity/activity.dart';
import '../commonFeatures/settings/settings.dart';
import '../utils/helper_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  ApiCall apiCall = ApiCall();
  UserLocalDatabaseImpl userLocalDatabaseImpl = UserLocalDatabaseImpl();
  CounterStorage storage = CounterStorage();
  User userData = User.empty;
  List<Map<String, dynamic>> activeReservations = [];

  @override
  void initState() {
    super.initState();
    _onHomeCreated();
  }

  late GoogleMapController mapController;
  String fullAdress = "Ups! Lost internet connection";

  double latitude = 0.0;
  double longitude = 0.0;

  bool setted = true;

  final LatLng _center = const LatLng(4.602796, -74.065841);
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  final UserRepository _userRepository = UserRepository();

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR$error");
    });
    return await Geolocator.getCurrentPosition();
  }

  Future<http.Response> fetchDir(double lat, double lon) {
    print('http://parkez.xyz:8082/address/bylatlon/$lat/$lat');
    return http.get(
        Uri.parse('http://parkez.xyz:8082/address/bylatlon/$lat/$lon'),
        headers: {"X-API-Key": "my_api_key"});
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    latitudeController.dispose();
    longitudeController.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    rootBundle.loadString('assets/maps/map_style.txt').then((string) {
      mapController.setMapStyle(string);

      getUserCurrentLocation().then((value) async {
        CameraPosition cameraPosition = CameraPosition(
            target: LatLng(value.latitude, value.longitude),
            zoom: 18.0,
            tilt: 70);

        controller
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      });
    });
  }

  void _onHomeCreated() {
    getUserCurrentLocation().then((value) async {
      setState(() {
        latitude = value.latitude;
        longitude = value.longitude;
      });
      fetchDir(latitude, longitude).then((dir) async {
        var res = jsonDecode(dir.body)["loc"];
        print(res);
        setState(() {
          fullAdress = '${res["road"]}, ${res["house_number"]}, ${res["city"]}';
          print(fullAdress);
        });
        print(fullAdress);
      });
    });
  }

  void _resevationHistory() {
    storage.readAsMap('next_reservation').then((value) {
      if (value != null) {
        Map values = {
          "uid": "0bKf5TwHWQjsDuaTUa8A",
          "time": "2023-11-17 08:45 AM",
          "parking": "iWWykPE7NQJqRDde2Ave",
          "enter_code": "FA3J45K"
        };
        storage.writeAsMap('next_reservation', values);
      }
    });
  }

  void _resevationPreferences() {
    Map map = Map();
    storage.readAsMap('work').then((value) {
      if (value.toString() == map.toString()) {
        setState(() {
          setted = false;
        });
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NearParkinsPage(
                  key: null, latitude: 4.602997, longitude: -74.065332)),
        );
      }
    });
  }

  void _saveResevationPreferences(double lat, double lon) {
    String map = '{"longitude": $lat, "latitude": $lon}';
    storage.writeSimpleFile('work', map);
  }

  void _getActiveReservations() {
    // Extract reservations from the data map
    Map<String, dynamic>? reservations = userData.reservations;

    // Create a sublist based on the 'status' key
    List<Map<String, dynamic>>? sublist = reservations?.values
        .whereType<Map<String, dynamic>>() // Filter out non-maps
        .where((reservation) => reservation['status'] == 'Active')
        .toList();

    // Add pending reservations to the sublist
    sublist?.addAll(reservations!.values
        .whereType<Map<String, dynamic>>() // Filter out non-maps
        .where((reservation) => reservation['status'] == 'Pending')
        .toList());
    activeReservations = sublist ?? [];
  }

  void _getUserData() async {
    final connectivityResult = await InternetConnectionChecker().hasConnection;

    if (connectivityResult) {
      final user = firebase_auth.FirebaseAuth.instance.currentUser!;
      Map<String, dynamic> res;
      try {
        res = await apiCall.fetch('users/${user.uid}');
      } catch (e) {
        res = User.empty.toDocument();
      }
      print(res);
      userData = User(
        id: user.uid,
        email: res['email'],
        name: res['name'],
        picture: res['picture'],
        reservations: res['reservations'],
      );
      userLocalDatabaseImpl.saveUser(userData);
      print(userData.reservations);
    } else {
      userData = await userLocalDatabaseImpl.getUser();
    }

    _getActiveReservations();
  }

  @override
  Widget build(BuildContext context) {
    _getUserData();
    Stack settings = Stack();
    if (!setted) {
      settings = Stack(children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/transparent.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
            child: Container(
              color: Colors.black.withOpacity(0.0),
            ),
          ),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 250, 30, 0),
            child: SizedBox(
              height: 390.0,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: <Widget>[
                    // Usamos ListTile para ordenar la información del card como titulo, subtitulo e icono
                    const ListTile(
                      contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      title: Text(
                        'Store your preferences',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          'Here you can save your preferences for the places you frequent to access them more quickly.'),
                      leading: Icon(
                        Icons.save,
                        size: 40,
                      ),
                    ),
                    const Text('Latitude.'),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: TextField(
                        controller: latitudeController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter a search term',
                        ),
                      ),
                    ),
                    const Text('Longitude.'),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                      child: TextField(
                        controller: longitudeController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter a search term',
                        ),
                      ),
                    ),
                    // Usamos una fila para ordenar los botones del card
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                            onPressed: () {
                              double latitudeB;
                              double longitudeB;

                              // Parse latitude and longitude from text fields
                              double? latitudeValue =
                                  double.tryParse(latitudeController.text);
                              double? longitudeValue =
                                  double.tryParse(longitudeController.text);

                              if (latitudeValue != null &&
                                  longitudeValue != null) {
                                // Conversion succeeded, update the variables
                                latitudeB = latitudeValue;
                                longitudeB = longitudeValue;

                                // Now you can use the 'latitude' and 'longitude' variables as doubles
                                _saveResevationPreferences(
                                    latitudeB, longitudeB);

                                setState(() {
                                  setted = true;
                                });
                              } else {
                                // Handle the case where the input couldn't be parsed as a double
                                print(
                                    'Invalid input: latitude and/or longitude');
                              }
                            },
                            child: const Text("Accept"),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                setted = true;
                              });
                            },
                            child: const Text("Cancel"),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ]);
    }

    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Column(children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage('${userData?.picture}'),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        '${userData?.name}',
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ])),
            Column(children: [
              verticalSpace(10.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Settings(),
                    ),
                  );
                },
                child: const Text('Settings'),
              ),
              verticalSpace(10.0),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Payment'),
              ),
              verticalSpace(10.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Activity(user: userData),
                    ),
                  );
                },
                child: const Text('Activity'),
              ),
              verticalSpace(10.0),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Help'),
              ),
            ]),
            Center(
              child: ListTile(
                title: const Row(
                  children: [Text('Log out'), Icon(Icons.exit_to_app)],
                ),
                onTap: () {
                  context
                      .read<AuthenticationBloc>()
                      .add(const AuthenticationSignoutRequested());
                },
              ),
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            onMapCreated: _onMapCreated,
            mapType: MapType.normal,
            myLocationEnabled: true,
            compassEnabled: false,
            initialCameraPosition:
                CameraPosition(target: _center, zoom: 18.0, tilt: 70),
          ),
          fastActionMenu(
              colorB1: colorB1,
              colorB3: colorB3,
              colorY1: colorY1,
              storage: storage,
              resevationPreferences: _resevationPreferences),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              activeReservations.isEmpty
                  ? Container() // Show nothing if the list is empty
                  : activeReservationCard(
                      fullAdress:
                          "Looks like you have \nan ongoing reservation",
                      colorB1: colorB1,
                      colorB2: colorB2,
                      parkingList: activeReservations,
                    ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                child: ubicationCard(
                    fullAdress: fullAdress,
                    colorB1: colorB1,
                    colorB2: colorB2,
                    latitude: latitude,
                    longitude: longitude),
              ),
            ],
          ),
          Positioned(
            left: 10,
            top: 10,
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(const CircleBorder()),
                padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
              ),
              onPressed: () {
                scaffoldKey.currentState?.openDrawer();
              },
              child: const Icon(Icons.menu),
            ),
          ),
          settings,
        ],
      ),
    );
  }
}

class ubicationCard extends StatelessWidget {
  ubicationCard(
      {super.key,
      required this.colorB1,
      required this.colorB2,
      required this.fullAdress,
      required this.latitude,
      required this.longitude});

  final Color colorB1;
  final Color colorB2;
  late String fullAdress;
  late double latitude;
  late double longitude;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Material(
          child: InkResponse(
            radius: 350.0,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NearParkinsPage(
                        key: null, latitude: latitude, longitude: longitude)),
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
                            texto: "25 empty spots",
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

class activeReservationCard extends StatelessWidget {
  activeReservationCard({
    super.key,
    required this.colorB1,
    required this.colorB2,
    required this.fullAdress,
    required this.parkingList,
  });

  final Color colorB1;
  final Color colorB2;
  late String fullAdress;
  late List<Map<String, dynamic>> parkingList;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Material(
          child: InkResponse(
            radius: 350.0,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ShowParkingList(parkings: parkingList)),
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
                            tamanioFuente: 13),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 5, 0),
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.directions_car,
                          size: 40,
                          color: colorY1,
                        ),
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

class reservationCard extends StatelessWidget {
  reservationCard(
      {super.key,
      required this.colorB1,
      required this.colorB2,
      required this.fullAdress,
      required this.latitude,
      required this.longitude});

  final Color colorB1;
  final Color colorB2;
  late String fullAdress;
  late double latitude;
  late double longitude;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Material(
          child: InkResponse(
            radius: 350.0,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NearParkinsPage(
                        key: null, latitude: latitude, longitude: longitude)),
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
                            tamanioFuente: 13),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 0, 5, 0),
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.directions_car,
                          size: 40,
                          color: colorY1,
                        ),
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
    required this.storage,
    required this.resevationPreferences,
  });

  final Color colorB1;
  final Color colorB3;
  final Color colorY1;
  final CounterStorage storage;
  final Function() resevationPreferences;

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
                          colorY1: colorY1,
                          favorite: 'search',
                          storage: storage,
                          resevationPreferences: resevationPreferences),
                      textFastActions(
                          texto: "Search", colorB1: colorB1, tamanioFuente: 12),
                    ],
                  ),
                  Column(
                    children: [
                      iconButon(
                          colorB1: colorB1,
                          buscar: Icons.work,
                          colorB3: colorB3,
                          colorY1: colorY1,
                          favorite: 'work',
                          storage: storage,
                          resevationPreferences: resevationPreferences),
                      textFastActions(
                          texto: "Work", colorB1: colorB1, tamanioFuente: 12),
                    ],
                  ),
                  Column(
                    children: [
                      iconButon(
                          colorB1: colorB1,
                          buscar: Icons.star,
                          colorB3: colorB3,
                          colorY1: colorY1,
                          favorite: 'favorite',
                          storage: storage,
                          resevationPreferences: resevationPreferences),
                      textFastActions(
                          texto: "Favorites",
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
                          colorY1: colorY1,
                          favorite: 'recomended',
                          storage: storage,
                          resevationPreferences: resevationPreferences),
                      textFastActions(
                          texto: "Recomended",
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
    required this.favorite,
    required this.storage,
    required this.resevationPreferences,
  });

  final Function() resevationPreferences;
  final String favorite;
  final Color colorB1;
  final IconData buscar;
  final Color colorB3;
  final Color colorY1;
  final CounterStorage storage;

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
                  resevationPreferences();
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
