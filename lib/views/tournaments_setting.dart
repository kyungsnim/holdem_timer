import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holdem_timer/models/default_tournament.dart';

import '../widgets.dart';

class TournamentsSetting extends StatefulWidget {
  @override
  _TournamentsSettingState createState() => _TournamentsSettingState();
}

class _TournamentsSettingState extends State<TournamentsSetting> {
  List<DefaultTournament> tournamentList = List.filled(31, DefaultTournament());
  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    titleController.text = 'Default Tourn...';

    super.initState();
    for (var i = 1; i <= 30; i++) {
      var level = i;
      var sb = level * 100;
      var bb = level * 200;
      var ante = level * 200;
      var runningTime = 8;
      var breakTime = 0;

      if (i % 5 == 0) {
        breakTime = 5;
      } else if (i == 30) {
        breakTime = 10;
      }
      tournamentList[i] = DefaultTournament(
        level: level,
        sb: sb,
        bb: bb,
        ante: ante,
        runningTime: runningTime,
        breakTime: breakTime,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var titleTextSize = MediaQuery.of(context).size.width * 0.06;
    var mediumTextSize = MediaQuery.of(context).size.width * 0.035;
    var smallTextSize = MediaQuery.of(context).size.width * 0.02;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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

  saveData() async {
    var tournamentId = titleController.text;

    for (int i = 1; i <= 30; i++) {
      Map<String, dynamic> tournamentLevelMap = {
        "level": tournamentList[i].level!,
        "sb": tournamentList[i].sb!,
        "bb": tournamentList[i].bb!,
        "ante": tournamentList[i].ante!,
        "runningTime": tournamentList[i].runningTime!,
        "breakTime": tournamentList[i].breakTime!,
        "createdDt": DateTime.now()
      };

      await FirebaseFirestore.instance
          .collection("Tournaments")
          .doc(tournamentId)
          .collection("Levels")
          .add(tournamentLevelMap)
          .catchError((e) {
        print(e.toString());
      });
    }
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
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusColor: Colors.orangeAccent
                  ),
                  controller: titleController,
                  style: TextStyle(fontSize: smallTextSize, color: Colors.white),
                ),
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
              decoration: BoxDecoration(),
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
            ListView.builder(
              shrinkWrap: true,
              itemCount: tournamentList.length - 1,
              itemBuilder: (BuildContext context, int index) {
                if(index == 0) return Container();
                return Container(
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
                          headerText((index).toString(), smallTextSize),
                          headerText(tournamentList[index].sb.toString(),
                              smallTextSize),
                          headerText(tournamentList[index].bb.toString(),
                              smallTextSize),
                          headerText(tournamentList[index].ante.toString(),
                              smallTextSize),
                          headerText(
                              tournamentList[index].runningTime.toString(),
                              smallTextSize),
                          headerText(tournamentList[index].breakTime.toString(),
                              smallTextSize),
                        ]),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  leftBottomButtons(context) {
    var titleTextSize = MediaQuery.of(context).size.width * 0.06;
    var mediumTextSize = MediaQuery.of(context).size.width * 0.035;
    var smallTextSize = MediaQuery.of(context).size.width * 0.02;
    return Container(
      width: MediaQuery.of(context).size.width * 0.49,
      height: MediaQuery.of(context).size.height * 0.2,
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
            onTap: () {
              saveData();
              Get.back();
            },
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
      height: MediaQuery.of(context).size.height * 0.2,
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
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
