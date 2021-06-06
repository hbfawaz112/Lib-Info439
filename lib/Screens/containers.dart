import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_petrol_station/services/cloud_services.dart';

class Containers extends StatefulWidget {
  static String id = 'containers';
  @override
  _ContainersState createState() => _ContainersState();
}

class _ContainersState extends State<Containers> {
  //var _firestore = FirebaseFirestore.instance;
  //var _auth = FirebaseAuth.instance;

  String station, pStation;
  User loggedInUser;
  Stream s;
  var r;
  CloudServices cloudServices =
      CloudServices(FirebaseFirestore.instance, FirebaseAuth.instance);
  QuerySnapshot stationInfo;
  @override
  void initState() {
    super.initState();
    loggedInUser = cloudServices.getCurrentUser();
    asyncMethod();
  }

  void asyncMethod() async {
    // we do this to call a fct that need async wait when calling it;
    // when aiming to use the fct in initState
    if (loggedInUser != null) {
      station = await cloudServices.getUserStation(loggedInUser);
      stationInfo = await cloudServices.getAllStationInfo1();
    }
    setState(() {});
    // hay l setState bhotta ekher shi bl fct yalle btrajj3 shi future krml yn3amal rebuild
    // krml yontor l data yalle 3m trj3 mn l firestore bs n3aytla ll method
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Email: " + loggedInUser.email,
              style: TextStyle(
                fontSize: 10.0,
                color: Colors.black,
              ),
            ),
            Text(
              //check the variable containing data from firestore before using it
              pStation = station != null ? "Station: " + station : "",
              style: TextStyle(
                fontSize: 10.0,
                color: Colors.black,
              ),
            ),
            StreamBuilder(
              //stream: Stream.fromFuture(cloudServices.get()),
              stream: FirebaseFirestore.instance
                  .collection('Stations')
                  .doc('Petrol Station 1')
                  .collection('Container')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot documentSnapshot =
                            snapshot.data.docs[index];
                        return Text(
                          'Capacity: ${documentSnapshot["Capacity"].toString()}',
                          style: TextStyle(
                            fontSize: 10.0,
                            color: Colors.black,
                          ),
                        );
                      });
                } else {
                  return Text(
                    "Loading...",
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.red,
                    ),
                  );
                }
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                var rr = FirebaseFirestore.instance
                    .collection('Stations')
                    .doc('Petrol Station 1')
                    .collection('Container')
                    .snapshots();
                print(rr.runtimeType);
                print("llllllllllllllll");

                //List<Map<String, dynamic>> c =
                List<QuerySnapshot> c = await cloudServices.getAllStationInfo();
                print("yyyyyyyyyy");
                if (c != null) {
                  // for (var i in c) {
                  //   print("gggggggggggggggggggg");
                  //   print(i.keys);
                  //   print(i.values);
                  // }
                  for (var t in c) {
                    print(t.docs.map((e) => e.data()));
                  }
                } else {
                  print("nulllllllllll");
                }
                print("tttttttttttttt");
              },
            ),
          ],
        ),
      ),
    );
  }
}

// TextButton(
//   child: Text('Save'),
//   onPressed: () async {
//     // _firestore
//     //     .collection('containers')
//     //     .doc('documentId') //id of the document here put
//     //     // something about container
//     //     .set({'volume': 20.0, 'email': loggedInUser.email});
//     //getData();
//     //   _firestore
//     //       .collection('Petrol Station 1')
//     //       .doc('Container')
//     //       .collection('1')
//     //       .doc('1')
//     //       .set({
//     //     'Capacity': 15000,
//     //     'Container_Id': 1,
//     //     'Container_Name': "Diesel",
//     //     'Fuel_Type_Id': 2,
//     //     'Volume': 3000
//     //   });
//     String station = await getUserStation();
//     print(station);
//   },
// ),

// Future<String> getUserStation() async {
//   await for (var d
//       in _firestore.collection("Login").doc(loggedInUser.uid).snapshots()) {
//     print(d.data()); //get all fields
//     //print(d.get("station")); //get specific field
//     setState(() {
//       station = d.get("station");
//     });
//     return d.get("station"); //get specific field
//   }
//   //setState(
//   //  () {}); // hay bhotta ekher shi bl fct yalle btrajj3 shi future krml yn3amal rebuild
//   // krml yontor l data yalle 3m trj3 mn l firestore bs n3aytla ll method
// }
