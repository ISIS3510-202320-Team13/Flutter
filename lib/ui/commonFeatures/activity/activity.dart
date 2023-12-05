import 'package:flutter/material.dart';
import 'package:parkez/data/models/user.dart';
import '../../theme/theme_constants.dart';
import '../../utils/helper_widgets.dart';
import 'package:intl/intl.dart';

import 'package:parkez/ui/commonFeatures/profile/stats.dart';

class Activity extends StatelessWidget {
  late User? user;
  Activity({ required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>>? parkingActivity = user?.reservations?.values.toList().cast<Map<String,dynamic>>();
    parkingActivity = parkingActivity?.reversed.toList();
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
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                parkingActivity==null?Container(
                  height: MediaQuery.of(context).size.height/1.5,
                  child: const Center(
                    child: Text('No Activity'),
                  ),
                ):
              Flexible(
                child: ListView.builder(
                    itemCount: parkingActivity?.length,

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
                                          Text(parkingActivity![index]['parking']['name'].toString()),
                                          Text(
                                              parkingActivity?[index]['entry_time']
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
              ),

    ],
            )

    );

  }

}
