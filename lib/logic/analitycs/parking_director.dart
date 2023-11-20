import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../calls/apiCall.dart';

class ParkingDirector extends StatefulWidget {
  const ParkingDirector({Key? key}) : super(key: key);

  @override
  _ParkingDirectorState createState() => _ParkingDirectorState();
}

class _ParkingDirectorState extends State<ParkingDirector> {
  late Future<List<charts.Series<_Stats, String>>> seriesListFuture;

  @override
  void initState() {
    super.initState();
    seriesListFuture = _getStats();
  }

  Future<List<charts.Series<_Stats, String>>> _getStats() async {
    var stats = await ApiCall().fetch('stats/all');
    return _createData(stats);
  }

  List<charts.Series<_Stats, String>> _createData(Map<String, dynamic> data) {
    final statsData = data['stats'].asMap().entries.map((entry) {
      return new _Stats(entry.key.toString(), entry.value);
    }).toList();

    return [
      new charts.Series<_Stats, String>(
        id: 'Stats',
        domainFn: (_Stats stats, _) => stats.index,
        measureFn: (_Stats stats, _) => stats.value,
        data: statsData,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<charts.Series<_Stats, String>>>(
      future: seriesListFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return new charts.BarChart(
            snapshot.data!,
            animate: true,
          );
        }
      },
    );
  }
}

class _Stats {
  final String index;
  final int value;

  _Stats(this.index, this.value);
}
