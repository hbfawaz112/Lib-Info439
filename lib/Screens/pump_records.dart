import 'package:flutter/material.dart';
import 'package:flutter_petrol_station/widgets/drawer_firstore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_petrol_station/services/cloud_services.dart';
import 'package:flutter_petrol_station/models/Pump_Record.dart';
import 'package:intl/intl.dart';

String station;

class Pump_Records extends StatefulWidget {
  static String id = 'pump_records';

  //get passed data from previous page
  final String pumpName;
  final int pumpID;
  const Pump_Records({Key key, this.pumpID, this.pumpName}) : super(key: key);

  @override
  _PumpsState createState() =>
      //To Use received data without widget. ( Storing the passed value in a different variable before using it)
      _PumpsState(pumpID: this.pumpID, pumpName: this.pumpName);
}

class _PumpsState extends State<Pump_Records> {
  //To Use received data without widget. ( Storing the passed value in a different variable before using it)
  String pumpName;
  int pumpID;
  _PumpsState({this.pumpID, this.pumpName});

  User loggedInUser;
  static int container_id, pump_id;
  static String container_name, pump_name;
  //String station;
  Map<String, Object> received_data;
  int containerID;
  String containerName;
  int previousCounter, newCounter, lastRecordId;
  DateTime lastUpdate;
  int recordError = 0;
  Color colorR = Colors.blueAccent;
  var msgController = TextEditingController();
  final now = new DateTime.now();
  DateTime dateToday =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  //dd/MM/yyyy h:mm a
  final DateTime nn = DateTime.now();
  final DateFormat formatter = DateFormat('dd/MM/yyyy h:mm a');
  String formatted;
  DateTime Record_Time;

  FirebaseFirestore db = FirebaseFirestore.instance;
  CloudServices cloudServices =
      CloudServices(FirebaseFirestore.instance, FirebaseAuth.instance);

  @override
  void initState() {
    super.initState();

    loggedInUser = cloudServices.getCurrentUser();
    asyncMethod();
    print("inittt");
    print(station);
    // future that allows us to access context. function is called inside the future
    // otherwise it would be skipped and args would return null
    //getContainerInfo(widget.pumpID);
    //print(station);
  }

  void asyncMethod() async {
    // we do this to call a fct that need async wait when calling it;
    // when aiming to use the fct in initState
    if (loggedInUser != null) {
      station = await cloudServices.getUserStation(loggedInUser);
    }
    await getContainerId(widget.pumpID);
    print("asynccccc $containerID");
    if (containerID != null) {
      await getContainerName(containerID);
    }
    setState(() {});
    // hay l setState bhotta ekher shi bl fct yalle btrajj3 shi future krml yn3amal rebuild
    // krml yontor l data yalle 3m trj3 mn l firestore bs n3aytla ll method
  }

  void getContainerName(int container_id) async {
    String cont_name;
    print("In get name $container_id");

    await db
        .collection('Stations')
        .doc('Petrol Station 1')
        .collection('Container')
        .doc(container_id.toString())
        .get()
        .then((value) {
      print("dataaaaaaaaaaaaa");
      print(value.data());
      cont_name = value.data()['Container_Name'];
      print("container nameee: $cont_name");
      containerName = cont_name;
    });
    // .where('Container_Id', isEqualTo: container_id)
    // .get();
  }

  getContainerId(int pumpId) async {
    print("pump idddddddddd in fct: $pumpId");
    print("stationnnn: $station");
    print(station);
    int cont_id;

    DocumentReference documentReference = db
        .collection('Stations')
        .doc(station)
        .collection('Pump')
        .doc(pumpId.toString());
    await documentReference.get().then((value) {
      print("dataaaaaaaaaaaaa");
      print(value.data());
      cont_id = value.data()['Container_Id'];
      print("container idddddd: $cont_id");
      containerID = cont_id;
    });
  }

