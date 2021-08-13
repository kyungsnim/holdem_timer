import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:holdem_timer/models/default_tournament.dart';
import 'dart:async';
import '../widgets.dart';

class Play extends StatefulWidget {
  String tournamentId;

  Play(this.tournamentId);

  @override
  _PlayState createState() => _PlayState();
}

class _PlayState extends State<Play> {
  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();

  Timer? _timer; // 타이머
  var _currentLevel = 0; // 실제 레벨은 1과 맵핑
  var _totalHours = 0; // TOTAL TIME HOURS
  var _totalMinutes = 0; // TOTAL TIME MINUTES
  var _totalSeconds = 0; // TOTAL TIME SECONDS
  var _levelMinutes = 0; // CURRENT LEVEL MINUTES
  var _levelSeconds = 0; // CURRENT LEVEL SECONDS
  var _timeToBreakHours = 0; // TIME TO BREAK HOURS
  var _timeToBreakMinutes = 0; // TIME TO BREAK MINUTES
  var _timeToBreakSeconds = 0; // TIME TO BREAK SECONDS
  var _isPlaying = false; // 시작/정지 상태값
  var startOrPause = 'START';
  var sb = 0;
  var bb = 0;
  var ante = 0;
  var nextSb = 0;
  var nextBb = 0;
  var nextAnte = 0;
  List<DefaultTournament>? tournamentList;
  late DefaultTournament currentTournament;

  TextEditingController memoController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // if (Platform.isIOS) {
    //   audioCache.fixedPlayer!.startHeadlessService();
    //   audioPlayer.startHeadlessService();
    // }

