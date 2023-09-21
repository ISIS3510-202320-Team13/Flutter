import 'dart:ffi';

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

AppBar appBar(BuildContext context, String title, {bool backButton = true}) {
  return AppBar(
    title: Text(title),
    centerTitle: true,
    leading: backButton
        ? IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back,
              color:
                  Theme.of(context).floatingActionButtonTheme.foregroundColor,
            ),
          )
        : null,
  );
}
