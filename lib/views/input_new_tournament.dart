import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holdem_timer/models/default_tournament.dart';
import 'package:holdem_timer/views/tournaments_setting.dart';

import '../globals.dart';
import '../widgets.dart';

class InputNewTournament extends StatefulWidget {
  @override
  _InputNewTournamentState createState() => _InputNewTournamentState();
}

class _InputNewTournamentState extends State<InputNewTournament> {
  TextEditingController titleController = TextEditingController();
  DefaultTournament tournament = DefaultTournament();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }
  @override
  void initState() {
    super.initState();

    titleController.text = '';
    tournament.level = 30;
    tournament.sb = 100;
    tournament.bb = 200;
    tournament.ante = 200;
    tournament.runningTime = 8;
    tournament.breakTime = 5;
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
                    child: mediumBox(context)),
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

  mediumBox(context) {
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
            Form(
              key: _formKey,
              child: Container(
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
                      validator: (text) {
                        if (text!.isEmpty) {
                          return '토너먼트 제목을 입력하셔야 합니다.';
                        }
                      },
                      decoration: InputDecoration(
                          hintText: '토너먼트 제목을 입력하세요',
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: smallTextSize),
                          border: InputBorder.none,
                          focusColor: mainColor),
                      controller: titleController,
                      style: TextStyle(
                          fontSize: smallTextSize, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                ]),
              ),
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
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                    ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width * 0.01),

                  /// LEVEL
                  Container(
                    width: MediaQuery.of(context).size.width * 0.13,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (tournament.level! > 0) {
                                tournament.level = tournament.level! - 1;
                              }
                            });
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.remove,
                                color: Colors.white,
                                size: smallTextSize,
                              ),
                            ),
                          ),
                        ),
                        headerText(tournament.level.toString(), smallTextSize),
                        InkWell(
                          onTap: () {
                            setState(
                                () => tournament.level = tournament.level! + 1);
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
                  SizedBox(width: MediaQuery.of(context).size.width * 0.03),

                  /// SB
                  // plusMinusContainer(context, tournament.sb, smallTextSize, minusClickFunction(index), plusClickFunction(index)),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.13,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (tournament.sb! > 0) {
                                tournament.sb = tournament.sb! - 100;
                              }
                            });
                          },
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.remove,
                                color: Colors.white,
                                size: smallTextSize,
                              ),
                            ),
                          ),
                        ),
                        columnText(
                          'Level',
                          'X',
                          tournament.sb.toString(),
                          smallTextSize,
                        ),
                        InkWell(
                          onTap: () {
                            setState(
                                () => tournament.sb = tournament.sb! + 100);
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
                  SizedBox(width: MediaQuery.of(context).size.width * 0.03),

                  /// BB
                  Container(
                    width: MediaQuery.of(context).size.width * 0.13,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (tournament.bb! > 0) {
                                tournament.bb = tournament.bb! - 100;
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
                        columnText(
                          'Level',
                          'X',
                          tournament.bb.toString(),
                          smallTextSize,
                        ),
                        InkWell(
                          onTap: () {
                            setState(
                                () => tournament.bb = tournament.bb! + 100);
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
                              if (tournament.ante! > 0) {
                                tournament.ante = tournament.ante! - 100;
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
                        columnText(
                          'Level',
                          'X',
                          tournament.ante.toString(),
                          smallTextSize,
                        ),
                        InkWell(
                          onTap: () {
                            setState(
                                () => tournament.ante = tournament.ante! + 100);
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
                            if (tournament.runningTime! > 0) {
                              setState(() => tournament.runningTime =
                                  tournament.runningTime! - 1);
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
                            tournament.runningTime.toString(), smallTextSize),
                        InkWell(
                          onTap: () {
                            setState(() {
                              tournament.runningTime =
                                  tournament.runningTime! + 1;
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
                              if (tournament.breakTime! > 0) {
                                tournament.breakTime =
                                    tournament.breakTime! - 1;
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
                            tournament.breakTime.toString(), smallTextSize),
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (tournament.breakTime! > 0) {
                                tournament.breakTime =
                                    tournament.breakTime! + 1;
                              }
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
                ],
              ),
            )
          ],
        ),
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

  columnText(text, text2, text3, textSize) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(text,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: textSize,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(text2,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: textSize,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(text3,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: textSize,
                    fontWeight: FontWeight.bold)),
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
              MediaQuery.of(context).size.width * 0.48,
              MediaQuery.of(context).size.height * 0.1,
            ),
          ),
        ],
      ),
    );
  }

  rightBottomButtons(context) {
    var smallTextSize = MediaQuery.of(context).size.width * 0.02;
    return Container(
      width: MediaQuery.of(context).size.width * 0.49,
      height: MediaQuery.of(context).size.height * 0.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                Get.to(() => TournamentsSetting(titleController.text, tournament));
              }
            },
            child: primaryButton(
              'NEW TOURNAMENT',
              smallTextSize,
              MediaQuery.of(context).size.width * 0.48,
              MediaQuery.of(context).size.height * 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