    FirebaseFirestore.instance.collection('Tournaments').doc(widget.tournamentId).collection('Levels').orderBy('level').get().then((value) {
      QuerySnapshot ds = value;

      // Map<String, dynamic> roomData = querySnapshot?.docs[index].data() as Map<String, dynamic>;
      print('ds.size : ${ds.size}');
      setState(() {
        tournamentList = List.filled(ds.size, DefaultTournament());
        for(int i = 0; i < ds.size; i++){
          Map<String, dynamic> item = ds.docs[i].data() as Map<String, dynamic>;
          tournamentList![i] = DefaultTournament(level: item['level'], sb: item['sb'], bb: item['bb'],
              ante: item['ante'], runningTime: item['runningTime'], breakTime: item['breakTime']);
        }

        /// level 1
        currentTournament = tournamentList![_currentLevel];
        levelSetting();
        breakTimeSetting();
      });
    });
  }

  play(sound) {
    audioCache.play('audios/$sound.mp3');
  }

  levelSetting() {
    setState(() {
      currentTournament = tournamentList![_currentLevel];
      _levelMinutes = currentTournament.runningTime!;
      _levelSeconds = 0;
      sb = currentTournament.sb!;
      bb = currentTournament.bb!;
      ante = currentTournament.ante!;
      nextSb = tournamentList![_currentLevel + 1].sb!;
      nextBb = tournamentList![_currentLevel + 1].bb!;
      nextAnte = tournamentList![_currentLevel + 1].ante!;
      // _levelMinutes = currentTournament.runningTime!;
      // breakTimeSetting();
    });
  }

  breakTimeSetting() {
    _timeToBreakMinutes = 0;
    _timeToBreakSeconds = 0;

    /// 브레이크타임까지의 시간 계산을 위해 임시 레벨 저장
    var forCalcBreakTimeLevel = _currentLevel;
    _timeToBreakMinutes += _levelMinutes;
    while (true) {
      /// 만일 현재 레벨에 브레이크타임이 있는 경우
      if(tournamentList![forCalcBreakTimeLevel].breakTime! > 0) {
        print('this');
        break;
      } else {
        /// 브레이크타임이 있는 레벨까지 계속 더해주기
        _timeToBreakMinutes +=
        tournamentList![forCalcBreakTimeLevel].runningTime!;

        /// 만약 브레이크타임이 있는 레벨인 경우 누적합 그만하기
        if (tournamentList![++forCalcBreakTimeLevel].breakTime! > 0) {
          break;
        }
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(children: [
          /// 배경
          Container(
            color: Colors.black,
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,
            // child: Image(
            //   image: AssetImage('assets/images/background.png'),
            // ),
          ),
          Container(
              color: Colors.black.withOpacity(0.6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  /// title
                  titleText(context),

                  ///
                  mediumBox(context),

                  /// bottom buttons
                  bottomButtons(context),
                ],
              )),
        ]));
  }

  // 시작, 일시정지 버튼
  void _click() {
    _isPlaying = !_isPlaying;
    if (_isPlaying) {
      setState(() {
        startOrPause = 'STOP';
      });
      // _color = Colors.grey;
      _start();
    } else {
      setState(() {
        startOrPause = 'RESUME';
      });
      // _color = Colors.amber;
      _pause();
    }
  }

  // 1/100초에 한 번씩 time 1씩 증가
  void _start() {
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        /// total time
        _totalSeconds++;
        if (_totalSeconds == 60) {
          _totalSeconds = 0;
          _totalMinutes++;
        }
        if (_totalMinutes == 60) {
          _totalMinutes = 0;
          _totalHours++;
        }

        /// level time
        if (_levelSeconds == 0 || _levelSeconds == 60) {
          // _levelSeconds = 60;
          if (_levelMinutes > 0) {
            _levelMinutes--;
          } else {
            /// 분이 0이고 초도 0인 경우 다음 레벨로 변경
            _currentLevel++;
            levelSetting();
            breakTimeSetting();
            _levelMinutes--;
            if (_timeToBreakMinutes != 0 && _timeToBreakSeconds != 0 && currentTournament.breakTime! == 0){
              /// 브레이크타임이 아닐 때만 NEXT LEVEL 소리 내보내
              play('nextLevel');
            }
          }
          _levelSeconds = 60;
        }

        _levelSeconds--;

        /// to break time
        if (_timeToBreakSeconds == 0 || _timeToBreakSeconds == 60) {
          if (_timeToBreakMinutes == 0 && _timeToBreakSeconds == 0 && currentTournament.breakTime! > 0){
            /// 분이 0이고 초도 0인 경우 브레이크 타임
            play('timeToBreak');
          }
          if (_timeToBreakMinutes > 0) {
            _timeToBreakMinutes--;
          }
          _timeToBreakSeconds = 60;
        }
        _timeToBreakSeconds--;

        if (_levelMinutes == 0 && _levelSeconds <= 5 && _levelSeconds > 0) {
          /// 5초 남을 때부터 음성 표시하기
          play(_levelSeconds);
        }

      });
    });
  }

  // 타이머 중지(취소)
  void _pause() {
    _timer?.cancel();
  }

  // 초기화
  void _reset() {
    /// 재생 중 RESET하는 경우
    if (_isPlaying) {
      _pause();
    }

    setState(() {
      startOrPause = 'START';
      _isPlaying = false;
      _timer?.cancel();
      // _saveTimes.clear();
      _totalMinutes = 0;
      _totalSeconds = 0;

      /// 레벨 1 상태로 초기화
      _currentLevel = 1;
      currentTournament = tournamentList![_currentLevel];
      levelSetting();
      breakTimeSetting();
    });
  }

  titleText(context) {
    var titleTextSize = MediaQuery
        .of(context)
        .size
        .width * 0.06;
    var mediumTextSize = MediaQuery
        .of(context)
        .size
        .width * 0.035;
    var smallTextSize = MediaQuery
        .of(context)
        .size
        .width * 0.02;
    var sec = _totalSeconds; // 초

    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.20,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('TOTAL TIME',
                    style: TextStyle(
                        color: Colors.white, fontSize: mediumTextSize)),
                Row(
                  children: [
                    Text(_totalHours < 10 ? '0$_totalHours' : '$_totalHours',
                        style: TextStyle(
                            color: Colors.white, fontSize: mediumTextSize)),
                    Text(':',
                        style: TextStyle(
                            color: Colors.white, fontSize: mediumTextSize)),
                    Text(
                        _totalMinutes < 10
                            ? '0$_totalMinutes'
                            : '$_totalMinutes',
                        style: TextStyle(
                            color: Colors.white, fontSize: mediumTextSize)),
                    Text(':',
                        style: TextStyle(
                            color: Colors.white, fontSize: mediumTextSize)),
                    Text(
                        _totalSeconds < 10
                            ? '0$_totalSeconds'
                            : '$_totalSeconds',
                        // _seconds < 10 ? _minutes < 10 ? _hours < 10 ? '0$_hours:0$_minutes:0$_seconds' : '$_hours:0$_minutes:0$_seconds' : '$_hours:$_minutes:0$_seconds' : '$_hours:$_minutes:$_seconds'
                        style: TextStyle(
                            color: Colors.white, fontSize: mediumTextSize))
                  ],
                )
              ],
            ),
            Spacer(),
            Text('PLAY GAME',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: titleTextSize,
                    color: Colors.black)),
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('TIME TO BREAK',
                    style: TextStyle(
                        color: Colors.white, fontSize: mediumTextSize)),
                Row(
                  children: [
                    Text(_timeToBreakHours < 10
                        ? '0$_timeToBreakHours'
                        : '$_timeToBreakHours',
                        style: TextStyle(
                            color: Colors.white, fontSize: mediumTextSize)),
                    Text(':',
                        style: TextStyle(
                            color: Colors.white, fontSize: mediumTextSize)),
                    Text(_timeToBreakMinutes < 10
                        ? '0$_timeToBreakMinutes'
                        : '$_timeToBreakMinutes',
                        style: TextStyle(
                            color: Colors.white, fontSize: mediumTextSize)),
                    Text(':',
                        style: TextStyle(
                            color: Colors.white, fontSize: mediumTextSize)),
                    Text(_timeToBreakSeconds < 10
                        ? '0$_timeToBreakSeconds'
                        : '$_timeToBreakSeconds',
                        style: TextStyle(
                            color: Colors.white, fontSize: mediumTextSize))
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  mediumBox(context) {
    var bigTitleTextSize = MediaQuery
        .of(context)
        .size
        .width * 0.15;
    var titleTextSize = MediaQuery
        .of(context)
        .size
        .width * 0.05;
    var tmTextSize = MediaQuery
        .of(context)
        .size
        .width * 0.043;
    var mediumTextSize = MediaQuery
        .of(context)
        .size
        .width * 0.035;
    var msTextSize = MediaQuery.of(context).size.width * 0.027;
    var smallTextSize = MediaQuery
        .of(context)
        .size
        .width * 0.02;
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
      ),
      height: MediaQuery
          .of(context)
          .size
          .height * 0.7,
      child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Row(children: [

                  /// 좌측 박스
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.6,
                    child: Column(
                      children: [
                        Text('LEVEL $_currentLevel',
                            style: TextStyle(
                                color: Colors.white, fontSize: titleTextSize)),
                        Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.6,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _levelMinutes < 10
                                      ? '0$_levelMinutes'
                                      : '$_levelMinutes',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: bigTitleTextSize),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  ':',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: bigTitleTextSize),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  _levelSeconds < 10
                                      ? '0$_levelSeconds'
                                      : '$_levelSeconds',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: bigTitleTextSize),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                        ),
                        RichText(
                          text: TextSpan(
                              style: TextStyle(fontSize: titleTextSize),
                              children: [
                                TextSpan(
                                    text: 'SB ',
                                    style: TextStyle(color: Colors.grey)),
                                TextSpan(
                                    text: sb.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' / ',
                                    style: TextStyle(color: Colors.grey)),
                                TextSpan(
                                    text: bb.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: ' BB',
                                    style: TextStyle(color: Colors.grey)),
                              ]),
                        ),
                        RichText(
                          text: TextSpan(
                              style: TextStyle(fontSize: titleTextSize),
                              children: [
                                TextSpan(
                                    text: 'ANTE ',
                                    style: TextStyle(color: Colors.grey)),
                                TextSpan(
                                    text: ante.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ]),
                        ),
                      ],
                    ),
                  ),
                  /// 우측 박스
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.35,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('NEXT BLIND',
                            style: TextStyle(
                                color: Colors.white, fontSize: mediumTextSize)),
                        RichText(
                          text: TextSpan(
                              style: TextStyle(fontSize: tmTextSize),
                              children: [
                                TextSpan(
                                    text: 'SB ',
                                    style: TextStyle(color: Colors.grey)),
                                TextSpan(
                                    text: nextSb.toString(),
                                    style: TextStyle(color: Colors.white)),
                                TextSpan(
                                    text: ' / ',
                                    style: TextStyle(color: Colors.grey)),
                                TextSpan(
                                    text: nextBb.toString(),
                                    style: TextStyle(color: Colors.white)),
                                TextSpan(
                                    text: ' BB',
                                    style: TextStyle(color: Colors.grey)),
                              ]),
                        ),
                        SizedBox(height: 20),
                        Text('NEXT ANTE',
                            style: TextStyle(
                                color: Colors.white, fontSize: mediumTextSize)),
                        RichText(
                          text: TextSpan(
                              style: TextStyle(fontSize: tmTextSize),
                              children: [
                                TextSpan(
                                    text: nextAnte.toString(),
                                    style: TextStyle(color: Colors.white)),
                              ]),
                        ),
                        // SizedBox(height: 20),
                        // Text('MEMO',
                        //     style: TextStyle(
                        //         color: Colors.white, fontSize: smallTextSize)),
                        // Container(
                        //     decoration: BoxDecoration(
                        //       border: Border.all(color: Colors.grey),
                        //         color: Colors.black.withOpacity(0.2),
                        // ),
                        //     child: TextFormField(
                        //       decoration: InputDecoration(
                        //         border: InputBorder.none
                        //       ),
                        //       maxLines: 5,
                        //       keyboardType: TextInputType.multiline,
                        //       style: TextStyle(fontSize: smallTextSize, color: Colors.white),
                        //     ))
                      ],
                    ),
                  ),
                ]),
              )
            ],
          )),
    );
  }

  extraSettingBox(title, count, minusFunction, plusFunction) {
    var titleTextSize = MediaQuery
        .of(context)
        .size
        .width * 0.06;
    var mediumTextSize = MediaQuery
        .of(context)
        .size
        .width * 0.035;
    var smallTextSize = MediaQuery
        .of(context)
        .size
        .width * 0.02;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: smallTextSize),
          textAlign: TextAlign.center,
        ),
        Row(
          children: [
            InkWell(
              onTap: minusFunction,
              child: Container(
                  height: mediumTextSize * 1.7,
                  width: mediumTextSize * 2,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20)),
                      border: Border.all(color: Colors.grey),
                      color: Colors.grey.withOpacity(0.4)),
                  child: Icon(
                    Icons.remove,
                    color: Colors.white,
                    size: mediumTextSize,
                  )),
            ),
            Container(
                alignment: Alignment.center,
                height: mediumTextSize * 1.7,
                width: mediumTextSize * 2,
                padding: const EdgeInsets.all(8.0),
                decoration:
                BoxDecoration(border: Border.all(color: Colors.grey)),
                child: Text(
                  count,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: mediumTextSize),
                )),
            InkWell(
              onTap: plusFunction,
              child: Container(
                  height: mediumTextSize * 1.7,
                  width: mediumTextSize * 2,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      border: Border.all(color: Colors.grey),
                      color: Colors.grey.withOpacity(0.4)),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: mediumTextSize,
                  )),
            ),
          ],
        )
      ],
    );
  }

  bottomButtons(context) {
    var mediumTextSize = MediaQuery
        .of(context)
        .size
        .width * 0.035;
    var smallTextSize = MediaQuery
        .of(context)
        .size
        .width * 0.02;
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => _click(),
            child: primaryButton(
              startOrPause,
              smallTextSize,
              MediaQuery
                  .of(context)
                  .size
                  .width * 0.19,
              MediaQuery
                  .of(context)
                  .size
                  .height * 0.2,
            ),
          ),
          InkWell(
            onTap: () => _reset(),
            child: primaryButton(
              'RESET',
              smallTextSize,
              MediaQuery
                  .of(context)
                  .size
                  .width * 0.19,
              MediaQuery
                  .of(context)
                  .size
                  .height * 0.2,
            ),
          ),
          plusMinusButton(
              'TIME',
              smallTextSize,
              MediaQuery
                  .of(context)
                  .size
                  .width * 0.19,
              MediaQuery
                  .of(context)
                  .size
                  .height * 0.2,
              // plus Function
              timePlus,
              // minus Function
              timeMinus),
          plusMinusButton(
            'LEVEL',
            smallTextSize,
            MediaQuery
                .of(context)
                .size
                .width * 0.19,
            MediaQuery
                .of(context)
                .size
                .height * 0.2,
            levelPlus,
            levelMinus,
          ),
          InkWell(
            onTap: () => Navigator.pop(context),
            child: primaryButton(
              'SETTING',
              smallTextSize,
              MediaQuery
                  .of(context)
                  .size
                  .width * 0.19,
              MediaQuery
                  .of(context)
                  .size
                  .height * 0.2,
            ),
          ),
        ],
      ),
    );
  }

  timePlus() {
    setState(() {
      _levelMinutes++;
      _timeToBreakMinutes++;
      //breakTimeSetting();
    });
  }

  timeMinus() {
    setState(() {
      if (_levelMinutes > 0) {
        _levelMinutes--;
        if(_timeToBreakMinutes > 0) {
          _timeToBreakMinutes--;
          // breakTimeSetting();
        }
      }
    });
  }

  levelPlus() {
    setState(() {
      _currentLevel++;

      /// level +
      currentTournament = tournamentList![_currentLevel];
      levelSetting();
      breakTimeSetting();
    });
  }

  levelMinus() {
    setState(() {
      if (currentTournament.level! > 1) {
        _currentLevel--;

        /// level -
        currentTournament = tournamentList![_currentLevel];
        levelSetting();
        breakTimeSetting();
      }
    });
  }
}