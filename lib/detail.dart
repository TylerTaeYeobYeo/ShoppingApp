import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:final_mobile/global/currentUser.dart' as cu;


class DetailPage  extends StatefulWidget {
  final DocumentSnapshot data;
  DetailPage({Key key, @required this.data})
    : assert(data != null);

  DetailState createState() => DetailState(data: data);
}

class DetailState extends State<DetailPage> {
  final DocumentSnapshot data;
  DetailState({Key key, @required this.data})
    : assert(data != null);
  bool edit = false;
  TextEditingController _name = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _description = TextEditingController();  

  @override
  void initState() {
    _name.text = data.data['name'];
    _price.text = data.data['price'].toString();
    _description.text = data.data['description'];
    super.initState();
  }
  void save()async{
    setState(() {
      edit = false;
      data.data['name'] = _name.text;
      data.data['price'] = int.parse(_price.text);
      data.data['description'] = _description.text;
      data.data['modified'] = DateTime.now();
    });
    if(_image != null){
      StorageUploadTask task = FirebaseStorage.instance.ref().child('/products/${data.data['created'].toString()}').putFile(_image);
      String imageUrl = (await (await task.onComplete).ref.getDownloadURL());
                
      Firestore.instance.collection('products').document(data.documentID).updateData({
        "name": _name.text,
        "price": int.parse(_price.text),
        "description": _description.text,
        "image": imageUrl,
        "modified": DateTime.now(),
      });
    }
    else Firestore.instance.collection('products').document(data.documentID).updateData({
        "name": _name.text,
        "price": int.parse(_price.text),
        "description": _description.text,
        "modified": DateTime.now(),
      });
  }
  @override
  void dispose() { 
    _description.dispose();
    _price.dispose();
    _name.dispose();
    super.dispose();
  }

  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image ==null) return;
    setState(() {
      _image = image;
    });
  }

  Widget imageArea(File _image){
    return Container(
      height: MediaQuery.of(context).size.height/3,
      child: _image != null? Image.file(_image):Image.network(data.data['image'], fit: BoxFit.fitHeight,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Detail"),
        actions: !edit?<Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: (){
              if(cu.currentUser.getUid() == data.data['uid'])
                setState(() {
                  edit = true;
                });
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
        ]:[
          FlatButton(
            child: Text("Save"),
            onPressed: ()=>save(),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          imageArea(_image),
          !edit?SizedBox():IconButton(icon: Icon(Icons.camera_alt),onPressed: ()=>getImage(),),
          Container(
            padding: EdgeInsets.all(30.0),
            child: !edit?Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(data.data['name'], style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
                Text("\$" + data.data['price'].toString()),
                Divider(),
                Text(data.data['description'], softWrap: true),
              ],
            ):Column(
              children: <Widget>[
                TextField(
                  controller: _name,
                  decoration: InputDecoration(
                    labelText: "Product Name",
                  ),
                ),
                TextField(
                  controller: _price,
                  keyboardType: TextInputType.numberWithOptions(signed: false,decimal: false),
                  decoration: InputDecoration(
                    labelText: "Price",
                  ),
                ),
                TextField(
                  controller: _description,
                  decoration: InputDecoration(
                    labelText: "Description",
                  ),
                )
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