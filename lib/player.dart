import 'package:flutter/material.dart';


class MyPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        width: 500,
        height: 100,
        child: Image.asset(
          "lib/images/packman.jpg",


        ),
      ),
    );
  }
}
