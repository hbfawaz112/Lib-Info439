import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_petrol_station/Screens/Add_Container.dart';
import 'package:flutter_petrol_station/Screens/Add_Fuel_Type.dart';
import 'package:flutter_petrol_station/Screens/All_Pumps.dart';
import 'package:flutter_petrol_station/Screens/Container_Detail.dart';
import 'package:flutter_petrol_station/Screens/Dashboard.dart';
import 'package:flutter_petrol_station/Screens/Provider.dart';
import 'package:flutter_petrol_station/Screens/Pump_Records.dart';
import 'package:flutter_petrol_station/Screens/Shipments.dart';
import 'package:flutter_petrol_station/Screens/Voucher.dart';

class getDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: new ListView(children: <Widget>[
      // Text(""),

      new ListTile(
        title: Text(
          "Petrol Station",
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontWeight: FontWeight.w300),
        ),
        onTap: () {
          Navigator.pop(context);
        },
        leading: Image.asset('assets/fuel.png', width: 40, height: 40),
      ),

      Divider(),
      new ListTile(
        title: Text("Dashboard",
            style: TextStyle(
              fontWeight: FontWeight.w300,
              color: Colors.black,
              fontSize: 23,
            )),
        leading: Icon(Icons.home_outlined, color: Colors.grey, size: 35.0),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
            );
        },
      ),
      
      ExpansionTile(
          title: Text("Pumps",
              style: TextStyle(
                  fontSize: 23,
                  color: Colors.black,
                  fontWeight: FontWeight.w300)),
          leading:
              Icon(Icons.ev_station_outlined, color: Colors.grey, size: 35.0),
          trailing:
              Icon(Icons.arrow_drop_down, size: 20, color: Colors.indigo[300]),
          children: [
            
                       InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AllPumps()),
                    );
                  },
                  child:
                  Text('All Pumps' ,style: TextStyle(fontSize: 21, color: Colors.black,fontWeight: FontWeight.w900)),
                ),  
            SizedBox(height: 10),
            StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('Stations').doc('Petrol Station 1').collection('Pump').snapshots(),
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index){
                          DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                          return InkWell(
                  onTap: (){ 

                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Pump_Records(documentSnapshot["Pump_Id"] , documentSnapshot["Pump_Name"] )
                      ),
                    );
                  },
                  child:Center(child:
                  
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(documentSnapshot["Pump_Name"] ,style: TextStyle(fontSize: 21, color: Colors.black,fontWeight: FontWeight.w300)),
                  ),
                  
                ));
                        });}
                        else{
                          return  Center(child:CircularProgressIndicator());
                        }
                        }),
                          
          
          ]
          
          ),
           new ListTile(
          title: Text("Shipments",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.black,
                fontSize: 23,
              )),
          leading: Icon(Icons.directions_bus, color: Colors.grey, size: 35.0),
          onTap: () {
             Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Shipments())
                    );
          },
        ),
        new ListTile(
          title: Text("Voucher",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.black,
                fontSize: 23,
              )),
          leading: Icon(Icons.local_atm, color: Colors.grey, size: 35.0),
          onTap: () {
             Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Voucher())
                    );
          },
        ),
        new ListTile(
          title: Text("Customers",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.black,
                fontSize: 23,
              )),
          leading: Icon(Icons.group_outlined, color: Colors.grey, size: 35.0),
          onTap: () {
            
          },
        ),
        
      ExpansionTile(
          title: Text("Fuel Types",
              style: TextStyle(
                  fontSize: 23,
                  color: Colors.black,
                  fontWeight: FontWeight.w300)),
          leading:
              Icon(Icons.invert_colors, color: Colors.grey, size: 35.0),
          trailing:
              Icon(Icons.arrow_drop_down, size: 20, color: Colors.indigo[300]),
          children: [
            
            StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('Stations').doc('Petrol Station 1').collection('Fuel_Type').snapshots(),
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index){
                          DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                          return InkWell(
                  onTap: (){ },
                  child:Center(child:
                  
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(documentSnapshot["Fuel_Type_Name"] ,style: TextStyle(fontSize: 21, color: Colors.black,fontWeight: FontWeight.w300)),
                  ),
                  
                ));
                        });}
                        else{
                          return  Center(child:CircularProgressIndicator());
                        }
                        }),


                        InkWell(
                          onTap: (){
                             Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>AddFuelType()));
                          },
                          child: Text("Add Type" ,style: TextStyle(fontSize: 21, color: Colors.black,fontWeight: FontWeight.w700))),
                          
          
          ]
          
          ),
           new ListTile(
          title: Text("Accounting",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.black,
                fontSize: 23,
              )),
          leading: Icon(Icons.monetization_on_outlined,
              color: Colors.grey, size: 35.0),
          onTap: () {
            
          },
        ),
        new ListTile(
          title: Text("Provider",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.black,
                fontSize: 23,
              )),
          leading: Icon(Icons.supervisor_account_sharp,
              color: Colors.grey, size: 35.0),
          onTap: () {
             Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>Providers()));
          },
        ),
ExpansionTile(
          title: Text("Containers",
              style: TextStyle(
                  fontSize: 23,
                  color: Colors.black,
                  fontWeight: FontWeight.w300)),
          leading:
              Icon(Icons.gradient, color: Colors.grey, size: 35.0),
          trailing:
              Icon(Icons.arrow_drop_down, size: 20, color: Colors.indigo[300]),
          children: [
            
            StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('Stations').doc('Petrol Station 1').collection('Container').snapshots(),
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index){
                          DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                          return InkWell(
                  onTap: (){ 
                     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                       Container_Details(documentSnapshot["Container_Id"],documentSnapshot["Container_Name"])),
                    );

                  },
                  child:Center(child:
                  
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Container "+documentSnapshot["Container_Name"] ,style: TextStyle(fontSize: 21, color: Colors.black,fontWeight: FontWeight.w300)),
                  ),
                  
                ));
                        });}
                        else{
                          return  Center(child:CircularProgressIndicator());
                        }
                        }),


                       InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddContainer_Firestore()),
                    );
                  },
                  child:
                  Text('Add Container' ,style: TextStyle(fontSize: 21, color: Colors.black,fontWeight: FontWeight.w900)),
                ),  
          
          ]
          
          ),
          Divider(),
      
       
    ]));
  }
}
