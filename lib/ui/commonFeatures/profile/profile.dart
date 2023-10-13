import 'package:flutter/material.dart';
import 'package:parkez/ui/commonFeatures/activity/activity.dart';
import 'package:parkez/ui/theme/theme_constants.dart';
import 'package:parkez/ui/utils/helper_widgets.dart';
import 'package:parkez/ui/commonFeatures/settings/settings.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme
                .of(context)
                .floatingActionButtonTheme
                .foregroundColor,
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

            CircleAvatar(
              radius: 100,
              backgroundImage: NetworkImage(
                  'https://picsum.photos/id/237/200/300'),
            ),



            Center(
              child: Text(
                "Juan Fernando",
                style: Theme
                    .of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(
                  fontSize: 30,
                ),
              ),
            ),
            verticalSpace(50.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Settings(),
                  ),
                );
              },
              child: const Text('Settings'),
            ),
            verticalSpace(10.0),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Payment'),
            ),
            verticalSpace(10.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Activity(),
                  ),
                );
              },
              child: const Text('Activity'),
            ),
            verticalSpace(10.0),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Help'),
            ),
          ],
        ),
      ),
    );
  }
}

