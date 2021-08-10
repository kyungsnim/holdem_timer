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
  return Container(
    alignment: Alignment.center,
    height: height,
    width: height * 1.5,
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
  );
}

Widget plusMinusButton(text, textSize, width, height, plusFunction, minusFunction) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      color: Colors.white10,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: plusFunction,
          child: Container(
            height: textSize * 1.3,
              width: textSize * 1.3,
              child: Icon(Icons.add, color: Colors.orangeAccent, size: textSize)
          ),
        ),
        Text(text,
            style: TextStyle(
                fontSize: textSize,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent)),
        InkWell(
          onTap: minusFunction,
          child: Container(
              height: textSize * 1.3,
              width: textSize * 1.3,
              child: Icon(Icons.remove, color: Colors.orangeAccent, size: textSize)
          ),
        ),
      ],
    ),
  );
}
