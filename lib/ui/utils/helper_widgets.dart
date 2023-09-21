import 'package:flutter/material.dart';

Widget verticalSpace(double height) {
  return SizedBox(
    height: height,
  );
}

Widget horizontalSpace(double width) {
  return SizedBox(
    width: width,
  );
}

AppBar appBar(BuildContext context, String title) {
  return AppBar(
    title: Text(title),
    centerTitle: true,
    leading: IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: Icon(
        Icons.arrow_back,
        color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
      ),
    ),
  );
}
