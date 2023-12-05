import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:qr_flutter/qr_flutter.dart';

import '../../data/local/user_local_database.dart';
import '../../data/models/user.dart';
import '../../logic/calls/apiCall.dart';
import '../theme/theme_constants.dart';
import '../utils/file_reader.dart';
import 'near_parkings.dart';

class ShowParkingList extends StatefulWidget {
  const ShowParkingList(
      {super.key, required this.parkings});


  final List<Map<String, dynamic>>? parkings;

  @override
  State<ShowParkingList> createState() => _ShowParkingList();
}

class _ShowParkingList extends State<ShowParkingList> {


  late List<Map<String, dynamic>>? parkings;
  bool viewing = false;
  String uid_res = "";
  late String last_res_uid = "";
  late String last_res_name = "";
  late String last_res_date = "";

  CounterStorage storage = CounterStorage();
  ApiCall apiCall = ApiCall();
  User userData = User.empty;
  UserLocalDatabaseImpl userLocalDatabaseImpl = UserLocalDatabaseImpl();

  @override
  void initState() {
    super.initState();

    parkings = widget.parkings;
  }

  void _getActiveReservations() {
    // Extract reservations from the data map
    Map<String, dynamic>? reservations = userData.reservations;
    

    // Create a sublist based on the 'status' key
    List<Map<String, dynamic>>? sublist = reservations?.entries
        .where((entry) =>
    entry.value is Map<String, dynamic> &&
        entry.value['status'] == 'Active' ||
        entry.value['status'] == 'Pending')
        .map((entry) {
      Map<String, dynamic> reservation = Map.from(entry.value);
      reservation['uid'] = entry.key; // Add the 'uid' key
      return reservation;
    }).toList();

    setState(() {
      parkings = sublist ?? [];
    });

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
      userData = User(
        id: user.uid,
        email: res['email'],
        name: res['name'],
        picture: res['picture'],
        reservations: res['reservations'],
      );
      //print(userData.reservations);
      userLocalDatabaseImpl.saveUser(userData);
    } else {
      userData = await userLocalDatabaseImpl.getUser();
    }

    _getActiveReservations();
  }

  void uidreservation() {
    Map map = Map();
    storage.readAsMap('last_reservation').then((value) async {
      if (value.toString() == map.toString()) {

      } else {
        var res = await apiCall.fetch('raw/document/parkings/${value['pid']}');
        setState(() {
          last_res_name = res['name'];
          last_res_date = value['entry'];
          last_res_uid = value['uid'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    uidreservation();
    _getUserData();

    Stack settings = Stack();
    if (viewing) {
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
            padding: const EdgeInsets.fromLTRB(30, 200, 30, 0),
            child: SizedBox(
              height: 500.0,
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
                        'Here is your reservation!',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          'With this QR code you can enter the parking lot. Don´t worry if you don´t have internet connection, the QR code will be saved in your phone.'),
                      leading: Icon(
                        Icons.qr_code_sharp,
                        size: 40,
                      ),
                    ),
                    QrImageView(
                      data: 'http://api.parkez.xyz:8082/reservations/confirmation/$uid_res',
                      version: QrVersions.auto,
                      size: 300,
                      gapless: false,
                      embeddedImage: AssetImage('assets/darklogo.png'),
                      embeddedImageStyle: QrEmbeddedImageStyle(
                        size: Size(100, 100),
                      ),
                    ),
                    // Usamos una fila para ordenar los botones del card
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () async {
                              final connectivityResult = await InternetConnectionChecker().hasConnection;
                              if (connectivityResult) {
                                Map<String, dynamic> data = {
                                  'status': 'Canceled',
                                };
                                await apiCall.update('reservations', uid_res, data);
                                setState(() {
                                  viewing = false;
                                  _getUserData();
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                    content: Text("Reservation Cancelled"),
                                    duration: Duration(seconds: 5)
                                    )
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("No Internet Connection"),
                                    duration: Duration(seconds: 5),
                                  ),
                                );
                              }
                            },
                            child: const Text('Cancel Reservation'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                viewing = false;
                                _getUserData();
                              });
                            },
                            child: const Text("Close"),
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

    return Material(
      child: Stack(
          children: [ 
            Scaffold(
          appBar: AppBar(
            title: Text('Reservation List'),
          ),
          body: Container(
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(height: 400,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Text('A quick look to the last reservation you made',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                          ),
                        ),
                        QrImageView(
                          data: 'http://api.parkez.xyz:8082/reservations/confirmation/$last_res_uid',
                          version: QrVersions.auto,
                          size: 300,
                          gapless: false,
                          embeddedImage: AssetImage('assets/darklogo.png'),
                          embeddedImageStyle: QrEmbeddedImageStyle(
                            size: Size(100, 100),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Place:\n $last_res_name',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Text('Date:\n $last_res_date',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
                const SearchBarWText(),
                Expanded(
                  child: ListView.builder(
                    itemCount: parkings?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 1,
                          horizontal: 30,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              viewing = true;
                              uid_res = parkings![index]['uid'];
                              print(uid_res);
                            });
                            //ssuidreservation();
                          },
                          child: Card(
                            elevation: 10,
                            child: ListTile(
                              // Rest of your ListTile content
                              title: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(parkings![index]['parking']['name'].toString()),
                                      Text(parkings?[index]['entry_time']),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: StatusWidget(status: parkings?[index]['status']),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

              ],
            ),
          ),
        ),
        settings,
      ]),
    );
  }
}

class StatusWidget extends StatelessWidget {

  final String status;

  const StatusWidget({super.key,  required this.status});

  Color getStatusColor() {
    if (status == 'Active') {
      return Colors.green;
    } else if (status == 'Pending') {
      return Colors.blue;
    }
    return Colors.black; // Default color if none of the conditions match
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor = getStatusColor();

    return Container(
      child: Text(
        'Status: $status',
        style: TextStyle(
          color: statusColor,
          fontSize: 20.0,
        ),
      ),
    );
  }
}
