import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holdem_timer/models/default_tournament.dart';

import '../widgets.dart';

class TournamentsSetting extends StatefulWidget {
  @override
  _TournamentsSettingState createState() => _TournamentsSettingState();
}

class _TournamentsSettingState extends State<TournamentsSetting> {
  List<DefaultTournament> tournamentList = [];
  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    titleController.text = 'Default Tourn...';

    super.initState();
    for(var i = 1; i <= 30; i++){
      var level = i;
      var sb = level * 100;
      var bb = level * 200;
      var ante = level * 200;
      var runningTime = 8;
      var breakTime = 0;

      if( i % 5 == 0) {
        breakTime = 5;
      } else if(i == 30) {
        breakTime = 10;
      }
      tournamentList.add(DefaultTournament(
        level: level,
        sb: sb,
        bb: bb,
        ante: ante,
        runningTime: runningTime,
        breakTime: breakTime,
      ));
    }
  }
  @override
  Widget build(BuildContext context) {
    var titleTextSize = MediaQuery.of(context).size.width * 0.06;
    var mediumTextSize = MediaQuery.of(context).size.width * 0.035;
    var smallTextSize = MediaQuery.of(context).size.width * 0.02;
    return Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
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
      width: MediaQuery.of(context).size.width * 0.45,
      child: SingleChildScrollView(
          child: Column(
        children: [
          /// title 부분
          Container(
            decoration: BoxDecoration(
                border: Border.all(
              color: Colors.white10,
            )),
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
              // TextFormField(
              //
              // ),
              Text(
                'DEFAULT TOURN.',
                style: TextStyle(fontSize: smallTextSize,
                  color: Colors.white
              ),),
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
              smallTextSize,
              MediaQuery.of(context).size.width * 0.16,
              MediaQuery.of(context).size.height * 0.1,
            ),
          ),
          InkWell(
            onTap: () => Get.back(),
            child: primaryButton(
              'START',
              smallTextSize,
              MediaQuery.of(context).size.width * 0.16,
              MediaQuery.of(context).size.height * 0.1,
            ),
          ),
          InkWell(
            onTap: () => Get.back(),
            child: primaryButton(
              'SAVE',
              smallTextSize,
              MediaQuery.of(context).size.width * 0.16,
              MediaQuery.of(context).size.height * 0.1,
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
              MediaQuery.of(context).size.height * 0.1,
            ),
          ),
          InkWell(
            onTap: () => Get.back(),
            child: primaryButton(
              '+',
              mediumTextSize,
              MediaQuery.of(context).size.width * 0.24,
              MediaQuery.of(context).size.height * 0.1,
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
