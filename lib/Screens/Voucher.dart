import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_petrol_station/Widgets/Drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Voucher extends StatefulWidget {
  @override
  _VoucherState createState() => _VoucherState();
}

class _VoucherState extends State<Voucher> {
  String dropdownValue = 'One';
  var fuel_type;
  var customer_name;
  int Fuel_Type_Id;
  int Customer_Id;
  int last_voucher_id;
  TextEditingController t1= new TextEditingController();
  TextEditingController t2= new TextEditingController();
  TextEditingController t3= new TextEditingController();

  void Add_Voucher() async {
          //get the fueul_type_id of the selected fuel type
          await FirebaseFirestore.instance
        .collection('Stations')
        .doc('Petrol Station 1')
        .collection('Fuel_Type')
        .where('Fuel_Type_Name', isEqualTo: fuel_type)
        .get()
        .then((val) => {
              if (val.docs.length > 0)
                {
                  // print(val.docs[0].get("Fuel_Type_Id")),

                  Fuel_Type_Id = val.docs[0].get("Fuel_Type_Id"),
                  print('the fuel type id of selected one is ${Fuel_Type_Id}')
                }
              else
                {print("Not Found")}
            });

          //get the customer id  of the selected customer name
            await FirebaseFirestore.instance
        .collection('Stations')
        .doc('Petrol Station 1')
        .collection('Customer')
        .where('Customer_Name', isEqualTo: customer_name)
        .get()
        .then((val) => {
              if (val.docs.length > 0)
                {
                  // print(val.docs[0].get("Fuel_Type_Id")),

                  Customer_Id = val.docs[0].get("Customer_Id"),
                  print('the Customer id of selected one is ${Customer_Id}')
                }
              else
                {print("Not Found")}
            });

          //get the last voucher id in firstore and add 1 to it:
             await FirebaseFirestore.instance
        .collection('Stations')
        .doc('Petrol Station 1')
        .collection('Voucher')
        .orderBy('Voucher_Id',descending: true)
        .get()
        .then((val) => {
              if (val.docs.length > 0)
                {
                  last_voucher_id = val.docs[0].get("Voucher_Id"),
                  print('last voucher id is  : ${last_voucher_id}')
                }
              else
                {print("Not Found")}
            });

      
    FirebaseFirestore.instance
        .collection('Stations')
        .doc('Petrol Station 1')
        .collection('Voucher')
        .doc( (last_voucher_id+1).toString())
        .set({
      'Voucher_Id': last_voucher_id+1,
      'Customer_Id': Customer_Id,
      'Fuel_Type_Id': Fuel_Type_Id,
      'Note':t3.text,
      'Voucher_Date': DateTime.parse(t2.text),
      'Voucher_Value':int.parse(t1.text)
    });

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
        body: ListView(
          children: [
            SizedBox(
              height: 10,
            ),
            Text('  Vouchers',
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
                child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        Text("Fuel Type",
                            style:
                                TextStyle(fontSize: 21, color: Colors.black45)),
                        SizedBox(height: 10),
                       StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('Stations')
                                .doc('Petrol Station 1')
                                .collection('Fuel_Type')
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
                                          width: 1.0, style: BorderStyle.solid),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                    ),
                                  ),
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    iconSize: 24,
                                    elevation: 16,
                                    style:
                                        const TextStyle(color: Colors.black45),

                                    value: fuel_type,
                                    //isDense: true,
                                    hint: Text('Fuel Type'),
                                    onChanged: (newValue) {
                                      setState(() {
                                        fuel_type = newValue;
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
                                                  // height: 20.0,

                                                  //color: primaryColor,

                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 7, left: 8),
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
                                  ));
                            }),
                        SizedBox(height: 15),
                        Text("Voucher Value (L.L)",
                            style:
                                TextStyle(fontSize: 21, color: Colors.black45)),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: t1,
                          keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black, width: 2.0),
                                ),
                                labelText: "value (L.L)",
                                fillColor: Colors.white,
                                labelStyle: TextStyle(color: Colors.black45),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blueAccent, width: 2.0))),
                            onChanged: (String s) {}),
                        SizedBox(height: 10),
                        Text("Customer Name",
                            style:
                                TextStyle(fontSize: 21, color: Colors.black45)),
                        SizedBox(height: 10),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('Stations')
                                .doc('Petrol Station 1')
                                .collection('Customer')
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
                                          width: 1.0, style: BorderStyle.solid),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                    ),
                                  ),
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    iconSize: 24,
                                    elevation: 16,
                                    style:
                                        const TextStyle(color: Colors.black45),

                                    value: customer_name,
                                    //isDense: true,
                                    hint: Text('Customer Name'),
                                    onChanged: (newValue) {
                                      setState(() {
                                        customer_name = newValue;
                                      });
                                    },
                                    items: snapshot.data != null
                                        ? snapshot.data.docs
                                            .map((DocumentSnapshot document) {
                                            return new DropdownMenuItem<String>(
                                                value: document
                                                    .get('Customer_Name')
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
                                                          .get('Customer_Name')
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
                                  ));
                            }),
                        SizedBox(height: 15),
                        Text("Voucher Date",
                            style:
                                TextStyle(fontSize: 21, color: Colors.black45)),
                        SizedBox(height: 10),
                        TextFormField(
                           controller: t2,
                            keyboardType: TextInputType.datetime,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                suffixIcon: Icon(Icons.date_range_rounded,
                                    color: Colors.indigo[300]),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black, width: 2.0),
                                ),
                                labelText: DateTime.now().toString(),
                                fillColor: Colors.white,
                                labelStyle: TextStyle(color: Colors.black45),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blueAccent, width: 2.0))),
                            onChanged: (String s) {}),
                        SizedBox(height: 15),
                        TextFormField(
                           controller: t3,
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
                            onChanged: (String s) {}),
                        SizedBox(height: 18),
                        ButtonTheme(
                          height: 50.0,
                          minWidth: 130,
                          child: RaisedButton(
                            color: Colors.indigo[800],
                            elevation: 12,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.my_library_add_outlined,
                                      color: Colors.white, size: 20),
                                  Text('Add',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25)),
                                ]),
                            onPressed: () {Add_Voucher();},
                          ),
                        ),
                      ],
                    )))
          ],
        ));
  }
}
