import 'package:flutter/material.dart';

Widget primaryButton(text, textSize, width, height) {
  return Container(
    alignment: Alignment.center,
    width: width,
    height: height,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      color: Colors.white10,
    ),
    child: Text(text,
        style: TextStyle(
            fontSize: textSize,
            fontWeight: FontWeight.bold,
            color: Colors.orangeAccent)),
  );
}

Widget smallButton(text, textSize, height) {
  return Expanded(
    child: Container(
      alignment: Alignment.center,
      height: height,
      child: Text(text,
          style: TextStyle(
            color: Colors.white,
            fontSize: textSize,
          )),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white60),
        color: Colors.white12,
      ),
    ),
  );
}
