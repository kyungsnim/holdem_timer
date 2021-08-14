import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holdem_timer/models/default_tournament.dart';
import 'package:intl/intl.dart';

import '../globals.dart';
import '../widgets.dart';
import 'home.dart';

class TournamentsSetting extends StatefulWidget {
  String tournamentId;
  final String purpose;

  TournamentsSetting({required this.tournamentId, required this.purpose});

  @override
  _TournamentsSettingState createState() => _TournamentsSettingState();
}

class _TournamentsSettingState extends State<TournamentsSetting> {
  List<DefaultTournament> tournamentList =
      []; //List.filled(31, DefaultTournament());
  TextEditingController titleController = TextEditingController();
  late DefaultTournament defaultTournament;
  List<TextEditingController> _sbControllers = [];
  List<TextEditingController> _bbControllers = [];
  List<TextEditingController> _anteControllers = [];
  var title = '';

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    for (int i = 0; i < _sbControllers.length; i++) {
      _sbControllers[i].dispose();
      _bbControllers[i].dispose();
      _anteControllers[i].dispose();
    }
  }

  @override
  void initState() {
    // titleController.text = widget.title;
    // defaultTournament = widget.defaultTournament;
    super.initState();

    /// 기존 토너먼트 수정하는 경우
    if (widget.purpose == 'edit') {
      FirebaseFirestore.instance
          .collection('Tournaments')
          .doc(widget.tournamentId)
          .get()
          .then((value) {
        var doc = value.data();
        setState(() {
          titleController.text = doc!['title'];
          title = doc['title'];
        });
      });
      FirebaseFirestore.instance
          .collection('Tournaments')
          .doc(widget.tournamentId)
          .collection('Levels')
          .orderBy('level')
          .get()
          .then((value) {
        QuerySnapshot ds = value;

        // Map<String, dynamic> roomData = querySnapshot?.docs[index].data() as Map<String, dynamic>;
        print('ds.size : ${ds.size}');
        setState(() {
          // tournamentList = List.filled(ds.size, DefaultTournament());
          tournamentList.add(DefaultTournament());
          _sbControllers.add(TextEditingController());
          _bbControllers.add(TextEditingController());
          _anteControllers.add(TextEditingController());

          for (int i = 1; i <= ds.size; i++) {
            Map<String, dynamic> item =
                ds.docs[i-1].data() as Map<String, dynamic>;
            tournamentList.add(DefaultTournament(
                level: item['level'],
                sb: item['sb'],
                bb: item['bb'],
                ante: item['ante'],
                runningTime: item['runningTime'],
                breakTime: item['breakTime']));

            _sbControllers.add(TextEditingController());
            _bbControllers.add(TextEditingController());
            _anteControllers.add(TextEditingController());

            _sbControllers[i].text = tournamentList[i].sb.toString();
            _bbControllers[i].text = tournamentList[i].bb.toString();
            _anteControllers[i].text = tournamentList[i].ante.toString();
          }
        });
      });
    } else {
      tournamentList.add(DefaultTournament());
      _sbControllers.add(TextEditingController());
      _bbControllers.add(TextEditingController());
      _anteControllers.add(TextEditingController());
      // for (var i = 1; i <= defaultTournament.level!; i++) {
      for (var i = 1; i <= 20; i++) {
        var level = i;
        // var sb = level * defaultTournament.sb!;
        // var bb = level * defaultTournament.bb!;
        // var ante = level * defaultTournament.ante!;
        var sb = 1000;
        var bb = 1000;
        var ante = 1000;
        var runningTime = 8; //defaultTournament.runningTime;
        var breakTime = 0;

        if (i % 5 == 0) {
          breakTime = 5; //defaultTournament.breakTime!;
        } else if (i == 20) {
          breakTime = 10; //defaultTournament.breakTime!;
        }
        tournamentList.add(DefaultTournament(
          level: level,
          sb: sb,
          bb: bb,
          ante: ante,
          runningTime: runningTime,
          breakTime: breakTime,
        ));
        _sbControllers.add(TextEditingController());
        _bbControllers.add(TextEditingController());
        _anteControllers.add(TextEditingController());

        _sbControllers[i].text = '1000';
        _bbControllers[i].text = '2000';
        _anteControllers[i].text = '3000';
      }
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
    print(tournamentId);

    for (int i = 1; i < tournamentList.length; i++) {
      Map<String, dynamic> tournamentLevelMap = {
        "level": i,
        "sb": int.parse(_sbControllers[i].text), //tournamentList[i].sb!,
        "bb": int.parse(_bbControllers[i].text),
        "ante": int.parse(_anteControllers[i].text),
        "runningTime": tournamentList[i].runningTime!,
        "breakTime": tournamentList[i].breakTime!,
      };

      if (widget.purpose == 'edit') {
        /// 제목 변경 없는 경우
        if (titleController.text == title) {
          FirebaseFirestore.instance
              .collection("Tournaments")
              .doc(tournamentId)
              .collection("Levels")
              .doc(titleController.text)
              .set(tournamentLevelMap).then((_) {
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
          });
        } else {
          /// 제목 변경된 경우
          FirebaseFirestore.instance
              .collection("Tournaments")
              .doc(tournamentId)
              .collection("Levels")
              .doc(titleController.text)
              .set(tournamentLevelMap).then((_) {
            /// 업로드 완료 후 title setting
            FirebaseFirestore.instance
                .collection("Tournaments")
                .doc(tournamentId)
                .set({
              'title': tournamentId,
              'createdDt': DateTime.now()
            }).then((_) {
              /// 이전 토너먼트 제목 가진 문서 삭제
              FirebaseFirestore.instance
                  .collection("Tournaments")
                  .doc(title).delete();
            }).catchError((e) {
              print(e.toString());
            });
          });
        }
      } else {
        /// 신규 토너먼트 생성
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
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.13,
                                  child: TextFormField(
                                      decoration: InputDecoration(
                                          border: InputBorder.none),
                                      textAlign: TextAlign.center,
                                      controller: _sbControllers[index],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: smallTextSize,
                                          fontWeight: FontWeight.bold))
                                  // headerText(
                                  //     tournamentList[index].sb.toString(),
                                  //     smallTextSize),
                                  ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.03),

                              /// BB
                              Container(
                                width: MediaQuery.of(context).size.width * 0.13,
                                child: TextFormField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none),
                                    textAlign: TextAlign.center,
                                    controller: _bbControllers[index],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: smallTextSize,
                                        fontWeight: FontWeight.bold)),
                                // headerText(
                                //     tournamentList[index].bb.toString(),
                                //     smallTextSize),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.03,
                              ),

                              /// Ante
                              Container(
                                width: MediaQuery.of(context).size.width * 0.13,
                                child: TextFormField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none),
                                    textAlign: TextAlign.center,
                                    controller: _anteControllers[index],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: smallTextSize,
                                        fontWeight: FontWeight.bold)),
                                // headerText(
                                //     tournamentList[index].ante.toString(),
                                //     smallTextSize),
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
                                    DefaultTournament removeData =
                                        tournamentList.removeAt(index);
                                    print(
                                        'removeData.level : ${removeData.level}');
                                    print('removeData.sb : ${removeData.sb}');
                                    print('removeData.bb : ${removeData.bb}');
                                    print(
                                        'removeData.ante : ${removeData.ante}');
                                    print(
                                        'removeData.runningTime : ${removeData.runningTime}');
                                    print(
                                        'removeData.breakTime : ${removeData.breakTime}');
                                  });
                                },
                                child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.redAccent.withOpacity(0.6),
                                      size: MediaQuery.of(context).size.width *
                                          0.03,
                                    )),
                              ),
                            ]),
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
          sb: tournamentList[length - 1].sb! + 100,
          bb: tournamentList[length - 1].bb! + 200,
          ante: tournamentList[length - 1].ante! + 200,
          runningTime: tournamentList[length - 1].runningTime!,
          breakTime: tournamentList[length - 1].breakTime!));
      _sbControllers.add(TextEditingController());
      _bbControllers.add(TextEditingController());
      _anteControllers.add(TextEditingController());
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
