import 'package:flutter/material.dart';

import '../../theme/theme_constants.dart';
import '../../utils/helper_widgets.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorBackground,
        appBar: AppBar(
          title: const Text('Settings'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),


        body: Padding(
          padding: screenPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () {
                },
                style: Theme.of(context).elevatedButtonTheme.style,
                child: const Text('Privacy'),
              ),
              verticalSpace(25.0),
              ElevatedButton(
                onPressed: () {
                },
                style: Theme.of(context).elevatedButtonTheme.style,
                child: const Text('Legal'),
              ),
              verticalSpace(25.0),
              ElevatedButton(
                onPressed: () {
                },
                style: Theme.of(context).elevatedButtonTheme.style,
                child: const Text('About ParkEZ'),
              ),
              verticalSpace(25.0),
              ElevatedButton(
                onPressed: () {
                },
                style: Theme.of(context).elevatedButtonTheme.style,
                child: const Text('Sign Out'),
              ),
            ],
          ),
        )

    );
    ;
  }
}

