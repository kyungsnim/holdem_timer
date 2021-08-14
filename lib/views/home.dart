import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:holdem_timer/views/play.dart';

import '../globals.dart';
import '../widgets.dart';
import 'input_new_tournament.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> tournamentList = [];

  @override
  void initState() {
    super.initState();
    loadOrSaveData();
  }

  @override
  Widget build(BuildContext context) {
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
    FirebaseFirestore.instance
        .collection('Tournaments')
        .get()
        .then((value) async {
      QuerySnapshot ds = value;

      // Map<String, dynamic> roomData = querySnapshot?.docs[index].data() as Map<String, dynamic>;
      print('ds.size : ${ds.size}');

      setState(() {
        for (int i = 0; i < ds.size; i++) {
          Map<String, dynamic> item = ds.docs[i].data() as Map<String, dynamic>;
          print('item[\'title\'] : ${item['title']}');
          tournamentList.add(item['title']);
        }
      });
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

    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: titleTextSize * 1.5,
              height: titleTextSize * 1.5,
              child: Image(
                image: AssetImage('assets/images/logo.png'),
              )),
          SizedBox(
            width: mediumTextSize,
          ),
          Text('T O U R N A M E N T S',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: titleTextSize,
                  color: mainColor))
        ],
      ),
    );
  }

  tournamentBox(context) {
    var mediumTextSize = MediaQuery.of(context).size.width * 0.035;
    var smallTextSize = MediaQuery.of(context).size.width * 0.02;
    // if(tournamentList.length == 0) return Center(child: Container(child: CircularProgressIndicator()));
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
              // smallButton(
              //   'COPY',
              //   smallTextSize,
              //   MediaQuery.of(context).size.height * 0.08,
              // ),
              // SizedBox(width: 5),
              InkWell(
                onTap: () {
                  onPressDelete(tournamentList[index]);
                },
                child: smallButton(
                  'DELETE',
                  smallTextSize,
                  MediaQuery.of(context).size.height * 0.08,
                ),
              ),
            ]),
          );
        },
      ),
    );
  }

  bottomButtons(context) {
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
            onTap: () => Get.to(() => InputNewTournament()), //TournamentsSetting()),
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
    var smallTextSize = MediaQuery.of(context).size.width * 0.02;
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text("앱을 종료하시겠습니까?", style: TextStyle(fontSize: smallTextSize, color: mainColor)),
        actions: <Widget>[
          TextButton(
            child: Text(
              "예",
              style: TextStyle(fontSize: smallTextSize, color: mainColor),
            ),
            onPressed: () {
              SystemNavigator.pop();
            },
          ),
          TextButton(
            child: Text(
              "아니오",
              style: TextStyle(fontSize: smallTextSize, color: Colors.grey),
            ),
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      ),
    );
  }

  Future<bool?> onPressDelete(tournamentId) async {
    var smallTextSize = MediaQuery.of(context).size.width * 0.02;

    return showDialog(
      // barrierColor: Colors.black,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text("삭제하시겠습니까?", style: TextStyle(fontSize: smallTextSize, color: mainColor)),
        actions: <Widget>[
          TextButton(
            child: Text(
              "예",
              style: TextStyle(fontSize: smallTextSize, color: mainColor),
            ),
            onPressed: () async {
              // await
              FirebaseFirestore.instance
                  .collection('Tournaments')
                  .doc(tournamentId)
                  .collection('Levels')
                  .get()
                  .then((snapshot) {
                for (DocumentSnapshot ds in snapshot.docs) {
                  ds.reference.delete();
                }
              }).then((_) async {
                FirebaseFirestore.instance
                    .collection('Tournaments')
                    .doc(tournamentId)
                    .delete()
                    .then((_) {
                  setState(() {
                    tournamentList = [];
                  });

                  /// 데이터 다시 조회
                  loadOrSaveData();
                });
              });

              Navigator.pop(context, false);
            },
          ),
          TextButton(
            child: Text(
              "아니오",
              style: TextStyle(fontSize: smallTextSize, color: Colors.grey),
            ),
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      ),
    );
  }
}
