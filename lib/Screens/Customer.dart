import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_petrol_station/Services/cloud_services.dart';
import 'package:flutter_petrol_station/Widgets/Drawer.dart';

class Cutomers extends StatefulWidget {
  @override
  _CutomersState createState() => _CutomersState();
}

class _CutomersState extends State<Cutomers> {
  // String dropdownValue = 'One';

  int last_doc_id;

 
  //too : defin contorller
  TextEditingController t1 = new TextEditingController();
  TextEditingController t2 = new TextEditingController();
  TextEditingController t3 = new TextEditingController();

  TextEditingController t4 = new TextEditingController();
  TextEditingController t5 = new TextEditingController();
  TextEditingController t6 = new TextEditingController();

  // for date and value of pay off transaction
  TextEditingController t7 = new TextEditingController();
  TextEditingController t8 = new TextEditingController();

  int sumvouchervalue = 0;
  int sumtransactionvalue = 0;
  int totaldept = 1;
  int total_dept_to_text;

  int customer_id;
  String phone, email;

  int last_transaction_id;

  bool visible_buttons = false;

  int state_table = 0;

  String sum_transaction_title = "";
  String sum_voucher_title = "";

  String customer_category; //for the dropdownbutton
  User loggedInUser;
  String customer_drop;
  CloudServices cloudServices =
      CloudServices(FirebaseFirestore.instance, FirebaseAuth.instance);

  String station;

  @override
  void initState() {
    super.initState();
    loggedInUser = cloudServices.getCurrentUser();
    asyncMethod();
    // totalDept();
  }

  void asyncMethod() async {
    // we do this to call a fct that need async wait when calling it;
    // when aiming to use the fct in initState
    if (loggedInUser != null) {
      station = await cloudServices.getUserStation(loggedInUser);
      totalDept();
    }
    setState(() {});
    // hay l setState bhotta ekher shi bl fct yalle btrajj3 shi future krml yn3amal rebuild
    // krml yontor l data yalle 3m trj3 mn l firestore bs n3aytla ll method
  }

  void add_customer() async {
    //get the last custumer id
    await FirebaseFirestore.instance
        .collection('Stations')
        .doc(station)
        .collection('Customer')
        .orderBy('Customer_Id', descending: true)
        .get()
        .then((val) => {
              if (val.docs.length > 0)
                {
                  last_doc_id = val.docs[0].get("Customer_Id"),
                  print('last id is  : ${last_doc_id}')
                }
              else
                {print("Not Found")}
            });

    await FirebaseFirestore.instance
        .collection('Stations')
        .doc(station)
        .collection('Customer')
        .doc((last_doc_id + 1).toString())
        .set({
      'Customer_Id': last_doc_id + 1,
      'Customer_Name': t1.text,
      'Phone': t2.text,
      'Email': t3.text,
    });
    print('done addedd');
  }

  //fuction get all dept mony to all customer:

  void totalDept() async {
    await FirebaseFirestore.instance
        .collection('Stations')
        .doc(station)
        .collection('Voucher')
        .get()
        .then((val) => {
              //print(val),
              if (val.docs.length > 0)
                {
                  //print("lengthhhhhhhhhhh"),
                  // print(val.docs.length),
                  for (var i = 0; i < val.docs.length; i++)
                    {
                      // print("valueeeeeeeeeeeee"),

                      print(val.docs[i].get("Voucher_Value")),
                      sumvouchervalue =
                          sumvouchervalue + val.docs[i].get("Voucher_Value"),
                    },

                  print('sum of voucher val is ${sumvouchervalue} ')
                }
              else
                {print("Not Foundddddddddddddddddddd")}
            });
    await FirebaseFirestore.instance
        .collection('Stations')
        .doc(station)
        .collection('Transaction')
        .get()
        .then((val) => {
              //print(val),
              if (val.docs.length > 0)
                {
                  //print("lengthhhhhhhhhhh"),
                  // print(val.docs.length),
                  for (var i = 0; i < val.docs.length; i++)
                    {
                      // print("valueeeeeeeeeeeee"),

                      print(val.docs[i].get("Transaction_Value")),
                      sumtransactionvalue = sumtransactionvalue +
                          val.docs[i].get("Transaction_Value"),
                    },

                  print('sum of transaction val is ${sumtransactionvalue} ')
                }
              else
                {print("Not Foundddddddddddddddddddd")}
            });

    totaldept = sumvouchervalue - sumtransactionvalue;
    setState(() {
      total_dept_to_text = totaldept;
    });
    print("Totla dep :: ${totaldept}");
  }

