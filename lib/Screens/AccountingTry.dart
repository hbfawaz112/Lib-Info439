import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_petrol_station/Widgets/Drawer.dart';
import 'package:intl/intl.dart';

class AccountingTry extends StatefulWidget {
  @override
  _AccountingTryState createState() => _AccountingTryState();
}

class _AccountingTryState extends State<AccountingTry> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    asyncmeth();
    // print('IN BUILD ${fuel_types[1].name.toString()}');
  }

  void asyncmeth() async {
    await getarrayoffueltypes();
    setState(() {
      dropdownValue = fuel_types[0].name.toString();
    });
  }

  String dropdownValue;
  int pumpid;
  int lastrecord;
  int totalbill = 0, totalprofit = 0;
  int sumrecords;
  DateTime dt;
  int price = 0, profit = 0;
  var formatter = NumberFormat('#,##,000');
  int button_type = -1;
  bool isloading = false;
  DateTime last_record_date;
  int previous_record_id;
  int contid; // for get the container id for specific pump
  String contname; //get container
  int calculationprofit, calculationprice;
  Fuel F;
  int previous_record;
  int idob;
  String nameob;
  var fuel_types;
  int pumpidtdy;
  TextEditingController t1 = new TextEditingController();
  TextEditingController t2 = new TextEditingController();
  int cont_id;
  String cont_name;

  DateTime lastpricedate, lastprofitdate;
  DateTime datetimetoday = DateTime.now();
  DateFormat ff;
  DateTime todayy;
  int container_id_tdy;
  int totalbilltdy = 0, totalprofittoday = 0;
  int lastpricetdy, lastprofittdy;
  int previous_price, previous_profit;
  DateTime previous_price_date;
  int sum_littres = 0;
  int record_id, record_value;

  DateTime T1, T2;
  List<DateTime> AllDateTime;

  DateTime last_pump_record_timestamp;

  void getarrayoffueltypes() async {
    fuel_types = new List<Fuel>();
    fuel_types.add(new Fuel(0, "All Fuel Type"));
    await FirebaseFirestore.instance
        .collection("Stations")
        .doc("Petrol Station 1")
        .collection("Fuel_Type")
        .get()
        .then((val) => {
              for (int i = 0; i < val.docs.length; i++)
                {
                  idob = val.docs[i].get("Fuel_Type_Id"),
                  nameob = val.docs[i].get("Fuel_Type_Name").toString(),
                  F = new Fuel(idob, nameob),
                  print("OBJECTTT ${F.name}"),
                  fuel_types.add(F),
                },
            });
    print(fuel_types);
  }

  void gettoday() async {
    sum_littres = 0;
    totalbilltdy = 0;
    totalprofittoday = 0;
    int cont_id;
    String cont_name;
    if (dropdownValue == "All Fuel Type") {
      await FirebaseFirestore.instance
          .collection('Stations')
          .doc("Petrol Station 1")
          .collection('Container')
          .get()
          .then((val) async => {
                if (val.docs.length > 0)
                  {
                    for (int k = 0; k < val.docs.length; k++)
                      {
                        sum_littres = 0,
                        cont_id = val.docs[k].get("Container_Id"),
                        cont_name = val.docs[k].get("Container_Name"),
                        print("Contttttttainerrrrrrrrrr name: $cont_name"),
                        await FirebaseFirestore.instance
                            .collection('Stations')
                            .doc("Petrol Station 1")
                            .collection('Pump')
                            .where('Container_Id', isEqualTo: cont_id)
                            .get()
                            .then((val3) async => {
                                  if (val3.docs.length > 0)
                                    {
                                      for (int l = 0; l < val3.docs.length; l++)
                                        {
                                          //foreach pump get all pump records
                                          pumpidtdy =
                                              val3.docs[l].get("Pump_Id"),
                                          print("pump id: $pumpidtdy"),
                                          await FirebaseFirestore.instance
                                              .collection("Stations")
                                              .doc("Petrol Station 1")
                                              .collection("Pump_Record")
                                              .where("Container_Id",
                                                  isEqualTo: cont_id)
                                              .where("Pump_Id",
                                                  isEqualTo: pumpidtdy)
                                              .where("Record_Time",
                                                  isGreaterThanOrEqualTo:
                                                      todayy)
                                              .orderBy("Record_Time",
                                                  descending: true)
                                              .get()
                                              .then((val1) async => {
                                                    if (val1.docs.length > 0)
                                                      {
                                                        //loop over all pump records
                                                        //foreach pump record get its date
                                                        //and then get the last price-profit where price-profit date
                                                        //smaller than the record date
                                                        for (int y = 0;
                                                            y <
                                                                val1.docs
                                                                    .length;
                                                            y++)
                                                          {
                                                            record_value = val1
                                                                .docs[y]
                                                                .get("Record"),
                                                            record_id = val1
                                                                .docs[y]
                                                                .get(
                                                                    "Pump_Record_Id"),
                                                            print(
                                                                "recordd iddd : $record_id"),
                                                            print(
                                                                "record value : $record_value"),
                                                            last_pump_record_timestamp =
                                                                DateTime.tryParse((val1
                                                                        .docs[y]
                                                                        .get(
                                                                            "Record_Time"))
                                                                    .toDate()
                                                                    .toString()),
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'Stations')
                                                                .doc(
                                                                    "Petrol Station 1")
                                                                .collection(
                                                                    'Price-Profit')
                                                                .where(
                                                                    'Fuel_Type_Id',
                                                                    isEqualTo:
                                                                        cont_name)
                                                                .where('Date',
                                                                    isLessThanOrEqualTo:
                                                                        last_pump_record_timestamp)
                                                                .orderBy('Date',
                                                                    descending:
                                                                        true)
                                                                .get()
                                                                .then(
                                                                    (value) async =>
                                                                        {
                                                                          if (value.docs.length >
                                                                              0)
                                                                            {
                                                                              lastpricetdy = value.docs[0].get("Official_Price"),
                                                                              lastprofittdy = value.docs[0].get("Official_Profit"),
                                                                              lastpricedate = DateTime.tryParse((value.docs[0].get("Date")).toDate().toString()),
                                                                              print("price-profit date $lastpricedate < last record $last_pump_record_timestamp"),
                                                                              print('Dateeeeeeeeeeeeee ${lastpricedate}'),
                                                                              print('priceeeeeee ${lastpricetdy}'),
                                                                              print('profittttt ${lastprofittdy}'),
                                                                              if (val1.docs[y].get("Pump_Record_Id") == 1)
                                                                                {
                                                                                  totalbilltdy = totalbilltdy + (val1.docs[y].get("Record") * lastpricetdy),
                                                                                  totalprofittoday = totalprofittoday + (val1.docs[y].get("Record") * lastprofittdy),
                                                                                  sum_littres = sum_littres + val1.docs[y].get("Record"),
                                                                                  print("Torla billll a ${totalbilltdy}"),
                                                                                  print("Torla profittt a ${totalprofittoday}"),
                                                                                }
                                                                              else
                                                                                {
                                                                                  await FirebaseFirestore.instance.collection("Stations").doc("Petrol Station 1").collection("Pump_Record").where("Container_Id", isEqualTo: cont_id).where("Pump_Id", isEqualTo: pumpidtdy).orderBy("Pump_Record_Id").get().then((value1) => {
                                                                                        if (value1.docs.length > 0)
                                                                                          {
                                                                                            for (int t = 0; t < value1.docs.length; t++)
                                                                                              {
                                                                                                if (value1.docs[t] == record_id)
                                                                                                  {
                                                                                                    if (t == 0)
                                                                                                      {
                                                                                                        previous_record_id = 0,
                                                                                                        previous_record = 0,
                                                                                                      }
                                                                                                    else
                                                                                                      {
                                                                                                        previous_record_id = value1.docs[y - 1].get("Pump_Record_Id"),
                                                                                                        print("previous idddd ${previous_record_id}"),
                                                                                                        previous_record = value1.docs[y - 1].get("Record"),
                                                                                                        print("previous record ${previous_record}"),
                                                                                                        //totalbilltdy = totalbilltdy + ((val1.docs[y].get("Record") - previous_record) * lastpricetdy),
                                                                                                        //totalprofittoday = totalprofittoday + ((val1.docs[y].get("Record") - previous_record) * lastprofittdy),
                                                                                                        //sum_littres = sum_littres + (val1.docs[y].get("Record") - previous_record),
                                                                                                       // print("Torla billll a ${totalbilltdy}"),
                                                                                                       // print("Torla profittt a ${totalprofittoday}"),
                                                                                                      },
                                                                                                    totalbilltdy = totalbilltdy + ((val1.docs[y].get("Record") - previous_record) * lastpricetdy),
                                                                                                    totalprofittoday = totalprofittoday + ((val1.docs[y].get("Record") - previous_record) * lastprofittdy),
                                                                                                  }
                                                                                                //  else{
                                                                                                //continue,}
                                                                                              },
                                                                                            //if (value1.docs.length > 1)
                                                                                            //{
                                                                                            //previous_record_id = value1.docs[value1.docs.length - 2].get("Pump_Record_Id"),
                                                                                            //print("previous idddd ${previous_record_id}"),
                                                                                            //previous_record = value1.docs[value1.docs.length - 2].get("Record"),
                                                                                            //print("previous record ${previous_record}"),
                                                                                            //totalbilltdy = totalbilltdy + ((val1.docs[y].get("Record") - previous_record) * lastpricetdy),
                                                                                            //totalprofittoday = totalprofittoday + ((val1.docs[y].get("Record") - previous_record) * lastprofittdy),
                                                                                            //sum_littres = sum_littres + (val1.docs[y].get("Record") - previous_record),
                                                                                            //print("Torla billll a ${totalbilltdy}"),
                                                                                            //print("Torla profittt a ${totalprofittoday}"),
                                                                                            //}
                                                                                            //else
                                                                                            //{
                                                                                            //sum_littres = sum_littres + val1.docs[y].get("Record"),
                                                                                            //totalbilltdy = totalbilltdy + ((val1.docs[y].get("Record")) * lastpricetdy),
                                                                                            //totalprofittoday = totalprofittoday + ((val1.docs[y].get("Record")) * lastprofittdy),
                                                                                            //print("Torla billll a ${totalbilltdy}"),
                                                                                            //print("Torla profittt a ${totalprofittoday}"),
                                                                                            //}
                                                                                          }
                                                                                      }),
                                                                                },
                                                                            }
                                                                        }),
                                                          }
                                                      }
                                                  }),
                                        }
                                    }
                                }),
                      },
                    print("total billlll $totalbilltdy"),
                  }
              });
    } else {
      print("elseee specificccccc");
      sum_littres = 0;
      //cont_id = val.docs[k].get("Container_Id"),
      cont_name = dropdownValue;
      print("contanier nameeeeeeeee: $cont_name");
      await FirebaseFirestore.instance
          .collection('Stations')
          .doc("Petrol Station 1")
          .collection('Pump')
          .where('Container_Id', isEqualTo: dropdownValue)
          .get()
          .then((vv) async => {
                if (vv.docs.length > 0)
                  {
                    cont_id = vv.docs[0].get("Container_Id"),
                    print("Contttttttainerrrrrrrrrr name: $cont_name"),
                    await FirebaseFirestore.instance
                        .collection('Stations')
                        .doc("Petrol Station 1")
                        .collection('Pump')
                        .where('Container_Id', isEqualTo: cont_name)
                        .get()
                        .then((val3) async => {
                              if (val3.docs.length > 0)
                                {
                                  for (int l = 0; l < val3.docs.length; l++)
                                    {
                                      //foreach pump get all pump records
                                      pumpidtdy = val3.docs[l].get("Pump_Id"),
                                      print("pump id: $pumpidtdy"),
                                      await FirebaseFirestore.instance
                                          .collection("Stations")
                                          .doc("Petrol Station 1")
                                          .collection("Pump_Record")
                                          .where("Container_Id",
                                              isEqualTo: cont_id)
                                          .where("Pump_Id",
                                              isEqualTo: pumpidtdy)
                                          .where("Record_Time",
                                              isGreaterThanOrEqualTo: todayy)
                                          .orderBy("Record_Time",
                                              descending: true)
                                          .get()
                                          .then((val1) async => {
                                                if (val1.docs.length > 0)
                                                  {
                                                    //loop over all pump records
                                                    //foreach pump record get its date
                                                    //and then get the last price-profit where price-profit date
                                                    //smaller than the record date
                                                    for (int y = 0;
                                                        y < val1.docs.length;
                                                        y++)
                                                      {
                                                        record_value = val1
                                                            .docs[y]
                                                            .get("Record"),
                                                        record_id = val1.docs[y]
                                                            .get(
                                                                "Pump_Record_Id"),
                                                        print(
                                                            "recordd iddd : $record_id"),
                                                        print(
                                                            "record value : $record_value"),
                                                        last_pump_record_timestamp =
                                                            DateTime.tryParse(
                                                                (val1.docs[y].get(
                                                                        "Record_Time"))
                                                                    .toDate()
                                                                    .toString()),
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'Stations')
                                                            .doc(
                                                                "Petrol Station 1")
                                                            .collection(
                                                                'Price-Profit')
                                                            .where(
                                                                'Fuel_Type_Id',
                                                                isEqualTo:
                                                                    cont_name)
                                                            .where('Date',
                                                                isLessThanOrEqualTo:
                                                                    last_pump_record_timestamp)
                                                            .orderBy('Date',
                                                                descending:
                                                                    true)
                                                            .get()
                                                            .then(
                                                                (value) async =>
                                                                    {
                                                                      if (value
                                                                              .docs
                                                                              .length >
                                                                          0)
                                                                        {
                                                                          lastpricetdy = value
                                                                              .docs[0]
                                                                              .get("Official_Price"),
                                                                          lastprofittdy = value
                                                                              .docs[0]
                                                                              .get("Official_Profit"),
                                                                          lastpricedate = DateTime.tryParse((value.docs[0].get("Date"))
                                                                              .toDate()
                                                                              .toString()),
                                                                          print(
                                                                              "price-profit date $lastpricedate < last record $last_pump_record_timestamp"),
                                                                          print(
                                                                              'Dateeeeeeeeeeeeee ${lastpricedate}'),
                                                                          print(
                                                                              'priceeeeeee ${lastpricetdy}'),
                                                                          print(
                                                                              'profittttt ${lastprofittdy}'),
                                                                          print(
                                                                              "val1111111 record id"),
                                                                          print(val1
                                                                              .docs[y]
                                                                              .get('Pump_Record_Id')),
                                                                          if (val1.docs[y].get('Pump_Record_Id') ==
                                                                              1)
                                                                            {
                                                                              totalbilltdy = totalbilltdy + (val1.docs[y].get("Record") * lastpricetdy),
                                                                              totalprofittoday = totalprofittoday + (val1.docs[y].get("Record") * lastprofittdy),
                                                                              sum_littres = sum_littres + val1.docs[y].get("Record"),
                                                                              print("Torla billll a ${totalbilltdy}"),
                                                                              print("Torla profittt a ${totalprofittoday}"),
                                                                            }
                                                                          else
                                                                            {
                                                                              print("elsee record id ==== $record_id"),
                                                                              await FirebaseFirestore.instance.collection("Stations").doc("Petrol Station 1").collection("Pump_Record").where("Pump_Id", isEqualTo: pumpidtdy).where("Container_Id", isEqualTo: cont_id).orderBy("Pump_Record_Id").get().then((value1) => {
                                                                                    if (value1.docs.length > 0)
                                                                                      {
                                                                                        print("pump records to get previous"),
                                                                                        for (int t = 0; t < value1.docs.length; t++)
                                                                                          {
                                                                                            print("for loopp"),
                                                                                            if (value1.docs[t] == record_id)
                                                                                              {
                                                                                                print("equall record id"),
                                                                                                if (t == 0)
                                                                                                  {
                                                                                                    print("t == 0"),
                                                                                                    previous_record_id = 0,
                                                                                                    previous_record = 0,
                                                                                                  }
                                                                                                else
                                                                                                  {
                                                                                                    print("t not 0000"),
                                                                                                    previous_record_id = value1.docs[value1.docs.length - 2].get("Pump_Record_Id"),
                                                                                                    print("previous idddd ${previous_record_id}"),
                                                                                                    previous_record = value1.docs[value1.docs.length - 2].get("Record"),
                                                                                                    print("previous record ${previous_record}"),
                                                                                                    totalbilltdy = totalbilltdy + ((val1.docs[y].get("Record") - previous_record) * lastpricetdy),
                                                                                                    totalprofittoday = totalprofittoday + ((val1.docs[y].get("Record") - previous_record) * lastprofittdy),
                                                                                                    sum_littres = sum_littres + (val1.docs[y].get("Record") - previous_record),
                                                                                                    print("Torla billll a ${totalbilltdy}"),
                                                                                                    print("Torla profittt a ${totalprofittoday}"),
                                                                                                  }
                                                                                              }

                                                                                            //else{continue,}
                                                                                          }
                                                                                      },
                                                                                    //if (value1.docs.length > 1)
                                                                                    //{
                                                                                    //previous_record_id = value1.docs[value1.docs.length - 2].get("Pump_Record_Id"),
                                                                                    //print("previous idddd ${previous_record_id}"),
                                                                                    //previous_record = value1.docs[value1.docs.length - 2].get("Record"),
                                                                                    //print("previous record ${previous_record}"),
                                                                                    //totalbilltdy = totalbilltdy + ((val1.docs[y].get("Record") - previous_record) * lastpricetdy),
                                                                                    //totalprofittoday = totalprofittoday + ((val1.docs[y].get("Record") - previous_record) * lastprofittdy),
                                                                                    //sum_littres = sum_littres + (val1.docs[y].get("Record") - previous_record),
                                                                                    //print("Torla billll a ${totalbilltdy}"),
                                                                                    //print("Torla profittt a ${totalprofittoday}"),
                                                                                    //}
                                                                                    //else
                                                                                    //{
                                                                                    //sum_littres = sum_littres + val1.docs[y].get("Record"),
                                                                                    //totalbilltdy = totalbilltdy + ((val1.docs[y].get("Record")) * lastpricetdy),
                                                                                    //totalprofittoday = totalprofittoday + ((val1.docs[y].get("Record")) * lastprofittdy),
                                                                                    //print("Torla billll a ${totalbilltdy}"),
                                                                                    //print("Torla profittt a ${totalprofittoday}"),
                                                                                    //}
                                                                                  }),
                                                                            },
                                                                        }
                                                                    }),
                                                      }
                                                  }
                                              }),
                                    }
                                }
                            }),
                  }
              });
    }
  }

  @override
  Widget build(BuildContext context) {
    // getarrayoffueltypes();
    ff = DateFormat('yyyy/MM/dd');
    todayy = ff.parse(ff.format(DateTime.now()));
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
                    Container(
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
                                items: fuel_types
                                    .map<DropdownMenuItem<String>>((f) {
                                  print(f.name.toString());
                                  return new DropdownMenuItem<String>(
                                      value: f.name.toString(),
                                      child: new Container(
                                        child: Center(
                                          child: new Text(
                                            '${f.name.toString()}',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ));
                                }).toList()))),
                    SizedBox(height: 15),
                    Text("From Date",
                        style: TextStyle(fontSize: 21, color: Colors.black45)),
                    SizedBox(height: 10),
                    TextFormField(
                        controller: t1,
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
                        controller: t2,
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
                              onPressed: () {
                                //submitbtn();
                              },
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
                              onPressed: () {
                                gettoday();
                              },
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
                                // getlastreacord();
                              },
                            ),
                          ),
                        ]),
                    SizedBox(height: 10),
                  ]),
                )),
            SizedBox(height: 10),
            // totalbill;
            isloading == true
                ? CircularProgressIndicator()
                : button_type == 3
                    ? TotalCard(totalbill, totalprofit)
                    : Text(""),
          ],
        ));
  }
}

class TotalCard extends StatefulWidget {
  int bill, profit;
  TotalCard(int bill, int profit) {
    this.bill = bill;
    this.profit = profit;
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
          decoration:
              BoxDecoration(border: Border.all(width: 4, color: Colors.green)),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Total',
                      style: TextStyle(fontSize: 35, color: Color(0xFF083369))),
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
                        style: TextStyle(fontSize: 22, color: Colors.green)),
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
                        style: TextStyle(fontSize: 22, color: Colors.green)),
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

class Fuel {
  int id;
  String name;
  Fuel(int id, String name) {
    this.id = id;
    this.name = name;
  }
}

class specificfuel {}
