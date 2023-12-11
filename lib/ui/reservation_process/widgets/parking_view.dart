import 'package:flutter/material.dart';
import 'package:parkez/data/models/parking.dart';
import 'package:parkez/ui/utils/helper_widgets.dart';

class ParkingDetailsView extends StatelessWidget {
  final Parking _parking;
  final double _distance;

  const ParkingDetailsView(
      {super.key, required Parking parking, required double distance})
      : _parking = parking,
        _distance = distance;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Parking Details',
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ),
        const Divider(),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.local_parking),
                    const SizedBox(width: 60.0),
                    Text(
                      'Parking Details',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                itemDefinition('Parking Name', _parking.name!),
                const SizedBox(height: 5.0),
                itemDefinition('Price', "${_parking.price!}/min"),
                const SizedBox(height: 5.0),
                itemDefinition('Distance', "${_distance.round()} mts"),
                const SizedBox(height: 5.0),
                itemDefinition(
                    'Spots Available', "${_parking.carSpotsAvailable!}"),
              ],
            ),
          ),
        )
      ],
    );
  }
}