  void Customer_selected(String newValue) async {
    setState(() {
      customer_drop = newValue;
    });

    //get the id of the selected customer :
    await FirebaseFirestore.instance
        .collection('Stations')
        .doc(station)
        .collection('Customer')
        .where('Customer_Name', isEqualTo: customer_drop)
        .get()
        .then((val) => {
              if (val.docs.length > 0)
                {
                  customer_id = val.docs[0].get("Customer_Id"),
                  phone = val.docs[0].get('Phone'),
                  email = val.docs[0].get('Email'),
                  print("select customer has id ${customer_id}")
                }
              else
                {print("Not Found")}
            });

    //get the total dept for this id

    await FirebaseFirestore.instance
        .collection('Stations')
        .doc(station)
        .collection('Voucher')
        .where('Customer_Id', isEqualTo: customer_id)
        .get()
        .then((val) => {
              //print(val),
              if (val.docs.length > 0)
                {
                  //print("lengthhhhhhhhhhh"),
                  // print(val.docs.length),
                  for (var i = 0; i < val.docs.length; i++)
                    {
                      // print("valueeeeeeeeeeeee"),

                      print(val.docs[i].get("Voucher_Value")),
                      sumvouchervalue =
                          sumvouchervalue + val.docs[i].get("Voucher_Value"),
                    },

                  print('sum of voucher val is ${sumvouchervalue} ')
                }
              else
                {print("Not Foundddddddddddddddddddd")}
            });
    await FirebaseFirestore.instance
        .collection('Stations')
        .doc(station)
        .collection('Transaction')
        .where('Customer_Id', isEqualTo: customer_id)
        .get()
        .then((val) => {
              //print(val),
              if (val.docs.length > 0)
                {
                  //print("lengthhhhhhhhhhh"),
                  // print(val.docs.length),
                  for (var i = 0; i < val.docs.length; i++)
                    {
                      // print("valueeeeeeeeeeeee"),

                      print(val.docs[i].get("Transaction_Value")),
                      sumtransactionvalue = sumtransactionvalue +
                          val.docs[i].get("Transaction_Value"),
                    },

                  print('sum of transaction val is ${sumtransactionvalue} ')
                }
              else
                {print("Not Foundddddddddddddddddddd")}
            });

    totaldept = sumvouchervalue - sumtransactionvalue;
    setState(() {
      total_dept_to_text = totaldept;
    });
    print("Totla dep :: ${totaldept}");
    setState(() {
      visible_buttons = true;
    });

    setState(() {
      sum_transaction_title =
          "Transaction (Total Paid : ${sumtransactionvalue})";
      sum_voucher_title = "Voucher (Total voucher : ${sumvouchervalue})";
    });
  }

