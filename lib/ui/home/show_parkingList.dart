import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
  CounterStorage storage = CounterStorage();

  @override
  void initState() {
    super.initState();

    parkings = widget.parkings;
  }

  @override
  Widget build(BuildContext context) {


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
                      data: 'http://api.parkez.xyz/reservations/confirmation/$uid_res',
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
                          TextButton(
                            onPressed: () {
                              setState(() {
                                viewing = false;
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

    void uidreservation() {
      Map map = Map();
      storage.readAsMap(uid_res).then((value) {
        if (value.toString() == map.toString()) {
          setState(() {
            viewing = false;
          });
        } else {
          setState(() {
            uid_res = value['uid'];
          });
        }
      });
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
                SearchBarWText(),
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
                            });
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
