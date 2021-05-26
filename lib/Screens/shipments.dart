import 'package:flutter/material.dart';
import 'package:flutter_petrol_station/widgets/drawer_firstore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_petrol_station/services/cloud_services.dart';

class Shipments extends StatefulWidget {
  static String id = 'shipments';
  @override
  _ShipmentsState createState() => _ShipmentsState();
}

class _ShipmentsState extends State<Shipments> {
  String dropdownValue = 'One';
  int _radioValue = 0;
  String container_category,
      fuel_category,
      provider_category,
      selected_date,
      note;
  static int container_id, fuel_type_id, provider_id;
  DateTime today = DateTime.now();
  int volume, shipmentValue, capacity, maxVolume, oldVolume;
  bool IsPaid;
  Timestamp Paid_Date, Shipment_Date;
  int lastID, docId;
  int volumeError = 0, shipmentValueError = 0;

  CloudServices cloudServices =
      CloudServices(FirebaseFirestore.instance, FirebaseAuth.instance);

  FirebaseFirestore db = FirebaseFirestore.instance;
  String station, pStation;
  User loggedInUser;
  Color colorE = Colors.blueAccent, colorP = Colors.blueAccent;
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
      getFirstCategory();
      //getVolume();
    }
    setState(() {});
    // hay l setState bhotta ekher shi bl fct yalle btrajj3 shi future krml yn3amal rebuild
    // krml yontor l data yalle 3m trj3 mn l firestore bs n3aytla ll method
  }

  void getFirstCategory() async {
    var s = await db
        .collection('Stations')
        .doc(station)
        .collection('Container')
        .get()
        .then((val) => {
              if (val.docs.length > 0)
                {
                  t = val.docs[0].get("Container_Name"),
                  container_category = val.docs[0].get("Container_Name"),
                  container_id = val.docs[0].get("Container_Id"),
                  print("container id fct firsttt: $container_id"),
                  print("container name firsttt $container_category"),
                }
              else
                {print("Not Found")}
            });
    s = await db
        .collection('Stations')
        .doc(station)
        .collection('Provider')
        .get()
        .then((val) => {
              if (val.docs.length > 0)
                {
                  t = val.docs[0].get("Provider_Name"),
                  provider_category = val.docs[0].get("Provider_Name"),
                  provider_id = val.docs[0].get("Provider_Id"),
                  print("provider id fct firsttt: $provider_id"),
                  print("provider name firsttt $provider_category"),
                }
              else
                {print("Not Found")}
            });

    s = await db
        .collection('Stations')
        .doc(station)
        .collection('Fuel_Type')
        .get()
        .then((val) => {
              if (val.docs.length > 0)
                {
                  t = val.docs[0].get("Fuel_Type_Name"),
                  fuel_category = val.docs[0].get("Fuel_Type_Name"),
                  fuel_type_id = val.docs[0].get("Fuel_Type_Id"),
                  print("fuel id fct firsttt: $fuel_type_id"),
                  print("fuel name firsttt $fuel_category"),
                }
              else
                {print("Not Found")}
            });
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
      switch (_radioValue) {
        case 0:
          IsPaid = true;
          Paid_Date = Timestamp.fromDate(today);
          break;
        case 1:
          IsPaid = false;
          Paid_Date = Timestamp.fromDate(DateTime(0, 0, 0, 0, 0, 0, 0, 0));
          break;
      }
    });
  }

  void getLastDocId() {
    var qs = db
        .collection('Stations')
        .doc(station)
        .collection('Shipment')
        .orderBy("Shipment_Id")
        .limitToLast(1)
        .get()
        .then((val) => {
              if (val.docs.length > 0)
                {
                  lastID = val.docs[val.docs.length - 1].get("Shipment_Id"),
                  docId = lastID + 1,
                  print("lastt IDD: $lastID"),
                  print("doc IDD: $docId"),
                }
              else
                {
                  print("elseeeee"),
                }
            });
  }

  String t;
  void getIds() async {
    var s;
    if (container_category != null) {
      s = await FirebaseFirestore.instance
          .collection('Stations')
          .doc(station)
          .collection('Container')
          .where('Container_Name', isEqualTo: container_category)
          .get()
          .then((val) => {
                if (val.docs.length > 0)
                  {
                    t = val.docs[0].get("Container_Name"),
                    container_id = val.docs[0].get("Container_Id"),
                    print("container id fct: $container_id"),
                    print("container name $t"),
                  }
                else
                  {print("Not Found")}
              });
    }

    if (provider_category != null) {
      s = await db
          .collection('Stations')
          .doc(station)
          .collection('Provider')
          .where('Provider_Name', isEqualTo: provider_category)
          .get()
          .then((val) => {
                if (val.docs.length > 0)
                  {
                    t = val.docs[0].get("Provider_Name"),
                    provider_category = val.docs[0].get("Provider_Name"),
                    provider_id = val.docs[0].get("Provider_Id"),
                    print("provider id fct firsttt: $provider_id"),
                    print("provider name firsttt $provider_category"),
                  }
                else
                  {print("Not Found")}
              });
    }
    if (fuel_category != null) {
      s = await db
          .collection('Stations')
          .doc(station)
          .collection('Fuel_Type')
          .where('Fuel_Type_Name', isEqualTo: fuel_category)
          .get()
          .then((val) => {
                if (val.docs.length > 0)
                  {
                    t = val.docs[0].get("Fuel_Type_Name"),
                    fuel_category = val.docs[0].get("Fuel_Type_Name"),
                    fuel_type_id = val.docs[0].get("Fuel_Type_Id"),
                    print("fuel id fct : $fuel_type_id"),
                    print("fuel name  $fuel_category"),
                  }
                else
                  {print("Not Found")}
              });
    }
  }

  // int v;
  // void getVolume() async {
  //   if (container_category != null) {
  //     var s = await db
  //         .collection('Stations')
  //         .doc(station)
  //         .collection('Container')
  //         .where('Container_Name', isEqualTo: container_category)
  //         .get()
  //         .then((val) => {
  //               if (val.docs.length > 0)
  //                 {
  //                   capacity = val.docs[0].get("Capacity"),
  //                   volume = val.docs[0].get("Volume"),
  //                   print("volume fct: $volume"),
  //                   print("capacity fct: $capacity"),
  //                   v = capacity - volume,
  //                   print("max volume fct: $v"),
  //                 }
  //               else
  //                 {print("Not Found")}
  //             });
  //   }
  //   setState(() {
  //     maxVolume = v;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    getLastDocId();
    print("builddddd $docId");
    print("builddddd $lastID");
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(
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
        children: [
          SizedBox(
            height: 10,
          ),
          Text('  Shipments',
              style: TextStyle(
                color: Colors.amberAccent,
                fontSize: 36,
                fontWeight: FontWeight.w500,
              )),
          SizedBox(
            height: 20,
          ),
          Card(
            elevation: 12,
            child: ExpansionTile(
              title: Text("Add Shipments",
                  style: TextStyle(fontSize: 29, color: Colors.indigo[300])),
              trailing: Icon(Icons.arrow_drop_down,
                  size: 20, color: Colors.indigo[300]),
              children: [
                Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Text("Provider",
                            style:
                                TextStyle(fontSize: 21, color: Colors.black45)),
                        SizedBox(height: 10),
                        StreamBuilder(
                          stream: db
                              .collection('Stations')
                              .doc(station)
                              .collection('Provider')
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                width: 350.0,
                                height: 58,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1.0, style: BorderStyle.solid),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: provider_category,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: const TextStyle(
                                        color: Colors.deepPurple),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        provider_category = newValue;
                                      });
                                    },
                                    items: snapshot.data != null
                                        ? snapshot.data.docs
                                            .map((DocumentSnapshot document) {
                                            return new DropdownMenuItem<String>(
                                                value: document
                                                    .get('Provider_Name')
                                                    .toString(),
                                                child: new Container(
                                                  child: Center(
                                                    child: new Text(
                                                      document
                                                          .get('Provider_Name')
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w900),
                                                    ),
                                                  ),
                                                ));
                                          }).toList()
                                        : DropdownMenuItem(
                                            value: 'null',
                                            child: new Container(
                                              height: 100.0,
                                              child: new Text('null'),
                                            ),
                                          ),
                                  ),
                                ),
                              );
                            } else {
                              return Text('');
                            }
                          },
                        ),
                        SizedBox(height: 15),
                        Text("Date",
                            style:
                                TextStyle(fontSize: 21, color: Colors.black45)),
                        SizedBox(height: 10),
                        TextFormField(
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                suffixIcon: Icon(Icons.date_range_rounded,
                                    color: Colors.indigo[300]),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black, width: 2.0),
                                ),
                                labelText: today.toString(),
                                fillColor: Colors.white,
                                labelStyle: TextStyle(color: Colors.black45),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blueAccent, width: 2.0))),
                            onChanged: (String s) {
                              selected_date = s;
                            }),
                        SizedBox(height: 15),
                        Text("Container",
                            style:
                                TextStyle(fontSize: 21, color: Colors.black45)),
                        SizedBox(height: 10),
                        StreamBuilder(
                          stream: db
                              .collection('Stations')
                              .doc(station)
                              .collection('Container')
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                width: 350.0,
                                height: 58,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1.0, style: BorderStyle.solid),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: container_category,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: const TextStyle(
                                        color: Colors.deepPurple),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        container_category = newValue;
                                        //getVolume();
                                      });
                                    },
                                    items: snapshot.data != null
                                        ? snapshot.data.docs
                                            .map((DocumentSnapshot document) {
                                            return new DropdownMenuItem<String>(
                                                value: document
                                                    .get('Container_Name')
                                                    .toString(),
                                                child: new Container(
                                                  child: Center(
                                                    child: new Text(
                                                      document
                                                          .get('Container_Name')
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w900),
                                                    ),
                                                  ),
                                                ));
                                          }).toList()
                                        : DropdownMenuItem(
                                            value: 'null',
                                            child: new Container(
                                              height: 100.0,
                                              child: new Text('null'),
                                            ),
                                          ),
                                  ),
                                ),
                              );
                            } else {
                              return Text('');
                            }
                          },
                        ),
                        SizedBox(height: 15),
                        Text("Fuel Type",
                            style:
                                TextStyle(fontSize: 21, color: Colors.black45)),
                        SizedBox(height: 10),
                        StreamBuilder(
                          stream: db
                              .collection('Stations')
                              .doc(station)
                              .collection('Fuel_Type')
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                width: 350.0,
                                height: 58,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1.0, style: BorderStyle.solid),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: fuel_category,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: const TextStyle(
                                        color: Colors.deepPurple),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        fuel_category = newValue;
                                      });
                                    },
                                    items: snapshot.data != null
                                        ? snapshot.data.docs
                                            .map((DocumentSnapshot document) {
                                            return new DropdownMenuItem<String>(
                                                value: document
                                                    .get('Fuel_Type_Name')
                                                    .toString(),
                                                child: new Container(
                                                  child: Center(
                                                    child: new Text(
                                                      document
                                                          .get('Fuel_Type_Name')
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w900),
                                                    ),
                                                  ),
                                                ));
                                          }).toList()
                                        : DropdownMenuItem(
                                            value: 'null',
                                            child: new Container(
                                              height: 100.0,
                                              child: new Text('null'),
                                            ),
                                          ),
                                  ),
                                ),
                              );
                            } else {
                              return Text('');
                            }
                          },
                        ),
                        SizedBox(height: 15),
                        Text("Volume",
                            style:
                                TextStyle(fontSize: 21, color: Colors.black45)),
                        SizedBox(height: 10),
                        StreamBuilder(
                          stream: db
                              .collection('Stations')
                              .doc(station)
                              .collection('Container')
                              .where('Container_Name',
                                  isEqualTo: container_category)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              oldVolume =
                                  snapshot.data.docs[0].data()["Volume"];
                              var c = snapshot.data.docs[0].data()["Capacity"];
                              //print(v.toString());
                              //print(c.toString());
                              maxVolume = c - oldVolume;
                              return Column(
                                children: <Widget>[
                                  TextFormField(
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.black,
                                                width: 2.0),
                                          ),
                                          labelText:
                                              maxVolume.toString() != null
                                                  ? maxVolume.toString()
                                                  : '',
                                          fillColor: Colors.white,
                                          labelStyle:
                                              TextStyle(color: Colors.black45),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: colorE, width: 2.0))),
                                      onChanged: (String s) {
                                        volume = int.parse(s);
                                      }),
                                  Text(
                                    volumeError == 1
                                        ? 'Enter value <  than $maxVolume'
                                        : '',
                                    style: TextStyle(color: colorE),
                                  ),
                                ],
                              );
                            } else {
                              return Text('');
                            }
                          },
                        ),
                        SizedBox(height: 15),
                        Text("ShipmentValue(L.L)",
                            style:
                                TextStyle(fontSize: 21, color: Colors.black45)),
                        SizedBox(height: 10),
                        Column(
                          children: <Widget>[
                            TextFormField(
                                keyboardType: TextInputType.number,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.black, width: 2.0),
                                    ),
                                    labelText: "value L.L",
                                    fillColor: Colors.white,
                                    labelStyle:
                                        TextStyle(color: Colors.black45),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: colorP, width: 2.0))),
                                onChanged: (String s) {
                                  shipmentValue = int.parse(s);
                                }),
                            Text(
                              shipmentValueError == 1
                                  ? 'Enter value positive value'
                                  : '',
                              style: TextStyle(color: colorE),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(children: [
                          Text("Paid : ",
                              style: TextStyle(
                                  fontSize: 21, color: Colors.black45)),
                          new Radio(
                            value: 0,
                            groupValue: _radioValue,
                            onChanged: _handleRadioValueChange,
                          ),
                          new Text(
                            'Yes',
                            style: new TextStyle(
                                fontSize: 21.0, color: Colors.green),
                          ),
                          new Radio(
                            value: 1,
                            groupValue: _radioValue,
                            onChanged: _handleRadioValueChange,
                          ),
                          new Text(
                            'No',
                            style: new TextStyle(
                                fontSize: 21.0, color: Colors.red),
                          ),
                        ]),
                        SizedBox(height: 15),
                        TextFormField(
                            maxLines: 3,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black, width: 2.0),
                                ),
                                labelText: "Note",
                                fillColor: Colors.black,
                                labelStyle: TextStyle(color: Colors.black45),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blueAccent, width: 2.0))),
                            onChanged: (String s) {
                              note = s;
                            }),
                        SizedBox(height: 12),
                        ButtonTheme(
                          height: 50.0,
                          minWidth: 130,
                          child: RaisedButton(
                            color: Colors.indigo[800],
                            elevation: 12,
                            child: Text('Save',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25)),
                            onPressed: () {
                              getIds();
                              getLastDocId();
                              int docID = lastID + 1;
                              print("doc idddddd: $docId");

                              if (volume > maxVolume) {
                                setState(() {
                                  colorE = Colors.red;
                                  volumeError = 1;
                                });
                              } else {
                                setState(() {
                                  colorE = Colors.blueAccent;
                                  volumeError = 0;
                                });

                                if (shipmentValue > 0) {
                                  setState(() {
                                    colorP = Colors.blueAccent;
                                    shipmentValueError = 0;
                                  });
                                  db
                                      .collection("Stations")
                                      .doc(station)
                                      .collection("Shipment")
                                      .doc(docID.toString())
                                      .set({
                                    'Comment': note != null ? note : '',
                                    'Container_Id': container_id,
                                    'IsPaid': IsPaid,
                                    'Paid_Date': Paid_Date,
                                    'Provider_Id': provider_id,
                                    'Shipment_Date': Timestamp.fromDate(today),
                                    'Shipment_Id': docID != null ? docID : 0,
                                    'Shipment_Value': shipmentValue,
                                    'Shipment_Volume': volume
                                  });
                                  db
                                      .collection("Stations")
                                      .doc(station)
                                      .collection("Container")
                                      .doc(container_id.toString())
                                      .update({"Volume": oldVolume + volume});
                                } else {
                                  setState(() {
                                    colorP = Colors.red;
                                    shipmentValueError = 0;
                                  });
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ))
              ],
              backgroundColor: Colors.white,
              initiallyExpanded: false,
            ),
          ),

          SizedBox(height: 25),

          //*************************************************************************************//

          Card(
            elevation: 12,
            child: ExpansionTile(
              title: Text("Show Shipments",
                  style: TextStyle(fontSize: 29, color: Colors.indigo[300])),
              trailing: Icon(Icons.arrow_drop_down,
                  size: 20, color: Colors.indigo[300]),
              children: [
                Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(children: [
                      SizedBox(height: 10),
                      Text("Provider Name",
                          style:
                              TextStyle(fontSize: 21, color: Colors.black45)),
                      SizedBox(height: 10),
                      Container(
                          width: 350.0,
                          height: 58,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1.0, style: BorderStyle.solid),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                            isExpanded: true,
                            value: dropdownValue,
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownValue = newValue;
                              });
                            },
                            items: <String>['One', 'Two', 'Free', 'Four']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text('   ' + value),
                              );
                            }).toList(),
                          ))),
                      SizedBox(height: 15),
                      SizedBox(height: 10),
                      Text("Container Name",
                          style:
                              TextStyle(fontSize: 21, color: Colors.black45)),
                      SizedBox(height: 10),
                      Container(
                          width: 350.0,
                          height: 58,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1.0, style: BorderStyle.solid),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                            isExpanded: true,
                            value: dropdownValue,
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownValue = newValue;
                              });
                            },
                            items: <String>['One', 'Two', 'Free', 'Four']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text('   ' + value),
                              );
                            }).toList(),
                          ))),
                      SizedBox(height: 15),
                      Text("From Date",
                          style:
                              TextStyle(fontSize: 21, color: Colors.black45)),
                      SizedBox(height: 10),
                      TextFormField(
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              suffixIcon: Icon(Icons.date_range_rounded,
                                  color: Colors.indigo[300]),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 2.0),
                              ),
                              labelText: "mm/dd/yy",
                              fillColor: Colors.white,
                              labelStyle: TextStyle(color: Colors.black45),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blueAccent, width: 2.0))),
                          onChanged: (String s) {}),
                      SizedBox(height: 15),
                      Text("To Date",
                          style:
                              TextStyle(fontSize: 21, color: Colors.black45)),
                      SizedBox(height: 10),
                      TextFormField(
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              suffixIcon: Icon(Icons.date_range_rounded,
                                  color: Colors.indigo[300]),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black, width: 2.0),
                              ),
                              labelText: "mm/dd/yy",
                              fillColor: Colors.white,
                              labelStyle: TextStyle(color: Colors.black45),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blueAccent, width: 2.0))),
                          onChanged: (String s) {}),
                      SizedBox(height: 10),
                      ButtonTheme(
                        height: 50.0,
                        minWidth: 30,
                        child: RaisedButton(
                          color: Colors.indigo[800],
                          elevation: 12,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Filter',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25)),
                                Icon(Icons.filter_alt_outlined,
                                    color: Colors.white, size: 20)
                              ]),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('Total Volume : 16 000 Litters',
                          style: TextStyle(
                              fontSize: 24, color: Colors.indigo[900])),
                      Text('Dept Money : 0 (L.L)',
                          style:
                              TextStyle(fontSize: 24, color: Colors.red[500])),
                      Text('Total Paid : 50 000 (L.L)',
                          style:
                              TextStyle(fontSize: 24, color: Colors.red[500])),
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
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 35,
                            columns: [
                              DataColumn(
                                  label: Text(
                                "Date",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w800),
                              )),
                              DataColumn(
                                  label: Text(
                                "Volume",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w800),
                              )),
                              DataColumn(
                                  label: Text(
                                "Container",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              )),
                              DataColumn(
                                  label: Text(
                                "Provider",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w800),
                              )),
                              DataColumn(
                                  label: Text(
                                "Value(L.L)",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w800),
                              )),
                              DataColumn(
                                  label: Text(
                                "Note",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w800),
                              )),
                              DataColumn(
                                  label: Text(
                                "Payment Date",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w800),
                              )),
                              DataColumn(
                                  label: Text(
                                "Delete",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w800),
                              )),
                            ],
                            rows: const <DataRow>[
                              DataRow(
                                cells: <DataCell>[
                                  DataCell(Text('2021-03-03')),
                                  DataCell(Text('1000.00')),
                                  DataCell(Text('Dieset Cont.')),
                                  DataCell(Text('95 Cont.')),
                                  DataCell(Text('20 000 000')),
                                  DataCell(Text(' ')),
                                  DataCell(Text('2021-03-25')),
                                  DataCell(Icon(Icons.delete,
                                      color: Colors.red, size: 20)),
                                ],
                              ),
                              DataRow(
                                cells: <DataCell>[
                                  DataCell(Text('2021-03-03')),
                                  DataCell(Text('1000.00')),
                                  DataCell(Text('Dieset Cont.')),
                                  DataCell(Text('95 Cont.')),
                                  DataCell(Text('20 000 000')),
                                  DataCell(Text(' ')),
                                  DataCell(Text('2021-03-25')),
                                  DataCell(Icon(Icons.delete,
                                      color: Colors.red, size: 20)),
                                ],
                              ),
                              DataRow(
                                cells: <DataCell>[
                                  DataCell(Text('2021-03-03')),
                                  DataCell(Text('1000.00')),
                                  DataCell(Text('Dieset Cont.')),
                                  DataCell(Text('95 Cont.')),
                                  DataCell(Text('20 000 000')),
                                  DataCell(Text(' ')),
                                  DataCell(Text('2021-03-25')),
                                  DataCell(Icon(Icons.delete,
                                      color: Colors.red, size: 20)),
                                ],
                              ),
                              DataRow(
                                cells: <DataCell>[
                                  DataCell(Text('2021-03-03')),
                                  DataCell(Text('1000.00')),
                                  DataCell(Text('Dieset Cont.')),
                                  DataCell(Text('95 Cont.')),
                                  DataCell(Text('20 000 000')),
                                  DataCell(Text(' ')),
                                  DataCell(Text('2021-03-25')),
                                  DataCell(InkWell(
                                      child: Icon(Icons.delete,
                                          color: Colors.red, size: 20))),
                                ],
                              ),
                            ],
                          )),
                      SizedBox(height: 20),
                      Divider(
                        color: Colors.black,
                      ),
                    ]))
              ],
              backgroundColor: Colors.white,
              initiallyExpanded: false,
            ),
          ),
        ],
      ),
    );
  }
}
