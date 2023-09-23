import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:parkez/ui/theme/theme_constants.dart';
import 'package:parkez/ui/utils/helper_widgets.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> with SingleTickerProviderStateMixin {
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
        title: const Text('Profile'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Scaffold(
        body: Padding(
          padding: screenPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 400,
                      height: 220,
                      child: CustomPaint(
                        painter: OpenPainter(),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0, // Adjust this value to control the vertical position of the icon
                    left: 0,
                    right: 0,
                    child: Icon(
                      Icons.account_circle,
                      size: 200,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "Juan Fernando",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: 30,
                  ),
                ),
              ),
              verticalSpace(50.0),
              Align(
                alignment: Alignment.topCenter,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Settings'),
                ),),
              verticalSpace(10.0),
              Align(
                alignment: Alignment.topCenter,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Payment'),
                ),),
              verticalSpace(10.0),
              Align(
                alignment: Alignment.topCenter,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Activity'),
                ),),
              verticalSpace(10.0),
              Align(
                alignment: Alignment.topCenter,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Help'),
                ),),

            ],
          ),
        ),
      ),
    );




  }
}


class OpenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Color(0xffbce0fd)
      ..style = PaintingStyle.fill;

    double centerX = size.width / 2;
    double radius = 100;

    canvas.drawCircle(Offset(centerX, radius), radius, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}