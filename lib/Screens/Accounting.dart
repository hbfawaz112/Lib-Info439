import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_petrol_station/Widgets/Drawer.dart';
import 'package:intl/intl.dart';

class Accounting extends StatefulWidget {
  @override
  _AccountingState createState() => _AccountingState();
}

class _AccountingState extends State<Accounting> {
  String dropdownValue;
  int pumpid;
  int lastrecord;
  int totalbill = 0, totalprofit = 0;
  int sumrecords;
  DateTime dt;
  int price=0, profit=0;
  var formatter = NumberFormat('#,##,000');
  int button_type=-1;
  bool isloading=false;

  int contid; // for get the container id for specific pump
  String contname; //get container
  int calculationprofit, calculationprice;
  void getlastreacord() async {
      setState(() {
       
        isloading=true;
      });
   await FirebaseFirestore.instance
        .collection("Stations")
        .doc("Petrol Station 1")
        .collection("Pump")
        .get()
        .then((val) async => {
              if (val.docs.length > 0)
                {
                  print("Fet 1"),
                  for (int i = 0; i < val.docs.length; i++)
                    {
                      pumpid = val.docs[i].get("Pump_Id"),

                      contid = val.docs[i].get("Container_Id"),
                       print('pumpidddddddddddddddddddd ${pumpid}'),
                        print('contiddddddddddddddddddd ${contid}'),
                       await FirebaseFirestore.instance
                              .collection('Stations')
                              .doc("Petrol Station 1")
                              .collection('Container')
                              .where('Container_Id', isEqualTo: contid)
                              
                              .get()
                              .then((val) async =>  {
                                    contname = val.docs[0].get("Container_Name"),
                                    print("Nameee in theeeennnnn ${contname}")
                                  }),
                     // getContainerName(contid),
                      print('NAmeeeeeeeeeeeeeeeeeeeee ${contname}'),
                    await  FirebaseFirestore.instance
                          .collection('Stations')
                          .doc("Petrol Station 1")
                          .collection('Pump_Record')
                          .where('Pump_Id', isEqualTo: pumpid)
                          .orderBy('Pump_Record_Id', descending: true)
                          .get()
                          .then((val) async => {
                                if (val.docs.length > 0)
                                  { print("FETTTTTTTTTTTTTTTTTTTTTTT2"),
                                    lastrecord = val.docs[0].get("Record"),
                                    print("Lasttttttttttttttttt record ${lastrecord}"),
                                    dt = DateTime.tryParse(
                                        (val.docs[0].get("Record_Time"))
                                            .toDate()
                                            .toString()),
                                   
                                   await FirebaseFirestore.instance
                                                    .collection('Stations')
                                                    .doc("Petrol Station 1")
                                                    .collection('Price-Profit')
                                                    .where('Fuel_Type_Id' , isEqualTo: contname)
                                                    .where('Date', isLessThan: val.docs[0].get("Record_Time"))
                                                  
                                                    .get()
                                                    .then((val) => {
                                                       if(val.docs.length>0){
                                                          setState((){
                                                            price = val.docs[val.docs.length - 1].get("Official_Price");
                                                           calculationprice = lastrecord * price;
                                                          }),
                                                          
                                                          print("get it price : ${price}")
                                                       }
                                                        }),
                                                        
                                        await FirebaseFirestore.instance
                                                    .collection('Stations')
                                                    .doc("Petrol Station 1")
                                                    .collection('Price-Profit')
                                                    .where('Fuel_Type_Id' , isEqualTo: contname)
                                                    .where('Date', isLessThan: val.docs[0].get("Record_Time"))
                                                  
                                                    .get()
                                                    .then((val) => {
                                                        if(val.docs.length>0){
                                                          setState((){
                                                            profit = val.docs[val.docs.length - 1].get("Official_Profit");
                                                         calculationprofit = lastrecord * profit; }),
                                                          
                                                          print("get it profit : ${profit}")}
                                                        }),
                                   
                                    print(
                                        "calculationpriceeeeeeeeeeeeeeeeeeeeee : ${calculationprice}"),
                                    print(
                                        "calculationprofittttttttttttttttttt : ${calculationprofit}"),
                                  }
                                else
                                  {
                                    print("elseeeee"),
                                  }
                              }),
                      totalbill = totalbill + calculationprice,
                      totalprofit = totalprofit + calculationprofit,
                    }
                }
            });

      setState(() {
       isloading=false;
        button_type=3;
        totalbill;
        totalprofit;
      });


    print("Total bill is ${totalbill}");
    print("Total profit is ${totalprofit}");
  }

