import 'package:flutter/material.dart';
import '../../theme/theme_constants.dart';
import '../../utils/helper_widgets.dart';

class Activity extends StatelessWidget {
  const Activity({super.key});

  static const List<Map<String,Object>> parkingActivity = [
    {'cost': 18000, 'date': '11/10/23', 'spot': 'Tequendama'},
    {'cost': 22000, 'date': '12/10/23', 'spot': 'La Candelaria'},
    {'cost': 16000, 'date': '14/10/23', 'spot': 'Monserrate'},
    {'cost': 20000, 'date': '14/10/23', 'spot': 'Usaquén'},
    {'cost': 25000, 'date': '14/10/23', 'spot': 'Chapinero'},
    {'cost': 19000, 'date': '17/10/23', 'spot': 'Zona T'},
    {'cost': 23000, 'date': '17/10/23', 'spot': 'Parque de la 93'},
    {'cost': 21000, 'date': '18/10/23', 'spot': 'Andino Mall'},
    {'cost': 22000, 'date': '1/11/23', 'spot': 'Tequendama'},
    {'cost': 19000, 'date': '3/11/23', 'spot': 'Tequendama'}
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(

          onPressed: () {  },
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
                                        Text(parkingActivity[index]['spot'].toString()),
                                        Text(parkingActivity[index]['date'].toString())
                                  ],
                                ),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('cost: \$${parkingActivity[index]['cost'].toString().substring(0,2)}\'000')),
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
