import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_petrol_station/Services/authprovider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Dashboard.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController;
  TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body:Container(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Petrol Station',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w900),
                ),
                SizedBox(width: 20),
                Image(
                  image: AssetImage('assets/fuel.png'),
                  width: 40,
                  height: 40,
                )
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                  controller: _emailController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black, width: 2.0),
                      ),
                      labelText: "User Name",
                      fillColor: Colors.black,
                      labelStyle: TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.blueAccent, width: 2.0))),
                  onChanged: (String s) {}),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                  controller: _passwordController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black, width: 2.0),
                      ),
                      labelText: "Password",
                      fillColor: Colors.black,
                      labelStyle: TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.blueAccent, width: 2.0))),
                  onChanged: (String s) {}),
            ),
            SizedBox(height: 20),
            ButtonTheme(
              height: 50.0,
              minWidth: 170,
              child: RaisedButton(
                  color: Colors.blueAccent,
                  elevation: 12,
                  child: Text('LOGIN',
                      style: TextStyle(color: Colors.white, fontSize: 28)),
                  onPressed: () async {
                    if (_emailController.text.isEmpty ||
                        _passwordController.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Please fill the two feilds !! ",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 13.0);
                      print("Email and password cannot be empty");
                      return;
                    }
                    bool res = await AuthProvider().signInWithEmail(
                        _emailController.text, _passwordController.text);

                    if (!res) {
                      print("Login failed");
                      Fluttertoast.showToast(
                          msg: "Email or password incorrect :(",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 13.0);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Dashboard()),
                      );

                    }
                  }),
            ),
          ]))

      ) ;
  }
}
