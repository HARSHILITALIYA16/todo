import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo/add_data.dart';
import 'package:todo/configure/color.dart';
import 'package:todo/configure/icon.dart';
import 'package:todo/configure/text.dart';
import 'package:todo/show_data.dart';
class ListData extends StatefulWidget {
  const ListData({Key? key}) : super(key: key);

  @override
  State<ListData> createState() => _ListDataState();
}

class _ListDataState extends State<ListData> {
  @override
  Widget build(BuildContext context) {
    final firebase = FirebaseFirestore.instance;
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(text.t1, style: TextStyle(color: color.cb)),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
             icon.back,
              color: color.cb,
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ShowData(),
                      ));
                    },
                    icon: Icon(
                      icon.app,
                      color: color.cb,
                    )),
                SizedBox(
                  width: 5,
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      icon.night,
                      color: color.cb,
                    )),
              ],
            ),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firebase.collection('user').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            return ListView.separated(separatorBuilder: (context, index) {
              return SizedBox(height: 10,);
            },
              itemCount: docs.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(docs.toString()),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors
                          .primaries[Random().nextInt(Colors.primaries.length)],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8),
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(snapshot.data!.docs[index]['title']
                                      .toString(),style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500)),
                                  Chip(label: Text(snapshot.data!.docs[index]['prio']
                                      .toString()))
                                ]),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(snapshot.data!.docs[index]['dis']
                                    .toString(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),)),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Text(snapshot.data!.docs[index]['date']
                                    .toString(),style: TextStyle(fontWeight: FontWeight.w600,),)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return CircularProgressIndicator();
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddData(),
            ));
          },
          child: Icon(icon.add),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    );
  }
}
