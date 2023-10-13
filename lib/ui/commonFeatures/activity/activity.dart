import 'package:flutter/material.dart';
import '../../theme/theme_constants.dart';
import '../../utils/helper_widgets.dart';
import 'package:intl/intl.dart';

import '../profile/stats.dart';

class Activity extends StatelessWidget {
  late Map<String, dynamic>? user;
  Activity(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String,dynamic>> parkingActivity = user?['reservations'].values.toList().cast<Map<String,dynamic>>();
    parkingActivity = parkingActivity.reversed.toList();
    return Scaffold(
      floatingActionButton: FloatingActionButton(

          onPressed: () { Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Stats(),
            ),
          );
            },
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.analytics,
            color: Colors.white,
            size: 35,),
        ),




        appBar: AppBar(

          title: const Text('Activity'),
        ),

        body:
              ListView.builder(
                  itemCount: parkingActivity.length,

                  itemBuilder: (context, index){
                    return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 30),
                        child: Card(
                            elevation: 0,
                          child: ListTile(
                            onTap: () {},
                            title:
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                        Text(parkingActivity[index]['parking']['name'].toString()),
                                        Text(
                                            '${DateFormat('yyyy-MM-ddThh:mm').parse(parkingActivity[index]['entry_time']).toString().substring(0,16)}'
                                        ),
                                  ],
                                ),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('status: ${parkingActivity[index]['status']}'),
                                ),
                              ],
                            ),
                          )
                        )
                    );
                  }
              ),


        );
  }

}
