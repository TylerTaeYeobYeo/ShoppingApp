// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'detail.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>HomeState();
}
class HomeState extends State<HomePage>{
  
  double _sliderValue = 0.0;
  TextEditingController _search = TextEditingController();
  Stream<QuerySnapshot> term = Firestore.instance.collection('products').where("price", isGreaterThan: 0).snapshots();
  Widget _buildGridCards(BuildContext context, DocumentSnapshot product) {
    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 18 / 11,
            child: Image.network(
              product.data['image'],
              fit: BoxFit.fitWidth,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    product.data['name'],
                    style: theme.textTheme.title,
                    maxLines: 1,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    formatter.format(product.data['price']),
                    style: theme.textTheme.body2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        padding: EdgeInsets.all(0.0),
                        child: Text("More",
                          style: TextStyle(
                            fontSize: 10.0
                          ),
                        ),
                        onPressed: (){
                          Navigator.push(context, 
                            MaterialPageRoute(
                              builder: (context) => DetailPage(data:product),
                            )
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  search(){
    if(_search.text == ""){
      setState(() {
        term = Firestore.instance.collection('products').where("price",isGreaterThanOrEqualTo: _sliderValue).snapshots();
      });
    }
    else {
      setState(() {
        term = Firestore.instance.collection('products').where("name", isEqualTo: _search.text).where("price",isGreaterThanOrEqualTo: _sliderValue).snapshots();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.person,
            semanticLabel: 'personal',
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/profile');
          },
        ),
        title: Text('Main'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              semanticLabel: 'add',
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/add');
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[200]
                          ),
                          child: TextField(
                            controller: _search,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Slider(
                                onChanged: (double value) {
                                  setState(() {
                                    _sliderValue = value;                
                                  });
                                }, 
                                value: _sliderValue,
                                activeColor: Colors.red,
                                max: 1000.0,
                                min: 0.0,
                              ),
                            ),
                            Text("\$${_sliderValue.toInt()}"),
                          ],
                        ),
                        
                      ],
                    ),
                  ),
                ),
                RaisedButton(
                  child: Icon(Icons.search),
                  padding: EdgeInsets.all(10.0),
                  onPressed: ()=>search(),
                )
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: term,
              builder: (context, snapshot){
                if (!snapshot.hasData) return Container(
                  height: MediaQuery.of(context).size.height/2,
                  child:CircularProgressIndicator()
                );
                return GridView.count(
                  padding: EdgeInsets.all(10.0),
                  crossAxisCount: 2,
                  childAspectRatio: 4/5,
                  children: snapshot.data.documents.map((product)=>_buildGridCards(context, product)).toList(),
                );
              },
            ),
          ),
        ],
      )
    );
  }
}
