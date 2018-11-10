import 'package:flutter/material.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:final_mobile/global/currentUser.dart' as cu;

class EditPage extends StatefulWidget {
  final DocumentSnapshot data;
  EditPage({Key key, @required this.data})
    : assert(data != null);
  _EditPageState createState() => _EditPageState(data: data);

}

class _EditPageState extends State<EditPage> {
  final DocumentSnapshot data;
  _EditPageState({Key key, @required this.data})
    : assert(data != null);
  TextEditingController _name = new TextEditingController();
  TextEditingController _price = new TextEditingController();
  TextEditingController _description = new TextEditingController();

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
      child: _image != null? Image.file(_image):Image.network(data.data['image'], fit: BoxFit.fitHeight),
    );
  }

  void initState() { 
    super.initState();
    _name.text = data.data['name'];
    _price.text = data.data['price'].toString();
    _description.text = data.data['description'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Edit"),
        actions: <Widget>[
          FlatButton(
            child: Text("Save"),
            onPressed: () async {
              StorageUploadTask task = FirebaseStorage.instance.ref().child('/products/${data.data['created'].toString()}').putFile(_image);
              String imageUrl = _image != null?(await (await task.onComplete).ref.getDownloadURL()):data.data['image'];
              Firestore.instance.collection('products').document(data.documentID).updateData({
                "uid": cu.currentUser.getUid(),
                "name": _name.text,
                "price": int.parse(_price.text),
                "description": _description.text,
                "image": imageUrl,
                "modified": DateTime.now(),
              });
              Navigator.pop(context);
            },
          ),
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