import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_petrol_station/Widgets/Drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Providers extends StatefulWidget {
  @override
  _ProvidersState createState() => _ProvidersState();
}

class _ProvidersState extends State<Providers> {
  String dropdownValue = 'IPT';
  TextEditingController t1 = new TextEditingController();
  TextEditingController t2 = new TextEditingController();
  int last_provider_id;
  int new_provider_id;

  String selecting_provider;
  TextEditingController t3 = new TextEditingController();
  TextEditingController t4 = new TextEditingController();
  int selected_provider_id;
  String selected_Phone;

  bool isfilled=true;

  bool add_privder_name_error=false;

  bool add_privder_phone_error=false;

  void addProvider() async {
    // get the last prover id
    await FirebaseFirestore.instance
        .collection('Stations')
        .doc('Petrol Station 1')
        .collection('Provider')
        .orderBy('Provider_Id', descending: true)
        .get()
        .then((val) => {
              if (val.docs.length > 0)
                {
                  last_provider_id = val.docs[0].get("Provider_Id"),
                  print('last id is  : ${last_provider_id}')
                }
              else
                {print("Not Found")}
            });

    new_provider_id = last_provider_id + 1;

    FirebaseFirestore.instance
        .collection('Stations')
        .doc('Petrol Station 1')
        .collection('Provider')
        .doc(new_provider_id.toString())
        .set({
      'Provider_Id': new_provider_id,
      'Provider_Name': t1.text,
      'Provider_Phone': t2.text,
    });
    print('done addedd');
  }

