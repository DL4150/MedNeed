import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant/Api_data.dart';

import 'Download.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Private privateVar = Private();
  Position? currentposition;
  StreamSubscription<Position>? positionStream;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    positionStream?.cancel();
  }

  Color _menu1 = Colors.grey.shade400;
  Color _menu2 = Colors.white;
  Color _menu3 = Colors.white;
  String? role = "NA";

  String? spec = "NA";

  TextEditingController _con = TextEditingController();

  void getlocation() async {}

  @override
  void initState() {
    _determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _xX = MediaQuery.of(context).size.width;
    double _yY = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Container(
              height: _yY * .08,
              width: _xX,
              child: Card(
                elevation: 5,
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage("/Images/ic.png"),
                    ),
                    Container(
                      width: _xX * .2,
                      child: FittedBox(
                        child: Text(
                          "\tPublic Hospital",
                          style: GoogleFonts.aboreto(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: _xX * .05,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      width: _xX * .45,
                      child: Flexible(
                        fit: FlexFit.tight,
                        child: TextField(
                          controller: _con,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: SizedBox(
                        width: _xX * 0.05,
                      ),
                    ),
                    Container(
                      width: _xX * .1,
                      color: Colors.grey.shade100,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: DropdownButton<String>(
                          value: role,
                          items: ['NA', 'Doctor', 'Nurse']
                              .map((item) => DropdownMenuItem<String>(
                                  child: Text(item), value: item))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              role = value;
                              spec = null; // reset the second dropdown
                            });
                          },
                        ),
                      ),
                    ),
                    Container(
                      width: _xX * .1,
                      color: Colors.grey.shade100,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: DropdownButton<String>(
                          value: spec,
                          items: privateVar.list[role]!
                              .map((item) => DropdownMenuItem<String>(
                                  child: Text(item), value: item))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              spec = value;
                            });
                          },
                        ),
                      ),
                    )
                  ],
                ),
              )),
          Container(
            height: _yY * .92,
            width: _xX,
            child: Row(
              children: [
                Container(
                  height: _yY,
                  width: _xX * .2,
                  child: Column(
                    children: [
                      SizedBox(height: _yY * .3),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _menu1 = Colors.grey.shade400;
                            _menu2 = Colors.white;
                            _menu3 = Colors.white;
                          });
                        },
                        child: Container(
                          width: _xX,
                          color: _menu1,
                          child: Text(
                            "Home",
                            style: GoogleFonts.aBeeZee(
                              fontSize: _yY * .03,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 3,
                        color: Colors.black.withOpacity(.5),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _menu2 = Colors.grey.shade400;
                            _menu1 = Colors.white;
                            _menu3 = Colors.white;
                          });
                        },
                        child: Container(
                          width: _xX,
                          color: _menu2,
                          child: Text(
                            "Mobile App",
                            style: GoogleFonts.aBeeZee(
                              fontSize: _yY * .03,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 3,
                        color: Colors.black.withOpacity(.5),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _menu3 = Colors.grey.shade400;
                            _menu1 = Colors.white;
                            _menu2 = Colors.white;
                            Get.back();
                          });
                        },
                        child: Container(
                          width: _xX,
                          color: _menu3,
                          child: Text(
                            "Log Out",
                            style: GoogleFonts.aBeeZee(
                              fontSize: _yY * .03,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: _yY,
                  width: _xX * .001,
                  color: Colors.black.withOpacity(.5),
                ),
                Container(
                  height: _yY,
                  width: _xX * .699,
                  child: (_menu1 == Colors.grey.shade400)
                      ? Container(
                          width: _xX * .699,
                          child: Column(
                            children: [
                              Container(
                                height: _yY * .15,
                                width: _xX * .699,
                                alignment: Alignment.bottomLeft,
                                child: (role == "NA")
                                    ? Text("All",
                                        style: GoogleFonts.aboreto(
                                            fontSize: _yY * .05,
                                            fontWeight: FontWeight.bold))
                                    : Text(
                                        role!,
                                        style: GoogleFonts.aboreto(
                                            fontSize: _yY * .05,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                              Divider(
                                thickness: 2,
                              ),
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('users')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Text('Error: ${snapshot.error}'),
                                    );
                                  }

                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  final List<DocumentSnapshot> documents =
                                      snapshot.data!.docs;

                                  List<Map<String, dynamic>> userData =
                                      documents.map((doc) {
                                    return {
                                      'name': doc['name'],
                                      'ph': doc['ph'],
                                      'role': doc['role'],
                                      'specialization': doc['specialization'],
                                      'position': [
                                        doc['positionx'],
                                        doc['positiony']
                                      ]
                                    };
                                  }).toList();

                                  if (role == "Doctor" || role == "Nurse") {
                                    userData = userData
                                        .where((element) =>
                                            element["role"] == role)
                                        .toList();

                                    if (spec != "NA" || spec != null) {
                                      userData = userData
                                          .where((element) =>
                                              element["specialization"] == spec)
                                          .toList();
                                    }
                                  }

                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: userData.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Card(
                                        child: ListTile(
                                          title: Text(userData[index]['name']),
                                          subtitle: Text(userData[index]
                                              ['specialization']),
                                          trailing: Text(userData[index]["ph"]),
                                          leading: Text(
                                            "${sqrt(pow((currentposition!.latitude - userData[index]['position'][0]), 2) + pow((currentposition!.longitude - userData[index]['position'][1]), 2)).toStringAsFixed(2)} Km",
                                            style: GoogleFonts.aBeeZee(
                                                fontSize: _yY * 0.03),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              )
                            ],
                          ),
                        )
                      : Download_Page(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    setState(() {
      currentposition = position;
    });
  }
}
