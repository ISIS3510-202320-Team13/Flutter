import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:parkez/logic/analitycs/parking_director.dart';
import 'package:parkez/ui/home/home_page.dart';

import '../../data/local/user_local_database.dart';
import '../../data/models/user.dart';
import '../../logic/auth/bloc/authentication_bloc.dart';
import '../../logic/calls/apiCall.dart';
import '../utils/file_reader.dart';

class LoadingUser extends StatelessWidget {
  LoadingUser({super.key});

   ApiCall apiCall = ApiCall();
   UserLocalDatabaseImpl userLocalDatabaseImpl = UserLocalDatabaseImpl();
   User userData = User.empty;


  void _getUserData(AuthenticationBloc authenticationBloc, BuildContext context) async {
    final connectivityResult = await InternetConnectionChecker().hasConnection;

    if (connectivityResult) {
      final user = authenticationBloc.state.user;
      try {
        Map<String, dynamic> res = await apiCall.fetch('users/${user.id}');
        print(res);

      userData = User(
        id: user.id,
        email: res['email'],
        name: res['name'],
        picture: res['picture'],
        reservations: res['reservations'],
        type: res['type'],
      );
      userLocalDatabaseImpl.saveUser(userData);
      print(userData.reservations);
      } catch (e) {
        userData = await userLocalDatabaseImpl.getUser();

      }
    } else {
      userData = await userLocalDatabaseImpl.getUser();
    }
    // Check user type and navigate to the appropriate page
    if (userData.type == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(userData: userData)));
    } else if (userData.type == 0) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ParkingDirector()));
    }
  }



  @override
  Widget build(BuildContext context) {
    context.select((AuthenticationBloc bloc) => _getUserData(bloc, context));
    return const MaterialApp(
      home: Scaffold(
        body: MySpinnerWidget(),
      ),
    );
  }

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

class MySpinnerWidget extends StatelessWidget {
  const MySpinnerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}


