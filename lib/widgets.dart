import 'package:flutter/material.dart';

import 'globals.dart';

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
            color: mainColor)),
  );
}

Widget smallButton(text, textSize, height) {
  return Container(
    alignment: Alignment.center,
    height: height,
    width: height * 2,
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
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: minusFunction,
          child: Container(
              height: textSize * 2,
              width: textSize * 2,
              child: Icon(Icons.arrow_drop_down, color: mainColor, size: textSize * 2)
          ),
        ),
        Text(text,
            style: TextStyle(
                fontSize: textSize,
                fontWeight: FontWeight.bold,
                color: mainColor)),
        InkWell(
          onTap: plusFunction,
          child: Container(
              height: textSize * 2,
              width: textSize * 2,
              child: Icon(Icons.arrow_drop_up, color: mainColor, size: textSize * 2)
          ),
        ),
      ],
    ),
  );
}