  void getPumpRecord() {
    db
        .collection('Stations')
        .doc(station)
        .collection('PumpRecord')
        .where('Pump_Id', isEqualTo: pumpID)
        .get()
        .then((value) {
      if (value.docs.length > 0) {}
    });

    var qs = db
        .collection('Stations')
        .doc(station)
        .collection('Pump_Record')
        .where('Pump_Id', isEqualTo: pumpID)
        .orderBy('Pump_Record_Id', descending: true)
        .get()
        .then((val) => {
              if (val.docs.length > 0)
                {
                  // {
                  //   setState(() {
                  //     previousCounter = val.docs[0].get("Record");
                  //     print(previousCounter);
                  //     lastUpdate = DateTime.tryParse(
                  //         (val.docs[0].get("Record_Time")).toDate().toString());
                  //     print(lastUpdate);
                  //     lastRecordId = val.docs[0].get("Pump_Record_Id");
                  //     print("last record iddddd$lastRecordId");
                  //   }),
                  previousCounter = val.docs[0].get("Record"),
                  print(previousCounter),
                  lastUpdate = DateTime.tryParse(
                      (val.docs[0].get("Record_Time")).toDate().toString()),
                  print(lastUpdate),
                  lastRecordId = val.docs[0].get("Pump_Record_Id"),
                  print("last record iddddd$lastRecordId"),
                }
              else
                {
                  print("elseeeee"),
                }
            });
    setState(() {});
  }

  //     .snapshots();
  // qs.then((value) => previousCounter = value.docs.last.data()['Record']);