  void Provider_changed(newValue) async {
    setState(() {
      selecting_provider = newValue;
      print('${selecting_provider}');
    });
    //get the provider id where provider_name=selecting_provider
       await FirebaseFirestore.instance
        .collection('Stations')
        .doc('Petrol Station 1')
        .collection('Provider')
        .where('Provider_Name', isEqualTo: selecting_provider)
        .get()
        .then((val) => {
              if (val.docs.length > 0)
                {
                  selected_provider_id = val.docs[0].get("Provider_Id"),
                  print("select provider has id : ${selected_provider_id}"),
                  
                }
              else
                {print("Not Found")}
            });
    //get the phone number where providername=newValue
    await FirebaseFirestore.instance
        .collection('Stations')
        .doc('Petrol Station 1')
        .collection('Provider')
        .where('Provider_Id', isEqualTo: selected_provider_id)
        .get()
        .then((val) => {
              if (val.docs.length > 0)
                {
                  selected_Phone = val.docs[0].get("Provider_Phone"),
                  print("select provider has phone number : ${selected_Phone}"),
                  
                    setState(() {
                        isfilled=false;
                        
                    }),
                        t3.text=selecting_provider,
                        t4.text=selected_Phone,
                        

                }
              else
                {print("Not Found")}
            });

     }
     void update_provider() async {

         FirebaseFirestore.instance
        .collection('Stations')
        .doc('Petrol Station 1')
        .collection('Provider')
        .doc('${selected_provider_id}')
        .update({'Provider_Name':t3.text,'Provider_Phone':t4.text});
      print('Provider updated');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => super.widget));
     }

  @override
  Widget build(BuildContext context) {
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
        drawer: getDrawer(),
        body: ListView(children: [
          Card(
              elevation: 12,
              child: ExpansionTile(
                  title: Text("Add Provider",
                      style:
                          TextStyle(fontSize: 29, color: Colors.indigo[300])),
                  trailing: Icon(Icons.arrow_drop_down,
                      size: 20, color: Colors.indigo[300]),
                  children: [
                    Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(children: [
                          SizedBox(height: 20),
                          Text("Provider Name",
                              style: TextStyle(
                                  fontSize: 21, color: Colors.black45)),
                          SizedBox(height: 10),
                          TextFormField(
                              controller: t1,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 2.0),
                                  ),
                                  labelText: "Provider Name",
                                  fillColor: Colors.white,
                                  labelStyle: TextStyle(color: Colors.black45),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blueAccent,
                                          width: 2.0))),
                              onChanged: (String s) {}),
                          SizedBox(height: 15),
                          Text("Provider Phone",
                              style: TextStyle(
                                  fontSize: 21, color: Colors.black45)),
                          SizedBox(height: 10),
                          TextFormField(
                              controller: t2,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 2.0),
                                  ),
                                  labelText: "ex:01111111",
                                  fillColor: Colors.white,
                                  labelStyle: TextStyle(color: Colors.black45),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blueAccent,
                                          width: 2.0))),
                              onChanged: (String s) {}),
                          SizedBox(height: 15),
                          ButtonTheme(
                            height: 50.0,
                            minWidth: 130,
                            child: RaisedButton(
                              color: Colors.indigo[800],
                              elevation: 12,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.library_add_check_outlined,
                                        size: 22, color: Colors.white),
                                    SizedBox(
                                      width: 14,
                                    ),
                                    Text('Save',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 25)),
                                  ]),
                              onPressed: () {
                                addProvider();
                              },
                            ),
                          ),
                        ]))
                  ])),
          SizedBox(height: 16),
          Card(
              elevation: 12,
              child: ExpansionTile(
                  title: Text("Provider Info",
                      style:
                          TextStyle(fontSize: 29, color: Colors.indigo[300])),
                  trailing: Icon(Icons.arrow_drop_down,
                      size: 20, color: Colors.indigo[300]),
                  children: [
                    Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(children: [
                          Divider(),
                          SizedBox(height: 20),
                          Text("Select Provider",
                              style: TextStyle(
                                  fontSize: 21, color: Colors.black45)),
                          SizedBox(height: 10),
                          StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('Stations')
                                  .doc('Petrol Station 1')
                                  .collection('Provider')
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (!snapshot.hasData)
                                  Center(
                                    child: const CupertinoActivityIndicator(),
                                  );

                                return Container(
                                    width: 350.0,
                                    height: 58,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            width: 1.0,
                                            style: BorderStyle.solid),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                      ),
                                    ),
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: const TextStyle(
                                          color: Colors.black45),

                                      value: selecting_provider,
                                      //isDense: true,
                                      hint: Text('Fuel Type'),
                                      onChanged: (newValue) {
                                        Provider_changed(newValue);
                                      },
                                      items: snapshot.data != null
                                          ? snapshot.data.docs
                                              .map((DocumentSnapshot document) {
                                              return new DropdownMenuItem<
                                                      String>(
                                                  value: document
                                                      .get('Provider_Name')
                                                      .toString(),
                                                  child: new Container(
                                                    // height: 20.0,

                                                    //color: primaryColor,

                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 7, left: 8),
                                                      child: new Text(
                                                        document
                                                            .get(
                                                                'Provider_Name')
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900),
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
                                    ));
                              }),
                          SizedBox(height: 20),
                          Text("Provider Name",
                              style: TextStyle(
                                  fontSize: 21, color: Colors.black45)),
                          SizedBox(height: 10),
                          TextFormField(
                              controller: t3,
                             // enableInteractiveSelection: false,
                              focusNode: FocusNode(),
                              //readOnly: true,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 2.0),
                                  ),
                                  labelText: "Provider Name",
                                  fillColor: Colors.black12,
                                  filled: isfilled,
                                  labelStyle: TextStyle(color: Colors.black45),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blueAccent,
                                          width: 2.0))),
                              onChanged: (String s) {}),
                          SizedBox(height: 15),
                          Text("Provider Phone",
                              style: TextStyle(
                                  fontSize: 21, color: Colors.black45)),
                          SizedBox(height: 10),
                          TextFormField(
                              controller: t4,
                             // enableInteractiveSelection: false,
                              focusNode: FocusNode(),
                              //readOnly: true,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 2.0),
                                  ),
                                  labelText: "01000000",
                                  fillColor: Colors.black12,
                                  filled: isfilled,
                                  labelStyle: TextStyle(color: Colors.black45),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blueAccent,
                                          width: 2.0))),
                              onChanged: (String s) {}),
                          SizedBox(height: 15),
                          ButtonTheme(
                            height: 50.0,
                            minWidth: 130,
                            child: RaisedButton(
                              color: Colors.indigo[800],
                              elevation: 12,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.edit,
                                        size: 22, color: Colors.white),
                                    SizedBox(
                                      width: 14,
                                    ),
                                    Text('Edit',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 25)),
                                  ]),
                              onPressed: () {update_provider();},
                            ),
                          ),
                        ]))
                  ])),
        ]));
  }
}
