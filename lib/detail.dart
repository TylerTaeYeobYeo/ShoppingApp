import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:final_mobile/global/currentUser.dart' as cu;

import 'package:final_mobile/edit.dart';

class DetailPage extends StatelessWidget{
  final DocumentSnapshot data;
  DetailPage({Key key, @required this.data})
    : assert(data != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Detail"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: (){
              if(data.data['uid']==cu.currentUser.getUid())
                Navigator.push(context, 
                  MaterialPageRoute(
                    builder: (context) => EditPage(data: data),
                  )
                );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: (){
              if(data.data['uid']==cu.currentUser.getUid()){
                FirebaseStorage.instance.ref().child('/products/${data.data['created'].toString()}.jpg');
                Firestore.instance.collection('products').document(data.documentID).delete();
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Image.network(data.data['image'], fit: BoxFit.cover,),
          Container(
            padding: EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(data.data['name'], style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
                Text("\$" + data.data['price'].toString()),
                Divider(),
                Text(data.data['description'], softWrap: true),
              ],
            ),
          ),
          SizedBox(height: 40.0,),
          Container(
            padding: EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Creator: " + data.data['uid']),
                Text("Created: " + data.data['created'].toString()),
                Text("Modified: " + data.data['modified'].toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}