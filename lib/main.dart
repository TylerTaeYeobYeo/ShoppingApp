import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './global/currentUser.dart' as cu;

import 'home.dart';

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
      home: HomePage(),
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.black,
      ),
      initialRoute: '/login',
      onGenerateRoute: _getRoute,
      routes:{
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
      },
    );
  }

  Route<dynamic> _getRoute(RouteSettings settings) {
    if (settings.name != '/login') {
      return null;
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => LoginPage(),
      fullscreenDialog: true,
    );
  }
}

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new LoginState();
}

class LoginState extends State<LoginPage>{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  Future<FirebaseUser> _googleSignIn()  async {
    GoogleSignInAccount googleSignInAccount = await cu.currentUser.getGoogleLogIn().signIn().catchError((e)=>print(e));
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    
    FirebaseUser user = await _auth.signInWithGoogle(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken
    );
    // print(user);
    await Firestore.instance.collection('users').document(user.uid).setData({
      "uid":user.uid,
      "displayName": user.displayName,
      "photoUrl": user.photoUrl,
      "email": user.email,
      "phoneNumber":user.phoneNumber,
    });
    cu.currentUser.setCurrentUser(user);
    Navigator.pushNamed(context, '/home');
    return user;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //logo
            Container(
              height: MediaQuery.of(context).size.height/2,
              child: Image.asset('assets/diamond.png'),
            ),
            //googleLogin
            RaisedButton(
              child: Text("google",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: ()=>_googleSignIn(),
              color: Colors.red,
            ),            
            //anonymousLogin
            RaisedButton(
              child: Text("Anonymous",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: (){},
              color: Colors.black
            ),
          ],
        ),
      ),
    );
  }
}