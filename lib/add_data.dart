import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo/configure/color.dart';
import 'package:todo/configure/icon.dart';
import 'package:todo/configure/text.dart';
import 'package:todo/show_data.dart';

class AddData extends StatefulWidget {
  const AddData(
      {Key? key, this.did, this.date, this.dis, this.prio, this.title, this.a})
      : super(key: key);
  final did;
  final date;
  final dis;
  final prio;
  final title;
  final a;

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  DateTime? pickedDate;
  // DateTime pickedDate1=widget.date;
  String date = '';

  void initState() {
    super.initState();
    pickedDate = DateTime.now();
    // print("=========>${widget.date}");
    if (widget.did != null) {
      _name.text = widget.title.toString();
      _discription.text = widget.dis.toString();
      _date.text = widget.date.toString();
      selected = widget.prio.toString();
      print(widget.a);
    } else {
      pickedDate = DateTime.now();
    }
  }

  List prio = ["Low", "Medium", "High", "Urgent"];
  String selected = "";
  TextEditingController _name = TextEditingController();
  TextEditingController _discription = TextEditingController();
  TextEditingController _date = TextEditingController();
  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    date =
        "${pickedDate!.day.toString()}-${pickedDate!.month.toString()}-${pickedDate!.year}";
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              icon.back,
              color: color.cb,
            )),
        title: Text(text.t1, style: TextStyle(color: color.cb)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              icon.night,
              color: color.cb,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text.t2,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: widget.a == null
                          ? () async {
                              print(date);
                              final doc =
                                  await firestore.collection("user").doc();
                              doc.set({
                                "title": _name.text,
                                "dis": _discription.text,
                                "date": date.toString(),
                                "prio": selected.toString(),
                                "did": doc.id,
                              }).whenComplete(
                                  () {
                                    print(_name.text);
                                    print(_discription.text);
                                    print(date.toString());
                                    print(selected.toString());
                                    print("Data Add Sucessfully");
                                  });
                              Navigator.of(context).pop();
                            }
                          : () async {
                              print(date);
                              final doc = await firestore
                                  .collection("user")
                                  .doc(widget.did.toString());
                              doc.update({
                                "title": _name.text,
                                "dis": _discription.text,
                                "date": date.toString(),
                                "prio": selected.toString(),
                                "did": doc.id,
                              }).whenComplete(
                                () {
                                  print("Data Update Sucessfully");
                                },
                              );
                              Navigator.of(context).pop();

                            },

                      icon: Icon(icon.save)),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ShowData(),
                        ));
                      },
                      icon: Icon(icon.app)),
                  IconButton(
                      onPressed: () {
                        _name.clear();
                        _discription.clear();
                        _date.clear();
                      },
                      icon: Icon(icon.refresh)),
                ],
              )
            ],
          ),
          Text("Priority"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              clipBehavior: Clip.antiAlias,
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: color.cb),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: prio
                    .map((e) => Expanded(
                          child: InkWell(
                            onTap: () {
                              selected = e;
                              setState(() {});
                              print(e);
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    color: selected == e ? color.cg : color.ct,
                                    border: Border.all(color: color.cb1)),
                                child: Center(child: Text(e.toString()))),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
          TextField(
            controller: _name,
            maxLength: 150,
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                hintText: text.tet,
                label: Text(text.tt),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
          ),
          TextField(
            controller: _discription,
            maxLength: 255,
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                hintText: text.ted,
                label: Text(text.td),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    text.tpd,
                    style: TextStyle(color: color.cb),
                  ),
                  IconButton(
                      onPressed: () {
                        _pickDate();
                        print(pickedDate);
                      },
                      icon: Icon(icon.date)),
                  Text(text.tda)
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: TextField(
                  controller: _date,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }

  _pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime(DateTime.now().year + 10),
      initialDate: pickedDate!,
    );
    if (date != null) {
      setState(() {
        pickedDate = date;
        _date.text =
            "${pickedDate!.day.toString()}-${pickedDate!.month.toString()}-${pickedDate!.year}";
        print("------${_date.text}");
      });
    }
  }
}
