import 'package:flutter/material.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:final_mobile/global/currentUser.dart' as cu;

class AddPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => AddState();
}

class AddState extends State<AddPage>{
  TextEditingController _name = new TextEditingController();
  TextEditingController _price = new TextEditingController();
  TextEditingController _description = new TextEditingController();

  @override
  void dispose() { 
    _name.dispose();
    _price.dispose();
    _description.dispose();
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
      child: _image != null? Image.file(_image):Image.network("https://www.baddorf.com/wp-content/uploads/2010/09/default-image.jpg", fit: BoxFit.fitWidth),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add"),
        actions: <Widget>[
          FlatButton(
            child: Text("Save"),
            onPressed: () async {
              Navigator.pop(context);
              DateTime now = DateTime.now();
              StorageUploadTask task = FirebaseStorage.instance.ref().child('/products/${now.toString()}').putFile(_image);
              String imageUrl = (await (await task.onComplete).ref.getDownloadURL());
              Firestore.instance.collection('products').add({
                "uid": cu.currentUser.getUid(),
                "name": _name.text,
                "price": int.parse(_price.text),
                "description": _description.text,
                "image": imageUrl,
                "created": now,
                "modified": now,
              });
            },
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(10.0),
        children: <Widget>[
          imageArea(_image),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: ()=>getImage(),
          ),
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
          ),
        ],
      ),
    );
  }
}