  @override
  Widget build(BuildContext context) {
    // final Map<String, Object> received_data =
    //     ModalRoute.of(context).settings.arguments;
    // pump_id = received_data["pump_id"];
    // pump_name = received_data["pump_name"];

    //if (mounted) {
    //getContainerInfo(pump_id);
    //}

    var dts;
    int _rowPerPage = PaginatedDataTable.defaultRowsPerPage;

    getPumpRecord();

    print("previous $previousCounter");

    print("builddd $containerID");
    print("builddd $containerName");
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF083369),
        actions: [
          Row(
            children: [
              Icon(
                Icons.exit_to_app,
                size: 24,
                color: Colors.white,
              ),
              Text('LOGOUT',
                  style: TextStyle(color: Colors.white, fontSize: 21.0)),
              SizedBox(width: 20)
            ],
          )
        ],
      ),
      drawer: getDrawer_firstore(),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              containerName != null ? 'Pump ($containerName)' : 'Pump',
              style: TextStyle(
                color: Colors.amberAccent,
                fontSize: 30,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Card(
            elevation: 12,
            child: ExpansionTile(
              title: Text("Pump Info",
                  style: TextStyle(fontSize: 29, color: Colors.indigo[300])),
              trailing: Icon(Icons.arrow_drop_down,
                  size: 20, color: Colors.indigo[300]),
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 12,
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Text('Pump Name',
                              style: TextStyle(
                                  fontSize: 25, color: Colors.black45)),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(widget.pumpName != null ? '$pumpName' : 'Pump',
                          style: TextStyle(
                              fontSize: 22, color: Colors.indigo[300])),
                      SizedBox(
                        height: 18,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Text('Container Name',
                              style: TextStyle(
                                  fontSize: 25, color: Colors.black45)),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                          containerName != null
                              ? 'Container $containerName'
                              : 'Container',
                          style: TextStyle(
                              fontSize: 22, color: Colors.indigo[300])),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Card(
            elevation: 10,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  Text("New Counter",
                      style: TextStyle(fontSize: 21, color: Colors.black45)),
                  SizedBox(height: 10),
                  Column(
                    children: <Widget>[
                      TextFormField(
                          keyboardType: TextInputType.number,
                          controller: msgController,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black54, width: 2.0),
                              ),
                              labelText: previousCounter != null
                                  ? previousCounter.toString()
                                  : '',
                              fillColor: Colors.white,
                              labelStyle: TextStyle(color: Colors.black45),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: colorR, width: 2.0))),
                          onChanged: (value) {
                            setState(() {
                              newCounter = int.parse(value);
                            });
                          }),
                      Text(
                        recordError == 1
                            ? 'Enter value positive value greater than $previousCounter'
                            : '',
                        style: TextStyle(color: colorR),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Previous Counter',
                          style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF083369))),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                              previousCounter != null
                                  ? previousCounter.toString()
                                  : '',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF083369))),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Last Update',
                          style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF083369))),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                          lastUpdate != null ? lastUpdate.toString() : '',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF083369))),
                    ),
                  ),
                  Divider(
                    color: Colors.black45,
                    thickness: 3,
                  ),
                  ButtonTheme(
                    height: 50.0,
                    minWidth: 130,
                    child: RaisedButton(
                      color: Colors.indigo[800],
                      elevation: 12,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.library_add_check_outlined,
                              size: 22, color: Colors.white),
                          SizedBox(
                            width: 14,
                          ),
                          Text('Save',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25)),
                        ],
                      ),
                      onPressed: () {
                        DateTime d = DateTime.now();
                        Timestamp myTimeStamp = Timestamp.fromDate(d);
                        if (newCounter == null) {
                          setState(() {
                            recordError = 1;
                            colorR = Colors.red;
                          });
                        } else {
                          if (newCounter < 0 || newCounter < previousCounter) {
                            setState(() {
                              recordError = 1;
                              colorR = Colors.red;
                            });
                          } else {
                            if (newCounter != null) {
                              setState(() {
                                recordError = 0;
                                colorR = Colors.blueAccent;
                              });
                              int docId = lastRecordId + 1;
                              db
                                  .collection("Stations")
                                  .doc(station)
                                  .collection("Pump_Record")
                                  .doc(docId.toString())
                                  .set({
                                'Container_Id': containerID,
                                'Pump_Id': pumpID,
                                'Pump_Record_Id': docId,
                                'Record': newCounter,
                                'Record_Time': myTimeStamp,
                                'X_Id': myTimeStamp
                              });
                              setState(() {
                                //previousCounter = newCounter;
                                //lastUpdate = DateTime.tryParse(
                                //(myTimeStamp).toDate().toString());
                                previousCounter = newCounter;
                                lastUpdate = DateTime.now();
                              });
                              msgController.clear();
                            }
                          }
                        }
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          // StreamBuilder(
          //     stream: db
          //         .collection('Stations')
          //         .doc(station)
          //         .collection('Pump_Record')
          //         .snapshots(),
          //     builder: (context, snapshot) {
          //       if (snapshot.hasData) {
          //         dts = new DTS(snapshot);
          //         return SingleChildScrollView(
          //             child: PaginatedDataTable(
          //           header: Row(
          //             children: <Widget>[
          //               Text("Date"),
          //               Text("Counter"),
          //               Text(""),
          //             ],
          //           ),
          //           columns: [
          //             DataColumn(label: Text("col1")),
          //             DataColumn(label: Text("col2")),
          //           ],
          //           source: dts,
          //           onRowsPerPageChanged: (value) {
          //             setState(() {
          //               _rowPerPage = value;
          //             });
          //           },
          //           rowsPerPage: _rowPerPage,
          //         ));
          //       } else {
          //         return Text('');
          //       }
          //     }),
          Card(
            elevation: 12,
            child: ExpansionTile(
              title: Text("Previous Record",
                  style: TextStyle(fontSize: 29, color: Colors.indigo[300])),
              trailing: Icon(Icons.arrow_drop_down,
                  size: 20, color: Colors.indigo[300]),
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 25),
                      TextFormField(
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 2.0),
                              ),
                              labelText: "Search Here",
                              fillColor: Colors.white,
                              labelStyle: TextStyle(color: Colors.black45),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blueAccent, width: 2.0))),
                          onChanged: (String s) {}),
                      SizedBox(height: 10),
                      StreamBuilder(
                          stream: db
                              .collection('Stations')
                              .doc(station)
                              .collection('Pump_Record')
                              .where('Pump_Id', isEqualTo: pumpID)
                              .orderBy('Pump_Record_Id', descending: true)
                              .limit(10)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Text('ddddddddd');
                            } else {
                              return Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('Date'),
                                      Text('Counter'),
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.indigo,
                                    thickness: 4,
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      itemCount: snapshot.data.docs.length,
                                      itemBuilder: (context, index) {
                                        int length = snapshot.data.docs.length;
                                        DocumentSnapshot documentSnapshot =
                                            snapshot.data.docs[index];
                                        return Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text((documentSnapshot[
                                                                'Record_Time']
                                                            .toDate()
                                                            .toString()) !=
                                                        null
                                                    ? formatter.format(
                                                        DateTime.tryParse(
                                                            (documentSnapshot[
                                                                    'Record_Time']
                                                                .toDate()
                                                                .toString())))
                                                    : ''),
                                                Text(documentSnapshot['Record']
                                                    .toString()),
                                                GestureDetector(
                                                  child: index == 0
                                                      ? IconButton(
                                                          icon: const Icon(
                                                              Icons.delete),
                                                          color: Colors.red,
                                                          onPressed: () {},
                                                        )
                                                      : IconButton(
                                                          icon: const Icon(
                                                              Icons.delete),
                                                          color: Colors.white,
                                                          onPressed: () {},
                                                        ),
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.blueAccent,
                                              thickness: 2,
                                            )
                                          ],
                                        );
                                      }),
                                ],
                              );
                            }
                          }),
                      // SingleChildScrollView(
                      //     scrollDirection: Axis.horizontal,
                      //     child: StreamBuilder(
                      //       stream: db
                      //           .collection('Stations')
                      //           .doc(station)
                      //           .collection('Pump_Record')
                      //           .where('Pump_Id', isEqualTo: pumpID)
                      //           .orderBy('Pump_Record_Id', descending: true)
                      //           .snapshots(),
                      //       builder: (context, snapshot) {
                      //         if (!snapshot.hasData) {
                      //           return LinearProgressIndicator();
                      //         } else {
                      //           DocumentSnapshot documentSnapshot =
                      //               snapshot.data.docs;
                      //
                      //           return DataTable(
                      //               columnSpacing: 35,
                      //               columns: [
                      //                 DataColumn(
                      //                     label: Text(
                      //                   "Date",
                      //                   style: TextStyle(
                      //                       fontSize: 16,
                      //                       fontWeight: FontWeight.w800),
                      //                 )),
                      //                 DataColumn(
                      //                   label: Text(
                      //                     "Record",
                      //                     style: TextStyle(
                      //                         fontSize: 16,
                      //                         fontWeight: FontWeight.w800),
                      //                   ),
                      //                 ),
                      //                 DataColumn(
                      //                   label: Text(
                      //                     "Delete",
                      //                     style: TextStyle(
                      //                         fontSize: 16,
                      //                         fontWeight: FontWeight.w800),
                      //                   ),
                      //                 ),
                      //               ],
                      //               //rows: const <DataRow>[
                      //               //   DataRow(
                      //               //     cells: <DataCell>[
                      //               //       DataCell(Text('2021-03-03 21:43:01')),
                      //               //       DataCell(Text('1000.00')),
                      //               //       DataCell(Icon(Icons.delete,
                      //               //           color: Colors.red, size: 20)),
                      //               //     ],
                      //               //   ),
                      //               // ],
                      //               rows: List<DataRow>.generate(
                      //                 3,
                      //                 (index) => DataRow(cells: [
                      //                   DataCell(Text("fff")),
                      //                   DataCell(Text("ffffffffff")),
                      //                 ]),
                      //               ));
                      //         }
                      //       },
                      //     )),
                      SizedBox(height: 20),
                      Divider(
                        color: Colors.black,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

List<DataRow> _buildList(
    BuildContext context, List<DocumentSnapshot> snapshot) {
  // var qs = FirebaseFirestore.instance
  //     .collection('Stations')
  //     .doc(station)
  //     .collection('Pump_Record')
  //     .orderBy("Record_Id")
  //     .limitToLast(3)
  //     .get();
  return snapshot.map((data) => _buildListItem(context, data)).toList();
}

DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
  return DataRow(cells: [
    DataCell(Text(data.get('Record_Time'))),
    DataCell(Text(data.get('Record'))),
  ]);
}

class DTS extends DataTableSource {
  var snapshot;

  DTS(this.snapshot);

  var snapshots = FirebaseFirestore.instance
      .collection("Stations")
      .doc(station)
      .collection('Pump_Record')
      .snapshots();

  @override
  DataRow getRow(int index) {
    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(snapshot.data.docs[index + 1]['RecordTime'])),
      DataCell(Text(DateTime.tryParse((snapshot.data.docs[index + 1]
                  ["Record_Time"])
              .toDate()
              .toString())
          .toString())),
    ]);
  }

  @override
  bool get isRowCountApproximate {
    return true;
  }

  @override
  int get rowCount {
    return 100;
  }

  @override
  int get selectedRowCount {
    return 0;
  }
}

// }
