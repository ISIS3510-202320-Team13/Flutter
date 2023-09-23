import 'package:flutter/material.dart';

import '../theme/theme_constants.dart';
import '../utils/helper_widgets.dart';

class settings extends StatefulWidget {
  const settings({super.key});

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body:
    Scaffold(
    body: Padding(
    padding: screenPadding,
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      ElevatedButton(
        onPressed: () {
        },
        child: const Text('Privacy'),
      ),
      verticalSpace(25.0),
      ElevatedButton(
        onPressed: () {
        },
        child: const Text('Legal'),
      ),
      verticalSpace(25.0),
      ElevatedButton(
        onPressed: () {
        },
        child: const Text('About ParkEZ'),
      ),
      verticalSpace(25.0),
      ElevatedButton(
        onPressed: () {
        },
        child: const Text('Sign Out'),
      ),
      ],
    ),
    ),
    ),

      );
      ;
    }
  }

