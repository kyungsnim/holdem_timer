import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets.dart';

class TournamentsSetting extends StatefulWidget {
  @override
  _TournamentsSettingState createState() => _TournamentsSettingState();
}

class _TournamentsSettingState extends State<TournamentsSetting> {
  @override
  Widget build(BuildContext context) {
    var titleTextSize = MediaQuery.of(context).size.width * 0.06;
    var mediumTextSize = MediaQuery.of(context).size.width * 0.035;
    var smallTextSize = MediaQuery.of(context).size.width * 0.02;
    return Scaffold(
        body: Container(
            color: Colors.black,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// title
                titleText(context),
                Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Column(children: [
                      Row(
                        children: [
                          leftBox(context),
                          Spacer(),
                          rightBox(context),
                        ],
                      ),
                    ])),
                Container(
                    // height: MediaQuery.of(context).size.height * 0.25,
                    child: Row(
                  children: [
                    leftBottomButtons(context),
                    Spacer(),
                    rightBottomButtons(context),
                  ],
                ))
              ],
            )));
  }

  titleText(context) {
    var titleTextSize = MediaQuery.of(context).size.width * 0.06;
    var mediumTextSize = MediaQuery.of(context).size.width * 0.035;
    var smallTextSize = MediaQuery.of(context).size.width * 0.02;

    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Tournaments Setting',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: titleTextSize,
                  color: Colors.orange))
        ],
      ),
    );
  }

  leftBox(context) {
    var titleTextSize = MediaQuery.of(context).size.width * 0.06;
    var mediumTextSize = MediaQuery.of(context).size.width * 0.035;
    var smallTextSize = MediaQuery.of(context).size.width * 0.02;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white60)),
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width * 0.49,
      child: SingleChildScrollView(
          child: Column(
        children: [
          /// title 부분
          Container(
            decoration: BoxDecoration(
                border: Border.all(
              color: Colors.white10,
            )),
            height: MediaQuery.of(context).size.height * 0.2,
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.all(25),
                child: Container(
                  child: Text('Title',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: mediumTextSize,
                      )),
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              smallButton(
                'DEFAULT TOURN.',
                smallTextSize,
                MediaQuery.of(context).size.height * 0.08,
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.01),
            ]),
          ),

          /// Cost, Chips Header
          Container(
            alignment: Alignment.bottomCenter,
            height: MediaQuery.of(context).size.height * 0.2,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Container(
                        child: Text('            ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: mediumTextSize,
                            )),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Container(
                        child: Text('Cost',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: mediumTextSize,
                            )),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Container(
                        child: Text('Chips',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: mediumTextSize,
                            )),
                      ),
                    ),
                  ),
                ]),
          ),

          /// Buy-In 부분
          Container(
            alignment: Alignment.topCenter,
            height: MediaQuery.of(context).size.height * 0.2,
            child: Row(children: [
              Padding(
                padding: const EdgeInsets.all(25),
                child: Container(
                  child: Text('Buy-In',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: mediumTextSize,
                      )),
                ),
              ),
              Spacer(),

              /// minus button
              Container(
                width: MediaQuery.of(context).size.width * 0.04,
                height: MediaQuery.of(context).size.width * 0.04,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white10,
                ),
                child: Icon(
                  Icons.exposure_minus_1,
                  color: Colors.white,
                  size: mediumTextSize,
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.01),

              /// cost
              Text('1',
                  style:
                      TextStyle(fontSize: mediumTextSize, color: Colors.white)),
              SizedBox(width: MediaQuery.of(context).size.width * 0.01),

              /// plus button
              Container(
                width: MediaQuery.of(context).size.width * 0.04,
                height: MediaQuery.of(context).size.width * 0.04,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white10,
                ),
                child: Icon(
                  Icons.plus_one,
                  color: Colors.white,
                  size: mediumTextSize,
                ),
              ),
              Spacer(),

              /// chips
              Text(
                '2000',
                style: TextStyle(fontSize: mediumTextSize, color: Colors.white),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.01),
            ]),
          ),
        ],
      )),
    );
  }

  rightBox(context) {
    var titleTextSize = MediaQuery.of(context).size.width * 0.06;
    var mediumTextSize = MediaQuery.of(context).size.width * 0.035;
    var smallTextSize = MediaQuery.of(context).size.width * 0.02;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white60)),
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width * 0.49,
      child: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(
              color: Colors.white10,
            )),
            height: MediaQuery.of(context).size.height * 0.1,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    headerText('Level', smallTextSize),
                    headerText('SB', smallTextSize),
                    headerText('BB', smallTextSize),
                    headerText('Ante', smallTextSize),
                    headerText('Time', smallTextSize),
                    headerText('Break', smallTextSize),
                  ]),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white10,
                )),
            height: MediaQuery.of(context).size.height * 0.1,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    headerText('1', smallTextSize),
                    headerText('100', smallTextSize),
                    headerText('200', smallTextSize),
                    headerText('200', smallTextSize),
                    headerText('8', smallTextSize),
                    headerText('0', smallTextSize),
                  ]),
            ),
          )
        ],
      )),
    );
  }

  leftBottomButtons(context) {
    var titleTextSize = MediaQuery.of(context).size.width * 0.06;
    var mediumTextSize = MediaQuery.of(context).size.width * 0.035;
    var smallTextSize = MediaQuery.of(context).size.width * 0.02;
    return Container(
      width: MediaQuery.of(context).size.width * 0.49,
      height: MediaQuery.of(context).size.height * 0.25,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Get.back(),
            child: primaryButton(
              'BACK',
              mediumTextSize,
              MediaQuery.of(context).size.width * 0.16,
              MediaQuery.of(context).size.height * 0.2,
            ),
          ),
          InkWell(
            onTap: () => Get.back(),
            child: primaryButton(
              'START',
              mediumTextSize,
              MediaQuery.of(context).size.width * 0.16,
              MediaQuery.of(context).size.height * 0.2,
            ),
          ),
          InkWell(
            onTap: () => Get.back(),
            child: primaryButton(
              'SAVE',
              mediumTextSize,
              MediaQuery.of(context).size.width * 0.16,
              MediaQuery.of(context).size.height * 0.2,
            ),
          ),
        ],
      ),
    );
  }

  rightBottomButtons(context) {
    var titleTextSize = MediaQuery.of(context).size.width * 0.06;
    var mediumTextSize = MediaQuery.of(context).size.width * 0.035;
    var smallTextSize = MediaQuery.of(context).size.width * 0.02;
    return Container(
      width: MediaQuery.of(context).size.width * 0.49,
      height: MediaQuery.of(context).size.height * 0.25,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Get.back(),
            child: primaryButton(
              '-',
              mediumTextSize,
              MediaQuery.of(context).size.width * 0.24,
              MediaQuery.of(context).size.height * 0.2,
            ),
          ),
          InkWell(
            onTap: () => Get.back(),
            child: primaryButton(
              '+',
              mediumTextSize,
              MediaQuery.of(context).size.width * 0.24,
              MediaQuery.of(context).size.height * 0.2,
            ),
          ),
        ],
      ),
    );
  }

  headerText(text, textSize) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: Text(text,
            style: TextStyle(
              color: Colors.white,
              fontSize: textSize,
              fontWeight: FontWeight.bold
            )),
      ),
    );
  }
}