  void getpricedate(Timestamp ts , String fuelname) async {
    print("Fuellll nameeeeeee fct is ${fuelname}");

    await FirebaseFirestore.instance
        .collection('Stations')
        .doc("Petrol Station 1")
        .collection('Price-Profit')
        .where('Fuel_Type_Id' , isEqualTo: fuelname)
        .where('Date', isLessThan: ts)
      
        .get()
        .then((val) => {
              setState((){
                price = val.docs[val.docs.length - 1].get("Official_Price");
              
              }),
              
              print("get it price : ${price}")
            });
  }

  void getprofitdate(Timestamp ts, String fuelname) async {
    
    print("Fuellll nameeeeeee fct is ${fuelname}");

   await FirebaseFirestore.instance
        .collection('Stations')
        .doc("Petrol Station 1")
        .collection('Price-Profit')
        .where('Fuel_Type_Id' , isEqualTo: fuelname)
        .where('Date', isLessThan: ts)
         .get()
        .then((val) => {
             
           print('idddddddddddddddddddd${val.docs[val.docs.length - 1].get("Price_Profit_Id")}'),
             
           setState((){
                profit = val.docs[val.docs.length - 1].get("Official_Profit");
              
              }),
              
              print("get it price : ${profit}")
            });
  }

/* getContainerName(int contId) async {
    FirebaseFirestore.instance
        .collection('Stations')
        .doc("Petrol Station 1")
        .collection('Container')
        .where('Container_Id', isEqualTo: contId)
        
        .get()
        .then((val) => {
              contname = val.docs[0].get("Container_Name"),
            });
  }*/

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
            Card(
                elevation: 12,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(children: [
                    SizedBox(height: 15),
                    Text("Fuel Type",
                        style: TextStyle(fontSize: 21, color: Colors.black45)),
                    SizedBox(height: 10),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Stations')
                          .doc("Petrol Station 1")
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
                                    BorderRadius.all(Radius.circular(15.0)),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: dropdownValue,
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 24,
                                elevation: 16,
                                style:
                                    const TextStyle(color: Colors.deepPurple),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    dropdownValue = newValue;
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
                                                          FontWeight.w400),
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
                    Text("From Date",
                        style: TextStyle(fontSize: 21, color: Colors.black45)),
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
                        style: TextStyle(fontSize: 21, color: Colors.black45)),
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
                    Divider(height: 10, thickness: 2, color: Colors.grey),
                    SizedBox(height: 10),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ButtonTheme(
                            height: 50.0,
                            minWidth: 100,
                            child: RaisedButton(
                              color: Color(0xFF083369),
                              elevation: 6,
                              child: Text('Submit',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 19)),
                              onPressed: () {},
                            ),
                          ),
                          ButtonTheme(
                            height: 50.0,
                            minWidth: 100,
                            child: RaisedButton(
                              color: Color(0xFF083369),
                              elevation: 6,
                              child: Text('Today',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 19)),
                              onPressed: () {},
                            ),
                          ),
                          ButtonTheme(
                            height: 50.0,
                            minWidth: 100,
                            child: RaisedButton(
                              color: Color(0xFF083369),
                              elevation: 6,
                              child: Text('Last Record',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 19)),
                              onPressed: () {
                                getlastreacord();
                              },
                            ),
                          ),
                        ]),
                    SizedBox(height: 10),
                  ]),
                )),
            SizedBox(height: 10),
            // totalbill;
       
           isloading==true?CircularProgressIndicator():button_type==3?TotalCard(totalbill,totalprofit):Text(""),
           
          ],
        ));
  }
}



class TotalCard extends StatefulWidget {

    int bill,profit;
    TotalCard(int bill,int profit){
        this.bill=bill;
        this.profit=profit;
    }

  @override
  _TotalCardState createState() => _TotalCardState();
}

class _TotalCardState extends State<TotalCard> {
   var formatter = NumberFormat('###,###,###');

  @override
  Widget build(BuildContext context) {
    return Padding(
                padding: EdgeInsets.all(7),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 4, color: Colors.green)),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Text('Total',
                              style: TextStyle(
                                  fontSize: 35, color: Color(0xFF083369))),
                        ),
                      ),
                      SizedBox(height: 10),
                      Card(
                          child: Column(children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Text('Bill',
                                style: TextStyle(
                                    fontSize: 22, color: Colors.green)),
                          ),
                        ),
                        SizedBox(height: 30),
                        
                        Text('${formatter.format(widget.bill)}L.L',
                            style: TextStyle(fontSize: 35, color: Colors.green))
                      ])),
                      SizedBox(height: 10),
                      Card(
                          child: Column(children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Text('Profit',
                                style: TextStyle(
                                    fontSize: 22, color: Colors.green)),
                          ),
                        ),
                        SizedBox(height: 30),
                        Text('${formatter.format(widget.profit)}L.L',
                            style: TextStyle(fontSize: 35, color: Colors.green))
                      ]))
                    ],
                  ),
                ));
  }
}
