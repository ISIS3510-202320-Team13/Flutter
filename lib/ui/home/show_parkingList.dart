import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../theme/theme_constants.dart';
import 'near_parkings.dart';

class ShowParkingList extends StatelessWidget {


  ShowParkingList({required this.parkings, Key? key}) : super(key: key);
  late List<Map<String, dynamic>>? parkings;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parking List'),
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
                    child: Card(
                      elevation: 10,
                      child: ListTile(
                        onTap: () {},
                        title: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(parkings![index]['parking']['name'].toString()),
                                Text(
                                           parkings?[index]['entry_time']
                                        ),

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
                  );
                },
              ),
            ),
          ],
        ),
      ),
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
