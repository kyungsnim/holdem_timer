import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets.dart';

class Play extends StatefulWidget {
  @override
  _PlayState createState() => _PlayState();
}

class _PlayState extends State<Play> {
  Timer? _timer; // 타이머
  var _level = 1;
  var _totalHours = 0;          // TOTAL TIME HOURS
  var _totalMinutes = 0;        // TOTAL TIME MINUTES
  var _totalSeconds = 0;        // TOTAL TIME SECONDS
  // var _levelHours = 0;          // CURRENT LEVEL HOURS
  var _levelMinutes = 8;        // CURRENT LEVEL MINUTES
  var _levelSeconds = 0;        // CURRENT LEVEL SECONDS
  var _timeToBreakHours = 0;    // TIME TO BREAK HOURS
  var _timeToBreakMinutes = 0;  // TIME TO BREAK MINUTES
  var _timeToBreakSeconds = 0;  // TIME TO BREAK SECONDS
  var _isPlaying = false;       // 시작/정지 상태값
  var startOrPause = 'START';

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.black,
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
            )));
  }

  // 시작, 일시정지 버튼
  void _click() {
    _isPlaying = !_isPlaying;
    if (_isPlaying) {
      setState(() {
        startOrPause = 'PAUSE';
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
        _totalSeconds++;
        if(_totalSeconds == 60) {
          _totalMinutes++;
          _totalSeconds = 0;
        }
        if(_totalMinutes == 60) {
          _totalHours++;
          _totalMinutes = 0;
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
    if(_isPlaying) {
      _pause();
    }

    setState(() {
      startOrPause = 'START';
      _isPlaying = false;
      _timer?.cancel();
      // _saveTimes.clear();
      _totalSeconds = 0;
    });
  }

  titleText(context) {
    var titleTextSize = MediaQuery.of(context).size.width * 0.06;
    var mediumTextSize = MediaQuery.of(context).size.width * 0.035;
    var smallTextSize = MediaQuery.of(context).size.width * 0.02;
    var sec = _totalSeconds; // 초

    return Container(
      height: MediaQuery.of(context).size.height * 0.20,
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
                    Text(_totalMinutes < 10 ? '0$_totalMinutes' : '$_totalMinutes',
                        style: TextStyle(
                            color: Colors.white, fontSize: mediumTextSize)),
                    Text(':',
                        style: TextStyle(
                            color: Colors.white, fontSize: mediumTextSize)),
                    Text(_totalSeconds < 10 ? '0$_totalSeconds' : '$_totalSeconds', // _seconds < 10 ? _minutes < 10 ? _hours < 10 ? '0$_hours:0$_minutes:0$_seconds' : '$_hours:0$_minutes:0$_seconds' : '$_hours:$_minutes:0$_seconds' : '$_hours:$_minutes:$_seconds'
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
                    color: Colors.orange)),
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('TIME TO BREAK',
                    style: TextStyle(
                        color: Colors.white, fontSize: mediumTextSize)),
                Text('00:40:00',
                    style: TextStyle(
                        color: Colors.white, fontSize: mediumTextSize))
              ],
            ),
          ],
        ),
      ),
    );
  }

  mediumBox(context) {
    var bigTitleTextSize = MediaQuery.of(context).size.width * 0.1;
    var titleTextSize = MediaQuery.of(context).size.width * 0.06;
    var mediumTextSize = MediaQuery.of(context).size.width * 0.035;
    var smallTextSize = MediaQuery.of(context).size.width * 0.02;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white60)),
      height: MediaQuery.of(context).size.height * 0.55,
      child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Column(
                      children: [
                        Text('LEVEL $_level',
                            style: TextStyle(
                                color: Colors.white, fontSize: titleTextSize)),
                        Text('$_levelMinutes:$_levelSeconds',
                            style: TextStyle(
                                color: Colors.white, fontSize: bigTitleTextSize)),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('NEXT BLIND',
                            style: TextStyle(
                                color: Colors.white, fontSize: mediumTextSize)),
                        RichText(
                          text: TextSpan(
                              style: TextStyle(fontSize: mediumTextSize),
                              children: [
                                TextSpan(
                                    text: 'SB ',
                                    style: TextStyle(color: Colors.grey)),
                                TextSpan(
                                    text: '200',
                                    style: TextStyle(color: Colors.white)),
                                TextSpan(
                                    text: ' / ',
                                    style: TextStyle(color: Colors.grey)),
                                TextSpan(
                                    text: '400',
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
                              style: TextStyle(fontSize: mediumTextSize),
                              children: [
                                TextSpan(
                                    text: '400',
                                    style: TextStyle(color: Colors.white)),
                              ]),
                        ),
                        SizedBox(height: 20),
                        Text('AVG STACK',
                            style: TextStyle(
                                color: Colors.white, fontSize: mediumTextSize)),
                        RichText(
                          text: TextSpan(
                              style: TextStyle(fontSize: mediumTextSize),
                              children: [
                                TextSpan(
                                    text: '0',
                                    style: TextStyle(color: Colors.white)),
                              ]),
                        ),
                      ],
                    ),
                  ),
                ]),
              )
            ],
          )),
    );
  }

  bottomButtons(context) {
    var titleTextSize = MediaQuery.of(context).size.width * 0.06;
    var mediumTextSize = MediaQuery.of(context).size.width * 0.035;
    var smallTextSize = MediaQuery.of(context).size.width * 0.02;
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => _click(),
            child: primaryButton(
              startOrPause,
              mediumTextSize,
              MediaQuery.of(context).size.width * 0.19,
              MediaQuery.of(context).size.height * 0.2,
            ),
          ),
          InkWell(
            onTap: () => _reset(),
            child: primaryButton(
              'RESET',
              mediumTextSize,
              MediaQuery.of(context).size.width * 0.19,
              MediaQuery.of(context).size.height * 0.2,
            ),
          ),
          plusMinusButton(
            'TIME',
            mediumTextSize,
            MediaQuery.of(context).size.width * 0.19,
            MediaQuery.of(context).size.height * 0.2,
            // plus Function
            timePlus,
            // minus Function
            timeMinus
          ),
          plusMinusButton(
            'LEVEL',
            mediumTextSize,
            MediaQuery.of(context).size.width * 0.19,
            MediaQuery.of(context).size.height * 0.2,
            levelPlus,
            levelMinus,
          ),
          InkWell(
            onTap: () => Navigator.pop(context),
            child: primaryButton(
              'SETTING',
              mediumTextSize,
              MediaQuery.of(context).size.width * 0.19,
              MediaQuery.of(context).size.height * 0.2,
            ),
          ),
        ],
      ),
    );
  }

  timePlus() {
    setState(() {
      _levelMinutes++;
    });
  }

  timeMinus() {
    setState(() {
      _levelMinutes--;
    });
  }

  levelPlus() {
    setState(() {
      _level++;
    });
  }

  levelMinus() {
    setState(() {
      _level--;
    });
  }
}
