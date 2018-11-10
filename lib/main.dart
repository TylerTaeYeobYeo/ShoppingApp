import 'package:flutter/material.dart';

void main() => runApp(RouteApp());

class RouteApp extends StatefulWidget {
  @override
  RouteState createState() => RouteState();
}

class RouteState extends State<RouteApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Main',
      home: LoginPage(),
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.black,
      ),
      initialRoute: '/login',
      routes:{
        '/login': (context) => LoginPage(),
      },
    );
  }
}

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new LoginState();
}

class LoginState extends State<LoginPage>{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: Center(
        child: Text("hi"),
      ),
    );
  }
}