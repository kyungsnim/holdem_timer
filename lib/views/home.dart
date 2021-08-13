import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:holdem_timer/models/default_tournament.dart';
import 'package:holdem_timer/views/play.dart';
import 'package:holdem_timer/views/tournaments_setting.dart';

import '../widgets.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> tournamentList = [];

  @override
  Widget build(BuildContext context) {
    loadOrSaveData();

    int i = -1;
    return Scaffold(
        resizeToAvoidBottomInset: false,
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

  loadOrSaveData() async {
    var tournamentId = 'Default Tourn.1';

    FirebaseFirestore.instance
        .collection('Tournaments')
        .get()
        .then((value) async {
      QuerySnapshot ds = value;

      // Map<String, dynamic> roomData = querySnapshot?.docs[index].data() as Map<String, dynamic>;
      print('ds.size : ${ds.size}');

      for (int i = 0; i < ds.size; i++) {
        Map<String, dynamic> item = ds.docs[i].data() as Map<String, dynamic>;
        print('item[\'title\'] : ${item['title']}');
        tournamentList.add(item['title']);
      }
    });

    /// Find my save Tournament datas
    // FirebaseFirestore.instance.collection('Tournaments').doc(tournamentId).collection('Levels').get().then((value) async {
    //   QuerySnapshot ds = value;
    //
    //   print('ds.size : ${ds.size}');
    //
    //   /// If cannot find datas, then save new datas.
    //   if(ds.size == 0) {
    //     for (int i = 1; i <= 30; i++) {
    //       Map<String, dynamic> tournamentLevelMap = {
    //         "level": tournamentList[i].level!,
    //         "sb": tournamentList[i].sb!,
    //         "bb": tournamentList[i].bb!,
    //         "ante": tournamentList[i].ante!,
    //         "runningTime": tournamentList[i].runningTime!,
    //         "breakTime": tournamentList[i].breakTime!,
    //       };
    //
    //       await FirebaseFirestore.instance
    //           .collection("Tournaments")
    //           .doc(tournamentId)
    //           .collection("Levels")
    //           .add(tournamentLevelMap)
    //           .catchError((e) {
    //         print(e.toString());
    //       });
    //     }
    //   }
    // });
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
    print(tournamentList.length);
    for(int i = 0; i < tournamentList.length; i++){
      print('tournamentList[i] : ${tournamentList[i]}');
    }
    if(tournamentList.length == 0) return Center(child: Container(child: CircularProgressIndicator()));
    return Container(
      decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white60)),
      height: MediaQuery.of(context).size.height * 0.6,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: tournamentList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
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
                    child: Text(tournamentList[index],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: mediumTextSize,
                        )),
                  ),
                ),
              ),
              Spacer(),
              InkWell(
                  onTap: () => Get.to(() => Play(tournamentList[index])),
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
          );
        },
      ),
    );
  }

  bottomButtons(context) {
    var titleTextSize = MediaQuery.of(context).size.width * 0.06;
    var mediumTextSize = MediaQuery.of(context).size.width * 0.035;
    var smallTextSize = MediaQuery.of(context).size.width * 0.02;
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => onPressExit(context),
            child: primaryButton(
              'EXIT',
              smallTextSize,
              MediaQuery.of(context).size.width * 0.47,
              MediaQuery.of(context).size.height * 0.1,
            ),
          ),
          InkWell(
            onTap: () => Get.to(() => TournamentsSetting()),
            child: primaryButton(
              'NEW TOURNAMENT',
              smallTextSize,
              MediaQuery.of(context).size.width * 0.47,
              MediaQuery.of(context).size.height * 0.1,
            ),
          ),
        ],
      ),
    );
  }

  // back 버튼 클릭시 종료할건지 물어보는
  Future<bool?> onPressExit(context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Would you like to exit?", style: TextStyle(fontSize: 18)),
        actions: <Widget>[
          TextButton(
            child: Text(
              "Yes",
              style: TextStyle(fontSize: 15, color: Colors.blue),
            ),
            onPressed: () {
              SystemNavigator.pop();
            },
          ),
          TextButton(
            child: Text(
              "No",
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      ),
    );
  }
}