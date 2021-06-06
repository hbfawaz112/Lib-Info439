import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_petrol_station/screens/pump_records.dart';
import 'package:flutter_petrol_station/widgets/Drawer.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'shipments.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_petrol_station/services/cloud_services.dart';

class Dashboard_Firstore extends StatefulWidget {
  Dashboard_Firstore({Key key}) : super(key: key);
  static String id = 'dashboard_firestore';

  @override
  _Dashboard_FirstoreState createState() => _Dashboard_FirstoreState();
}

class _Dashboard_FirstoreState extends State<Dashboard_Firstore> {
  String station, pStation;
  User loggedInUser;

  @override
  void initState() {
    super.initState();
    loggedInUser = cloudServices.getCurrentUser();
    print("user");
    print(loggedInUser);
    asyncMethod();
  }

  void asyncMethod() async {
    // we do this to call a fct that need async wait when calling it;
    // when aiming to use the fct in initState
    if (loggedInUser != null) {
      station = await cloudServices.getUserStation(loggedInUser);
    }
    setState(() {});
    // hay l setState bhotta ekher shi bl fct yalle btrajj3 shi future krml yn3amal rebuild
    // krml yontor l data yalle 3m trj3 mn l firestore bs n3aytla ll method
  }

  CloudServices cloudServices =
      CloudServices(FirebaseFirestore.instance, FirebaseAuth.instance);

  Future getContainers() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('Stations')
        .doc(station)
        .collection('Container')
        .get();
    //print(snapshot.docs[0]["Container_Name"]);
    return snapshot;
  }

  Future getPumpNames(int id) async {
    var s = await FirebaseFirestore.instance
        .collection('Stations')
        .doc(station)
        .collection('Pump')
        .where('Container_Id', isEqualTo: id)
        .get();
    return s;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashborad'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Stations')
              .doc(station)
              .collection('Container')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print("has data");
              print(station);
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                        snapshot.data.docs[index];
                    return Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Card(
                        elevation: 12.0,
                        child: Column(children: [
                          Container(
                            color: Colors.blue.shade700,
                            width: 400,
                            height: 120,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(children: [
                                Text(
                                    'Container ${documentSnapshot["Container_Name"]}',
                                    style: TextStyle(
                                        color: Colors.indigo[900],
                                        fontSize: 37,
                                        fontWeight: FontWeight.w900)),
                                SizedBox(height: 20),
                                Expanded(
                                    child: LinearPercentIndicator(
                                  width:
                                      MediaQuery.of(context).size.width - 110,
                                  animation: true,
                                  lineHeight: 20.0,
                                  animationDuration: 2500,
                                  percent: documentSnapshot["Volume"] /
                                      documentSnapshot["Capacity"],
                                  center: Text(
                                    '${documentSnapshot["Volume"]}',
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                  linearStrokeCap: LinearStrokeCap.roundAll,
                                  progressColor: Colors.green,
                                )),
                              ]),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Pumps  ",
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.blue[500],
                                    fontWeight: FontWeight.w800),
                              ),
                              Center(
                                  child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('Stations')
                                          .doc(station)
                                          .collection('Pump')
                                          .where('Container_Id',
                                              isEqualTo: documentSnapshot[
                                                  "Container_Id"])
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  snapshot.data.docs.length,
                                              itemBuilder: (context, index) {
                                                DocumentSnapshot
                                                    documentSnapshot1 =
                                                    snapshot.data.docs[index];
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          // Pump_Records.id,
                                                          // arguments: {
                                                          //   "pump_id":
                                                          //       documentSnapshot1[
                                                          //           "Pump_Id"],
                                                          //   "pump_name":
                                                          //       documentSnapshot1[
                                                          //           "Pump_Name"],
                                                          // },
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                Pump_Records(
                                                              pumpID:
                                                                  documentSnapshot1[
                                                                      "Pump_Id"],
                                                              pumpName:
                                                                  documentSnapshot1[
                                                                      "Pump_Name"],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Text(
                                                        '    ${documentSnapshot1["Pump_Name"]}',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color: Colors
                                                                .blue[500]),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                        } else {
                                          return Text('Loaddinggg....');
                                        }
                                      })),
                            ],
                          ),
                          SizedBox(height: 5.0),
                          ButtonTheme(
                            height: 50.0,
                            minWidth: 270,
                            child: RaisedButton(
                              color: Colors.blueGrey.shade200,
                              elevation: 12,
                              child: Text('New Shipment',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 23)),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Shipments()),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 25.0),
                        ]),
                      ),
                    );
                  });
            } else {
              print("no data");
              print(station);
              return Text('Loading.....');
            }
          }),
    );
  }
}
