import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_petrol_station/models/Shipment.dart';
import 'package:flutter_petrol_station/Screens/dashboard_firstore.dart';
import 'package:flutter_petrol_station/Screens/pump_records.dart';
import 'package:flutter_petrol_station/Screens/shipments.dart';
import 'package:flutter_petrol_station/Screens/login.dart';
import 'package:flutter_petrol_station/Screens/containers.dart';
import 'package:flutter_petrol_station/Screens/dashboard_firstore.dart';
import 'package:flutter_petrol_station/Screens/All_Pumps.dart';
import 'package:flutter_petrol_station/Screens/Voucher.dart';
import 'package:flutter_petrol_station/Screens/Add_Fuel_Type.dart';
import 'package:flutter_petrol_station/Screens/Provider.dart';
import 'package:flutter_petrol_station/screens/Container_Detail.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Petrol Station',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Login.id,
      routes: {
        Login.id: (context) => Login(),
        Containers.id: (context) => Containers(),
        Dashboard_Firstore.id: (context) => Dashboard_Firstore(),
        Pump_Records.id: (context) => Pump_Records(),
        Shipments.id: (context) => Shipments(),
        AllPumps.id: (context) => AllPumps(),
        Voucher.id: (context) => Voucher(),
        AddFuelType.id: (context) => AllPumps(),
        Providers.id: (context) => Providers(),
        //Container_Details.idd: (context) => Container_Details()
      },
    );
  }
}
