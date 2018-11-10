import 'package:flutter/material.dart';
import 'package:final_mobile/global/currentUser.dart' as cu;
import 'package:firebase_auth/firebase_auth.dart';
class ProfilePage extends StatefulWidget {
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<ProfilePage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(cu.currentUser.displayName),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: (){
              FirebaseAuth.instance.signOut();
              cu.currentUser.googleLogOut();
              Navigator.popUntil(context, ModalRoute.withName('/login'));
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.network(cu.currentUser.getPhoto(), fit: BoxFit.fill,),
          SizedBox(height: 20.0,),
          Text("uid: " + cu.currentUser.getUid(), style: TextStyle(color: Colors.white),),
          Divider(),
          Text("email: " + cu.currentUser.getEmail(), style: TextStyle(color: Colors.white),),
        ],
      ),
    );
  }
}