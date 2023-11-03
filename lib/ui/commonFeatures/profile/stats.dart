
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parkez/logic/analitycs/totalReservationsAnalytics.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Stats extends StatelessWidget {
  const Stats({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> reservationData = {
      "e7c64ec-97a0-42c8-a14d-66e41ed88249":{
        "cost": "4500",
        "entry_time": "2023-11-17 09:30 AM",
        "exit_time": "2023-11-17 02:30 PM",
        "parking": "DJAA37ImMrLdj3Sg8ULW",
        "status": "Pending",
        "user": "L7chJqeIsSeakEHfOWxgnzuRBU53"
      },
      "f7c64ec-97a0-42c8-a14d-66e41ed88249":{
        "cost": "7500",
        "entry_time": "2023-11-17 10:00 AM",
        "exit_time": "2023-11-17 02:00 PM",
        "parking": "U1FG3F28kmhDVLccaB0W",
        "status": "Completed",
        "user": "dC9mhoVIhpeU1Akdlj523Ygm37X2"
      },
      "g7c64ec-97a0-42c8-a14d-66e41ed88249": {
        "cost": "12000",
        "entry_time": "2023-11-17 01:45 PM",
        "exit_time": "2023-11-17 05:30 PM",
        "parking": "WF7KsIFbOr8UYX9OuDKT",
        "status": "Pending",
        "user": "L7chJqeIsSeakEHfOWxgnzuRBU53"
      },
      "h7c64ec-97a0-42c8-a14d-66e41ed88249":{
        "cost": "16000",
        "entry_time": "2023-11-17 08:30 AM",
        "exit_time": "2023-11-17 11:15 AM",
        "parking": "g7Z1wR8vx29E4qMhYGOS",
        "status": "Completed",
        "user": "dC9mhoVIhpeU1Akdlj523Ygm37X2"
      },
      "i7c64ec-97a0-42c8-a14d-66e41ed88249":{
        "cost": "21000",
        "entry_time": "2023-11-17 03:00 PM",
        "exit_time": "2023-11-17 06:30 PM",
        "parking": "gjpOJCfa5GzCpdQKYqNc",
        "status": "Pending",
        "user": "L7chJqeIsSeakEHfOWxgnzuRBU53"
      }
    };

    void getData() async {
      Uri uri = Uri.parse('http://3.211.168.157:8000/reservations/all');
      Response response = await get(uri);
      reservationData = jsonDecode(response.body);
    }

    //getData();
    print( reservationData.values.toList());
    TotalReservationsAnalytics analitycs = TotalReservationsAnalytics(
        reservationData.values.toList());
      return Scaffold(
        appBar: AppBar(
          title: const Text('Stats'),
        ),
        body: Center(
          child: Text('Most occupied hour: ${analitycs.getMostOccupiedHour()} \n'+
              'Least occupied hour: ${analitycs.getLeastOccupiedHour()} \n'+
              'Average cost: ${analitycs.getAverageCost()} \n'+
              'Average duration: ${analitycs.getAverageDuration()} \n'+
              'Most expensive reservation: ${analitycs.getMostExpensiveReservation()} \n'+
              'Cheapest reservation: ${analitycs.getCheapestReservation()} \n',
              //'Most popular parking: ${analitycs.getMostPopularParking()} \n',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
        ),
      );

}
}