  ViewshowAlertDialog(BuildContext context) {
    t4.text = customer_drop;
    t5.text = phone;
    t6.text = email;
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Customer Information",
          style: TextStyle(fontSize: 25, color: Colors.red)),
      content: Column(children: [
        SizedBox(height: 20),
        Text("Name", style: TextStyle(fontSize: 21, color: Colors.black45)),
        SizedBox(height: 10),
        TextFormField(
            controller: t4,
            enabled: false,
            enableInteractiveSelection: false,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 2.0),
                ),
                fillColor: Colors.white,
                //labelStyle: TextStyle(color: Colors.black45),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 2.0))),
            onChanged: (String s) {}),
        SizedBox(height: 15),
        Text("Phone", style: TextStyle(fontSize: 21, color: Colors.black45)),
        SizedBox(height: 10),
        TextFormField(
            controller: t5,
            enabled: false,
            enableInteractiveSelection: false,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 2.0),
                ),
                //labelText: phone,
                fillColor: Colors.white,
                labelStyle: TextStyle(color: Colors.black45),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 2.0))),
            onChanged: (String s) {}),
        SizedBox(height: 15),
        Text("Email", style: TextStyle(fontSize: 21, color: Colors.black45)),
        SizedBox(height: 10),
        TextFormField(
            controller: t6,
            enabled: false,
            enableInteractiveSelection: false,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 2.0),
                ),
                //labelText: email,
                fillColor: Colors.white,
                labelStyle: TextStyle(color: Colors.black45),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 2.0))),
            onChanged: (String s) {}),
        SizedBox(height: 22),
        ButtonTheme(
          height: 50.0,
          minWidth: 130,
          child: RaisedButton(
            color: Colors.indigo[800],
            elevation: 12,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.library_add_check_outlined,
                  size: 22, color: Colors.white),
              SizedBox(
                width: 14,
              ),
              Text('OK', style: TextStyle(color: Colors.white, fontSize: 25)),
            ]),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ]),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  EditshowAlertDialog(BuildContext context) {
    t4.text = customer_drop;
    t5.text = phone;
    t6.text = email;
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Edit Customer",
          style: TextStyle(fontSize: 25, color: Colors.red)),
      content: Column(children: [
        SizedBox(height: 20),
        Text("Name", style: TextStyle(fontSize: 21, color: Colors.black45)),
        SizedBox(height: 10),
        TextFormField(
            controller: t4,
            //  enabled: false,
            //enableInteractiveSelection: false,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 2.0),
                ),
                fillColor: Colors.white,
                //labelStyle: TextStyle(color: Colors.black45),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 2.0))),
            onChanged: (String s) {}),
        SizedBox(height: 15),
        Text("Phone", style: TextStyle(fontSize: 21, color: Colors.black45)),
        SizedBox(height: 10),
        TextFormField(
            controller: t5,
            // enabled: false,
            //enableInteractiveSelection: false,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 2.0),
                ),
                //labelText: phone,
                fillColor: Colors.white,
                labelStyle: TextStyle(color: Colors.black45),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 2.0))),
            onChanged: (String s) {}),
        SizedBox(height: 15),
        Text("Email", style: TextStyle(fontSize: 21, color: Colors.black45)),
        SizedBox(height: 10),
        TextFormField(
            controller: t6,
            // enabled: false,
            // enableInteractiveSelection: false,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 2.0),
                ),
                //labelText: email,
                fillColor: Colors.white,
                labelStyle: TextStyle(color: Colors.black45),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 2.0))),
            onChanged: (String s) {}),
        SizedBox(height: 22),
        ButtonTheme(
          height: 50.0,
          minWidth: 130,
          child: RaisedButton(
            color: Colors.indigo[800],
            elevation: 12,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.library_add_check_outlined,
                  size: 22, color: Colors.white),
              SizedBox(
                width: 14,
              ),
              Text('Edit', style: TextStyle(color: Colors.white, fontSize: 25)),
            ]),
            onPressed: () {
              Edit_cutomer();
            },
          ),
        ),
        SizedBox(height: 15),
        ButtonTheme(
          height: 50.0,
          minWidth: 130,
          child: RaisedButton(
            color: Colors.indigo[800],
            elevation: 12,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.library_add_check_outlined,
                  size: 22, color: Colors.white),
              SizedBox(
                width: 14,
              ),
              Text('Cancel',
                  style: TextStyle(color: Colors.white, fontSize: 25)),
            ]),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ]),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  PayoffshowAlertDialog(BuildContext context) {
    t8.text = DateTime.now().toString();

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Pay OFF", style: TextStyle(fontSize: 25, color: Colors.red)),
      content: Column(children: [
        SizedBox(height: 20),
        Text("Value", style: TextStyle(fontSize: 21, color: Colors.black45)),
        SizedBox(height: 10),
        TextFormField(
            controller: t7,
            //  enabled: false,
            //enableInteractiveSelection: false,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 2.0),
                ),
                fillColor: Colors.white,
                //labelStyle: TextStyle(color: Colors.black45),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 2.0))),
            onChanged: (String s) {}),
        SizedBox(height: 15),
        Text("Date", style: TextStyle(fontSize: 21, color: Colors.black45)),
        SizedBox(height: 10),
        TextFormField(
            controller: t8,
            // enabled: false,
            //enableInteractiveSelection: false,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 2.0),
                ),
                //labelText: phone,
                fillColor: Colors.white,
                labelStyle: TextStyle(color: Colors.black45),
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 2.0))),
            onChanged: (String s) {}),
        ButtonTheme(
          height: 50.0,
          minWidth: 130,
          child: RaisedButton(
            color: Colors.indigo[800],
            elevation: 12,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.library_add_check_outlined,
                  size: 22, color: Colors.white),
              SizedBox(
                width: 14,
              ),
              Text('Pay', style: TextStyle(color: Colors.white, fontSize: 25)),
            ]),
            onPressed: () {
              pay_transaction();
              sleep(Duration(seconds: 2));
              Navigator.pop(context);
            },
          ),
        ),
        SizedBox(height: 15),
        ButtonTheme(
          height: 50.0,
          minWidth: 130,
          child: RaisedButton(
            color: Colors.indigo[800],
            elevation: 12,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.library_add_check_outlined,
                  size: 22, color: Colors.white),
              SizedBox(
                width: 14,
              ),
              Text('Cancel',
                  style: TextStyle(color: Colors.white, fontSize: 25)),
            ]),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ]),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void Edit_cutomer() async {
    print('..........${t4.text}.............');
    print('..........${t5.text}.............');
    print('..........${t6.text}.............');

    await FirebaseFirestore.instance
        .collection('Stations')
        .doc(station)
        .collection('Customer')
        .doc('${customer_id}')
        .update({'Customer_Name': t4.text, 'Phone': t5.text, 'Email': t6.text});

    setState(() {});
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => super.widget));
  }

  void pay_transaction() async {
    // get last transation id
    await FirebaseFirestore.instance
        .collection('Stations')
        .doc(station)
        .collection('Transaction')
        .orderBy('Transaction_Id', descending: true)
        .get()
        .then((val) => {
              if (val.docs.length > 0)
                {
                  last_transaction_id = val.docs[0].get("Transaction_Id"),
                  print('last id is  : ${last_transaction_id}')
                }
              else
                {print("Not Found")}
            });
    await FirebaseFirestore.instance
        .collection('Stations')
        .doc(station)
        .collection('Transaction')
        .doc((last_transaction_id + 1).toString())
        .set({
      'Customer_Id': customer_id,
      'Transaction_Date': DateTime.parse(t8.text),
      'Transaction_Id': last_transaction_id + 1,
      'Transaction_Value': int.parse(t7.text)
    });
    print('done addedd');
    Customer_selected(customer_drop);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    sumvouchervalue = 0;
    sumtransactionvalue = 0;
    totaldept = 0;
    // totalDept();

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
                title: Text("Add Customer",
                    style: TextStyle(fontSize: 29, color: Colors.indigo[300])),
                trailing: Icon(Icons.arrow_drop_down,
                    size: 20, color: Colors.indigo[300]),
                children: [
                  Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(children: [
                        SizedBox(height: 20),
                        Text("Name",
                            style:
                                TextStyle(fontSize: 21, color: Colors.black45)),
                        SizedBox(height: 10),
                        TextFormField(
                            controller: t1,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black, width: 2.0),
                                ),
                                labelText: "Customer Name",
                                fillColor: Colors.white,
                                labelStyle: TextStyle(color: Colors.black45),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blueAccent, width: 2.0))),
                            onChanged: (String s) {}),
                        SizedBox(height: 15),
                        Text("Phone",
                            style:
                                TextStyle(fontSize: 21, color: Colors.black45)),
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
                                        color: Colors.blueAccent, width: 2.0))),
                            onChanged: (String s) {}),
                        SizedBox(height: 15),
                        Text("Email",
                            style:
                                TextStyle(fontSize: 21, color: Colors.black45)),
                        SizedBox(height: 10),
                        TextFormField(
                            controller: t3,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black, width: 2.0),
                                ),
                                labelText: "example@example.com",
                                fillColor: Colors.white,
                                labelStyle: TextStyle(color: Colors.black45),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blueAccent, width: 2.0))),
                            onChanged: (String s) {}),
                        SizedBox(height: 22),
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
                              add_customer();
                            },
                          ),
                        ),
                      ]))
                ],
                backgroundColor: Colors.white,
                initiallyExpanded: false,
              )),

          /*********************************************************/
          SizedBox(height: 15),
          Card(
              elevation: 12,
              child: ExpansionTile(
                  title: Text("Customer Info",
                      style:
                          TextStyle(fontSize: 29, color: Colors.indigo[300])),
                  trailing: Icon(Icons.arrow_drop_down,
                      size: 20, color: Colors.indigo[300]),
                  children: [
                    Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(children: [
                          Text("Customer Name",
                              style: TextStyle(
                                  fontSize: 21, color: Colors.black45)),
                          SizedBox(height: 10),
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('Stations')
                                .doc(station)
                                .collection('Customer')
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                return Container(
                                  width: 350.0,
                                  height: 58,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1.0, style: BorderStyle.solid),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: customer_drop,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: const TextStyle(
                                          color: Colors.deepPurple),
                                      underline: Container(
                                        height: 2,
                                        color: Colors.deepPurpleAccent,
                                      ),
                                      hint: Center(
                                          child: Text('Select Customer',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight:
                                                      FontWeight.w400))),
                                      onChanged: (String newValue) {
                                        Customer_selected(newValue);
                                      },
                                      items: snapshot.data != null
                                          ? snapshot.data.docs
                                              .map((DocumentSnapshot document) {
                                              return new DropdownMenuItem<
                                                      String>(
                                                  value: document
                                                      .get('Customer_Name')
                                                      .toString(),
                                                  child: new Container(
                                                    child: Center(
                                                      child: new Text(
                                                        document
                                                            .get(
                                                                'Customer_Name')
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
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
                          SizedBox(
                            height: 17,
                          ),
                          Row(
                            children: [
                              Text('Total Dept : ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 27)),
                              Text('${total_dept_to_text} (L.L.)',
                                  style: TextStyle(
                                      color: Colors.black38,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 24)),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Visibility(
                            visible: visible_buttons,
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ButtonTheme(
                                    height: 50.0,
                                    minWidth: 100,
                                    child: RaisedButton(
                                      color: Color(0xFF083369),
                                      elevation: 6,
                                      child: Text('View',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 19)),
                                      onPressed: () {
                                        ViewshowAlertDialog(context);
                                      },
                                    ),
                                  ),
                                  ButtonTheme(
                                    height: 50.0,
                                    minWidth: 100,
                                    child: RaisedButton(
                                      color: Color(0xFF083369),
                                      elevation: 6,
                                      child: Text('Edit',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 19)),
                                      onPressed: () {
                                        EditshowAlertDialog(context);
                                      },
                                    ),
                                  ),
                                  ButtonTheme(
                                    height: 50.0,
                                    minWidth: 100,
                                    child: RaisedButton(
                                      color: Color(0xFF083369),
                                      elevation: 6,
                                      child: Text('Pay Off',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 19)),
                                      onPressed: () {
                                        PayoffshowAlertDialog(context);
                                      },
                                    ),
                                  ),
                                ]),
                          ),
                          SizedBox(
                            height: 26,
                          ),
                          Text("From Date",
                              style: TextStyle(
                                  fontSize: 21, color: Colors.black45)),
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
                                          color: Colors.blueAccent,
                                          width: 2.0))),
                              onChanged: (String s) {}),
                          SizedBox(height: 15),
                          Text("To Date",
                              style: TextStyle(
                                  fontSize: 21, color: Colors.black45)),
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
                                          color: Colors.blueAccent,
                                          width: 2.0))),
                              onChanged: (String s) {}),
                          SizedBox(height: 20),
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
                          Divider(thickness: 3, color: Colors.black45),
                          SizedBox(height: 12),
                          ExpansionTile(
                              title: Text(sum_transaction_title,
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.indigo[300])),
                              trailing: Icon(Icons.arrow_drop_down,
                                  size: 20, color: Colors.indigo[300]),
                              children: [
                                Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Column(children: [
                                      SizedBox(height: 5),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: customer_drop == null
                                            ? Text('No data')
                                            : StreamBuilder(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('Stations')
                                                    .doc(station)
                                                    .collection('Transaction')
                                                    .where('Customer_Id',
                                                        isEqualTo: customer_id)
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  return snapshot.hasData
                                                      ? new datatable(
                                                          snapshot.data.docs)
                                                      : Text('No data');
                                                },
                                              ),
                                      ),
                                    ]))
                              ]),
                          SizedBox(height: 10),
                          ExpansionTile(
                              title: Text(sum_voucher_title,
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.indigo[300])),
                              trailing: Icon(Icons.arrow_drop_down,
                                  size: 20, color: Colors.indigo[300]),
                              children: [
                                Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Column(children: [
                                      SizedBox(height: 5),
                                      TextFormField(
                                          style: TextStyle(color: Colors.black),
                                          decoration: InputDecoration(
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.black,
                                                    width: 2.0),
                                              ),
                                              labelText: "Search Here",
                                              fillColor: Colors.white,
                                              labelStyle: TextStyle(
                                                  color: Colors.black45),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.blueAccent,
                                                      width: 2.0))),
                                          onChanged: (String s) {}),
                                      SizedBox(height: 5),
                                      SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: DataTable(
                                            columnSpacing: 35,
                                            columns: [
                                              DataColumn(
                                                  label: Text(
                                                "Fuel Type",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              )),
                                              DataColumn(
                                                  label: Text(
                                                "Voucher Value",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              )),
                                              DataColumn(
                                                  label: Text(
                                                "Voucher Date",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              )),
                                              DataColumn(
                                                  label: Text(
                                                "Note",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              )),
                                              DataColumn(
                                                  label: Text(
                                                "Delete",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )),
                                            ],
                                            rows: const <DataRow>[
                                              DataRow(
                                                cells: <DataCell>[
                                                  DataCell(Text('95')),
                                                  DataCell(Text('60 000.00')),
                                                  DataCell(Text(
                                                      '2021-03-03 12:15:43')),
                                                  DataCell(Text('')),
                                                  DataCell(Icon(Icons.delete,
                                                      color: Colors.red,
                                                      size: 20)),
                                                ],
                                              ),
                                              DataRow(
                                                cells: <DataCell>[
                                                  DataCell(Text('95')),
                                                  DataCell(Text('20 000.00')),
                                                  DataCell(Text(
                                                      '2021-03-01 2:25:03')),
                                                  DataCell(Text('Some note')),
                                                  DataCell(Icon(Icons.delete,
                                                      color: Colors.red,
                                                      size: 20)),
                                                ],
                                              ),
                                            ],
                                          )),
                                    ]))
                              ]),
                        ]))
                  ]))
        ]));
  }
}

class datatable extends StatelessWidget {
  List list;
  datatable(List list) {
    this.list = list;
  }
@override
  Widget build(BuildContext context) {
    return Expanded(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child:
              DataTable(
                columns:[ 
            DataColumn(label: Text("Value",style: TextStyle(fontSize:16,fontWeight: FontWeight.w800),)),
            DataColumn(label: Text("Date",style: TextStyle(fontSize:16,fontWeight: FontWeight.w800),)),
            DataColumn(label: Text("Delete",style: TextStyle(fontSize:16,fontWeight: FontWeight.w500),)),
            ],
            rows:list.map((transaction) => DataRow(
              cells:[
                DataCell(
                   Text('${transaction["Transaction_Value"]}'),
                ),
                DataCell(
                   Text('${ DateTime.tryParse( (transaction["Transaction_Date"]).toDate().toString())}'),
                ),
                DataCell(
                   IconButton(
                                                          icon: const Icon(
                                                              Icons.delete),
                                                          color: Colors.red,
                                                          onPressed: () {},
                                                        ),
                ),
              ] 
              )).toList(),

              )
            )));
  }
}
