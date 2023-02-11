import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo/add_data.dart';
import 'package:todo/configure/color.dart';
import 'package:todo/configure/icon.dart';
import 'package:todo/configure/text.dart';
import 'package:todo/list_data.dart';

class ShowData extends StatelessWidget {
  final bool a = false;
  final firebase = FirebaseFirestore.instance;
  List mode = ["low", "mediume", "high", "urgent"];
  ShowData({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(icon.back, color: color.cb),
        ),
        centerTitle: true,
        title: Text(text.t1, style: TextStyle(color: color.cb)),
        actions: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ListData(),
                    ));
                  },
                  icon: Icon(icon.list)),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(icon.brightness, color: color.cb),
                  )),
            ],
          )
        ],
      ),
      body: ListView(
        children: [
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: firebase.collection('user').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!.docs;
                return GridView.builder(
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2 / 1.7.clamp(2.3, 3.9)),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:Colors.primaries[Random().nextInt(Colors.primaries.length)]),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.21,
                                        child: Text(
                                          data[index]['title'],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17),
                                        )),
                                    Chip(
                                        padding: EdgeInsets.zero,
                                        label: Text(
                                            data[index]['prio'].toString())),
                                  ],
                                ),
                                Text(data[index]['dis'].toString(),
                                    style: TextStyle(fontSize: 15),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        data[index]['date'].toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      )),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          print(data[index]['date'].toString());
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) => AddData(
                                              did:
                                                  data[index]['did'].toString(),
                                              title: data[index]['title']
                                                  .toString(),
                                              date: data[index]['date']
                                                  .toString(),
                                              dis:
                                                  data[index]['dis'].toString(),
                                              prio: data[index]['prio']
                                                  .toString(),
                                              a: a.toString(),
                                            ),
                                          ));
                                        },
                                        icon: Icon(icon.edit)),
                                    IconButton(
                                        onPressed: () {
                                          print("delet");
                                          final doc = firebase
                                              .collection('user')
                                              .doc(snapshot.data!.docs[index]
                                                  ['did']);
                                          doc.delete();
                                          print("delet");
                                        },
                                        icon: Icon(icon.delet)),
                                  ],
                                ),
                                // SizedBox(height: 25,),
                              ]),
                        ),
                      ),
                    );
                  },
                );
              }
              return CircularProgressIndicator();
            },
          )
        ],
      ),
    );
  }
}
