import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:holdem_timer/models/default_tournament.dart';
import 'package:holdem_timer/views/play.dart';
import 'package:holdem_timer/views/tournaments_setting.dart';

import '../widgets.dart';

class Home extends StatelessWidget {
  List<DefaultTournament> tournamentList = [];

  @override
  Widget build(BuildContext context) {
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

    int i = -1;
    return Scaffold(
        body: Container(
            color: Colors.black,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// title
                titleText(context),

                /// tournament box
                tournamentBox(context),

                /// bottom buttons
                bottomButtons(context),
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
          Icon(
            Icons.notifications_active,
            color: Colors.orange,
            size: titleTextSize,
          ),
          SizedBox(
            width: titleTextSize,
          ),
          Text('T O U R N A M E N T S',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: titleTextSize,
                  color: Colors.orange))
        ],
      ),
    );
  }

  tournamentBox(context) {
    var titleTextSize = MediaQuery.of(context).size.width * 0.06;
    var mediumTextSize = MediaQuery.of(context).size.width * 0.035;
    var smallTextSize = MediaQuery.of(context).size.width * 0.02;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white60)),
      height: MediaQuery.of(context).size.height * 0.6,
      child: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(
              color: Colors.white10,
            )),
            child: Row(children: [
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Container(
                    child: Text('Default Tourn.1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: mediumTextSize,
                        )),
                  ),
                ),
              ),
              Spacer(),
              InkWell(
                  onTap: () => Get.to(() => Play()),
                  child: smallButton(
                    'PLAY',
                    smallTextSize,
                    MediaQuery.of(context).size.height * 0.08,
                  )),
              SizedBox(width: 5),
              smallButton(
                'COPY',
                smallTextSize,
                MediaQuery.of(context).size.height * 0.08,
              ),
              SizedBox(width: 5),
              smallButton(
                'DELETE',
                smallTextSize,
                MediaQuery.of(context).size.height * 0.08,
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
          primaryButton(
            'EXIT',
            mediumTextSize,
            MediaQuery.of(context).size.width * 0.47,
            MediaQuery.of(context).size.height * 0.2,
          ),
          InkWell(
            onTap: () => Get.to(() => TournamentsSetting()),
            child: primaryButton(
              'NEW TOURNAMENT',
              mediumTextSize,
              MediaQuery.of(context).size.width * 0.47,
              MediaQuery.of(context).size.height * 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
