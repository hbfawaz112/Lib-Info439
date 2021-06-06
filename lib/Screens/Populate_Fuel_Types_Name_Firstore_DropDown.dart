import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_petrol_station/services/cloud_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Populate_Fuel_Types_Name_Firstore_DropDown extends StatefulWidget {
  Populate_Fuel_Types_Name_Firstore_DropDown({Key key}) : super(key: key);

  @override
  _Populate_Fuel_Types_Name_Firstore_DropDownState createState() =>
      _Populate_Fuel_Types_Name_Firstore_DropDownState();
}

class _Populate_Fuel_Types_Name_Firstore_DropDownState
    extends State<Populate_Fuel_Types_Name_Firstore_DropDown> {
  String station;
  User loggedInUser;

  int Fuel_Type_Id;
  var category;
  String result = "result";

  CloudServices cloudServices =
      CloudServices(FirebaseFirestore.instance, FirebaseAuth.instance);

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
    }
    setState(() {});
    // hay l setState bhotta ekher shi bl fct yalle btrajj3 shi future krml yn3amal rebuild
    // krml yontor l data yalle 3m trj3 mn l firestore bs n3aytla ll method
  }

  void getId() async {
    // print(category);
    var s = await FirebaseFirestore.instance
        .collection('Stations')
        .doc(station)
        .collection('Fuel_Type')
        .where('Fuel_Name', isEqualTo: category)
        .get()
        .then((val) => {
              if (val.docs.length > 0)
                {
                  // print(val.docs[0].get("Fuel_Type_Id")),

                  Fuel_Type_Id = val.docs[0].get("Fuel_Type_Id"),
                  print('Fuel Type id of ${category} is ${Fuel_Type_Id}')
                }
              else
                {print("Not Found")}
            });

    setState(() {
      result = 'Fuel Type id of ${category} is ${Fuel_Type_Id}';
    });
    // print(s.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test dropdown firstore'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Stations')
                  .doc(station)
                  .collection('Fuel_Type')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  Center(
                    child: const CupertinoActivityIndicator(),
                  );

                return Container(
                    width: 350.0,
                    height: 58,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1.0, style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.black45),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      value: category,
                      isDense: true,
                      hint: Text('Fuel Type'),
                      onChanged: (newValue) {
                        setState(() {
                          category = newValue;
                        });
                      },
                      items: snapshot.data != null
                          ? snapshot.data.docs.map((DocumentSnapshot document) {
                              return new DropdownMenuItem<String>(
                                  value: document.get('Fuel_Name').toString(),
                                  child: new Container(
                                    // height: 20.0,

                                    //color: primaryColor,

                                    child: Center(
                                      child: new Text(
                                        document.get('Fuel_Name').toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900),
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
          SizedBox(height: 12),
          ButtonTheme(
            height: 50.0,
            minWidth: 130,
            child: RaisedButton(
              color: Colors.indigo[800],
              elevation: 12,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.library_add_check_outlined,
                    size: 22, color: Colors.white),
                SizedBox(
                  width: 14,
                ),
                Text('Save',
                    style: TextStyle(color: Colors.white, fontSize: 25)),
              ]),
              onPressed: () {
                getId();
              },
            ),
          ),
          SizedBox(height: 12),
          Text(result,
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600))
        ],
      ),
    );
  }
}
