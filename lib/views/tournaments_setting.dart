import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holdem_timer/models/default_tournament.dart';

import '../globals.dart';
import '../widgets.dart';
import 'home.dart';

class TournamentsSetting extends StatefulWidget {
  final String title;
  DefaultTournament defaultTournament;

  TournamentsSetting(this.title, this.defaultTournament);
  @override
  _TournamentsSettingState createState() => _TournamentsSettingState();
}

class _TournamentsSettingState extends State<TournamentsSetting> {
  List<DefaultTournament> tournamentList = []; //List.filled(31, DefaultTournament());
  TextEditingController titleController = TextEditingController();
  late DefaultTournament defaultTournament;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }

  @override
  void initState() {
    titleController.text = widget.title;
    defaultTournament = widget.defaultTournament;

    super.initState();
    tournamentList.add(DefaultTournament());
    for (var i = 1; i <= defaultTournament.level!; i++) {
      var level = i;
      var sb = level * defaultTournament.sb!;
      var bb = level * defaultTournament.bb!;
      var ante = level * defaultTournament.ante!;
      var runningTime = defaultTournament.runningTime;
      var breakTime = 0;

      if (i % 5 == 0) {
        breakTime = defaultTournament.breakTime!;
      } else if (i == 30) {
        breakTime = defaultTournament.breakTime!;
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
                    child: rightBox(context)),
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

    for (int i = 1; i < tournamentList.length; i++) {
      Map<String, dynamic> tournamentLevelMap = {
        "level": i,
        "sb": tournamentList[i].sb!,
        "bb": tournamentList[i].bb!,
        "ante": tournamentList[i].ante!,
        "runningTime": tournamentList[i].runningTime!,
        "breakTime": tournamentList[i].breakTime!,
      };

      FirebaseFirestore.instance
          .collection("Tournaments")
          .doc(tournamentId)
          .collection("Levels")
          .add(tournamentLevelMap)
          .then((_) {
        /// 업로드 완료 후 title setting
        FirebaseFirestore.instance
            .collection("Tournaments")
            .doc(tournamentId)
            .set({
          'title': tournamentId,
          'createdDt': DateTime.now()
        }).catchError((e) {
          print(e.toString());
        });
      }).catchError((e) {
        print(e.toString());
      });
    }
  }

  titleText(context) {
    var titleTextSize = MediaQuery.of(context).size.width * 0.06;

    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Tournaments Setting',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: titleTextSize,
                  color: mainColor))
        ],
      ),
    );
  }

  // leftBox(context) {
  //   var titleTextSize = MediaQuery.of(context).size.width * 0.06;
  //   var mediumTextSize = MediaQuery.of(context).size.width * 0.035;
  //   var smallTextSize = MediaQuery.of(context).size.width * 0.02;
  //   return Container(
  //     decoration: BoxDecoration(
  //         color: Colors.white10,
  //         borderRadius: BorderRadius.circular(10),
  //         border: Border.all(color: Colors.white60)),
  //     height: MediaQuery.of(context).size.height * 0.6,
  //     width: MediaQuery.of(context).size.width * 0.49,
  //     child: SingleChildScrollView(
  //         child: Column(
  //       children: [
  //
  //       ],
  //     )),
  //   );
  // }

  rightBox(context) {
    var mediumTextSize = MediaQuery.of(context).size.width * 0.035;
    var smallTextSize = MediaQuery.of(context).size.width * 0.02;
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white60)),
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width * 0.9,
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
                SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: InputBorder.none, focusColor: mainColor),
                    controller: titleController,
                    style:
                        TextStyle(fontSize: smallTextSize, color: Colors.white),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.01),
              ]),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.grey),
              height: MediaQuery.of(context).size.height * 0.07,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        // width: MediaQuery.of(context).size.width * 0.16,
                        child: headerText('Level', smallTextSize),
                      ),
                      Container(
                        // width: MediaQuery.of(context).size.width * 0.16,
                        child: headerText('SB', smallTextSize),
                      ),
                      Container(
                        // width: MediaQuery.of(context).size.width * 0.16,
                        child: headerText('BB', smallTextSize),
                      ),
                      Container(
                        // width: MediaQuery.of(context).size.width * 0.16,
                        child: headerText('Ante', smallTextSize),
                      ),
                      Container(
                        // width: MediaQuery.of(context).size.width * 0.16,
                        child: headerText('Running Time', smallTextSize),
                      ),
                      Container(
                        // width: MediaQuery.of(context).size.width * 0.16,
                        child: headerText('Break Time', smallTextSize),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ]),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: tournamentList.length,
                itemBuilder: (BuildContext context, int index) {
                  // print('index : $index');
                  if (index == 0) return Container();
                  return Dismissible(
                    key: Key(index.toString()),
                    // direction: DismissDirection.startToEnd,
                    // onDismissed: (direction) {
                    //   setState(() => tournamentList.removeAt(index));
                    // },
                    child: InkWell(
                      // onTap: () => setState(() => tournamentList.removeAt(index)),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: Colors.white10,
                        )),
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.15,
                                    child: Row(children: [
                                      headerText(
                                          (index).toString(), smallTextSize),
                                    ])),
                                /// SB
                                // plusMinusContainer(context, tournamentList[index].sb, smallTextSize, minusClickFunction(index), plusClickFunction(index)),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.13,
                                  child: Row(
                                    children: [
                                      // InkWell(
                                      //   onTap: () {
                                      //     setState(() {
                                      //       if(tournamentList[index]
                                      //           .sb! > 0) {
                                      //         tournamentList[index]
                                      //             .sb =
                                      //             tournamentList[index].sb! - 100;
                                      //       }
                                      //     });
                                      //   },
                                      //   child: Container(
                                      //     child: Padding(
                                      //       padding: const EdgeInsets.all(8.0),
                                      //       child: Icon(
                                      //         Icons.remove,
                                      //         color: Colors.white,
                                      //         size: smallTextSize,
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      headerText(
                                          tournamentList[index].sb.toString(),
                                          smallTextSize),
                                      InkWell(
                                        onTap: () {
                                          setState(() => tournamentList[index]
                                                  .sb =
                                              tournamentList[index].sb! + 100);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: smallTextSize,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.03),

                                /// BB
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.13,
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            if(tournamentList[index]
                                                .bb! > 0) {
                                              tournamentList[index]
                                                  .bb =
                                                  tournamentList[index].bb! - 100;
                                            }
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                            size: smallTextSize,
                                          ),
                                        ),
                                      ),
                                      headerText(
                                          tournamentList[index].bb.toString(),
                                          smallTextSize),
                                      InkWell(
                                        onTap: () {
                                          setState(() => tournamentList[index]
                                                  .bb =
                                              tournamentList[index].bb! + 100);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: smallTextSize,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.03,
                                ),

                                /// Ante
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.13,
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            if(tournamentList[index]
                                                .ante! > 0) {
                                              tournamentList[index]
                                                  .ante =
                                                  tournamentList[index].ante! - 100;
                                            }
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                            size: smallTextSize,
                                          ),
                                        ),
                                      ),
                                      headerText(
                                          tournamentList[index].ante.toString(),
                                          smallTextSize),
                                      InkWell(
                                        onTap: () {
                                          setState(() => tournamentList[index]
                                                  .ante =
                                              tournamentList[index].ante! + 100);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: smallTextSize,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.03,
                                ),

                                /// running time
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.13,
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (tournamentList[index].runningTime! >
                                              0) {
                                            setState(() => tournamentList[index]
                                                    .runningTime =
                                                tournamentList[index]
                                                        .runningTime! -
                                                    1);
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                            size: smallTextSize,
                                          ),
                                        ),
                                      ),
                                      headerText(
                                          tournamentList[index]
                                              .runningTime
                                              .toString(),
                                          smallTextSize),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            tournamentList[index].runningTime =
                                                tournamentList[index]
                                                        .runningTime! +
                                                    1;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: smallTextSize,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.03,
                                ),

                                /// break time
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.13,
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (tournamentList[index].breakTime! >
                                                0) {
                                              tournamentList[index].breakTime =
                                                  tournamentList[index]
                                                          .breakTime! -
                                                      1;
                                            }
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                            size: smallTextSize,
                                          ),
                                        ),
                                      ),
                                      headerText(
                                          tournamentList[index]
                                              .breakTime
                                              .toString(),
                                          smallTextSize),
                                      InkWell(
                                        onTap: () {
                                          setState(() => tournamentList[index]
                                                  .breakTime =
                                              tournamentList[index].breakTime! +
                                                  1);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: smallTextSize,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      DefaultTournament removeData = tournamentList.removeAt(index);
                                      print('removeData.level : ${removeData.level}');
                                      print('removeData.sb : ${removeData.sb}');
                                      print('removeData.bb : ${removeData.bb}');
                                      print('removeData.ante : ${removeData.ante}');
                                      print('removeData.runningTime : ${removeData.runningTime}');
                                      print('removeData.breakTime : ${removeData.breakTime}');
                                    });
                                  },
                                  child: Container(
                                      width:
                                      MediaQuery.of(context).size.width * 0.05,
                                      child: Icon(Icons.delete, color: Colors.redAccent.withOpacity(0.6), size: MediaQuery.of(context).size.width * 0.03,)),
                                ),
                              ]),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  leftBottomButtons(context) {
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
              MediaQuery.of(context).size.width * 0.24,
              MediaQuery.of(context).size.height * 0.1,
            ),
          ),
          // InkWell(
          //   onTap: () => Get.back(),
          //   child: primaryButton(
          //     'START',
          //     smallTextSize,
          //     MediaQuery.of(context).size.width * 0.16,
          //     MediaQuery.of(context).size.height * 0.1,
          //   ),
          // ),
          InkWell(
            onTap: () {
              saveData();
              // Get.offAll(() => Home());
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Home()));
            },
            child: primaryButton(
              'SAVE',
              smallTextSize,
              MediaQuery.of(context).size.width * 0.24,
              MediaQuery.of(context).size.height * 0.1,
            ),
          ),
        ],
      ),
    );
  }

  rightBottomButtons(context) {
    var mediumTextSize = MediaQuery.of(context).size.width * 0.035;
    return Container(
      width: MediaQuery.of(context).size.width * 0.49,
      height: MediaQuery.of(context).size.height * 0.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => addLevel(tournamentList.length),
            child: primaryButton(
              '+',
              mediumTextSize,
              MediaQuery.of(context).size.width * 0.48,
              MediaQuery.of(context).size.height * 0.1,
            ),
          ),
        ],
      ),
    );
  }

  addLevel(int length) {
    setState(() {
      tournamentList.add(DefaultTournament(
          level: length,
          sb: tournamentList[length-1].sb! + 100,
          bb: tournamentList[length-1].bb! + 200,
          ante: tournamentList[length-1].ante! + 200,
          runningTime: tournamentList[length-1].runningTime!,
          breakTime: tournamentList[length-1].breakTime!));
    });
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

  minusClickFunction(index) {
    // setState(() {
    tournamentList[index].sb = tournamentList[index].sb! - 100;
    // });
  }

  plusClickFunction(index) {
    // setState(() {
    tournamentList[index].sb = tournamentList[index].sb! + 100;
    // });
  }

  plusMinusContainer(context, value, smallTextSize, minusFunc, plusFunc) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.13,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              minusFunc();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.remove,
                color: Colors.white,
                size: smallTextSize,
              ),
            ),
          ),
          headerText(value.toString(), smallTextSize),
          InkWell(
            onTap: () {
              plusFunc();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: smallTextSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
