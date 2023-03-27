import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:math' as math;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

Future main() async {

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  final String title = 'MedNeed';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: WorkerLoginPage()
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({required this.title});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  String? _firstDropdownValue='NA';
  String? _secondDropdownValue='NA';
  final List<String> _firstDropdownItems = ['NA', 'Doctor', 'Nurse'];
  final Map<String, List<String>> _secondDropdownItems = {
    'Doctor': ['NA','Immunologists', 'Anesthesiologists','Cardiologists','Colon and Recta','Critical Care','Dermatologists','Endocrinologists','Family Physicians','Gastroenterologists','Geriatric Medicine','Orthopedics','Internal Medicine','Obstetrics and Gynecology','Pediatrics','Radiology','General Surgery','Ophthalmology','ENT','other'],
    'Nurse': ['NA','Faith Community Nurse', 'Rural Nurse','School Nurse','Family Nurse Practitioner','Nurse Case Manager','Community Health Nurse','Public Health Nurse','Forensic Nurse','Legal Nurse Consultant','Infection Control Nurse','Advanced Practice Registered Nurse','Adult Nurse','Charge Nurse','Clinical Nurse Leader','Nurse Administrator'],
    'NA':['NA'],
  };
  bool _isDataShared = false;
  bool _isRed = false;

  void _changeColor() {
    setState(() {
      _isDataShared=!_isDataShared;
      _isRed = !_isRed;
    });
  }


  Future<Position> _determinePosition() async {
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

    return await Geolocator.getCurrentPosition();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: _isRed?CupertinoColors.destructiveRed:null,
      ),

      body:
          Stack(
            children:[
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/doc.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              /*SizedBox(
                height:200,width: 200,
                child:ElevatedButton(

                  onPressed: _isDataShared ? _deleteData : _shareData,
                  child: Text(_isDataShared ? 'Stop Sharing' : 'Share Data'),
                  style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(200),
                      )
                  ),
                ),
              ),*/
              SizedBox(height: 100.0),
              Text(
                'Share your Info',
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                ),
              ),

              SizedBox(height: 8.0),
              DropdownButtonFormField<String>(
                value: _firstDropdownValue,
                items: _firstDropdownItems
                    .map((item) =>
                    DropdownMenuItem<String>(child: Text(item), value: item))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _firstDropdownValue = value;
                    _secondDropdownValue = null; // reset the second dropdown
                  });
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _secondDropdownValue,
                items: _secondDropdownItems[_firstDropdownValue]!
                    .map((item) =>
                    DropdownMenuItem<String>(child: Text(item), value: item))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _secondDropdownValue = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
              Container(
                width: double.infinity,
                height: double.infinity,
                color: _isRed?CupertinoColors.destructiveRed:null,
                child:Column(
                  children:[
                      SizedBox(height: 60.0),
                    SizedBox(
                  height:200,width: 200,

                  child:ElevatedButton(

                    onPressed: _isDataShared ? _deleteData : _shareData,
                    child: Text(_isDataShared ? 'STOP SHARING' : 'SHARE DATA'),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(200),
                        )
                    ),
                  ),
                )]
              )
              )
      ])




    );
  }

  void _shareData() async {
    final name = _nameController.text;
    final id = _idController.text;
    Position position = await _determinePosition();
    final role =_firstDropdownValue;
    final spec=_secondDropdownValue;
    final createTime = Timestamp.now();
    if (name.isNotEmpty && id.isNotEmpty && role!='NA'&& spec!='NA') {
      await FirebaseFirestore.instance.collection('users').doc().set({
        'name': name,
        'ph':id,
        'role':role,
        'specialization':spec,
        'positionx': position.latitude,
        'positiony': position.longitude,
        'createTime':createTime,
      });

      _changeColor();
    }else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Please fill out all fields.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
  void _deleteData() async {
    final collection = FirebaseFirestore.instance.collection('users');
    final querySnapshot = await collection.orderBy('createTime', descending: false).get();

    if (querySnapshot.docs.isNotEmpty) {
      final lastDoc = querySnapshot.docs.last;
      await lastDoc.reference.delete();
    }
    _changeColor();
  }
}





class WorkerLoginPage extends StatelessWidget {

  String value1 = "";
  String value2 = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.red,
      resizeToAvoidBottomInset: false,
      body:
      Stack(
      children:[
          Container(
          width: 411,
          height: 919,
          decoration: BoxDecoration(
            color : Color.fromRGBO(255, 255, 255, 1),
          ),
          child: Stack(
              children: <Widget>[
              Positioned(
              top: 107,
              left: -300,
              child: Container(
                  width: 1010,
                  height: 706,
                  decoration: BoxDecoration(
                    image : DecorationImage(
                        image: AssetImage('assets/images/Images1.png'),
                        fit: BoxFit.fitWidth
                    ),
                  )
              )
          ),
          ]
          )
      )




        ,Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Health Care Workers Login',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(0,0,139,1)
              ),
            ),
            SizedBox(height: 32.0),
            TextField(
              onChanged: (text) {
                value1 = text;
              },
              decoration: InputDecoration(
                labelText: 'Username',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),

                  )
                ,
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              onChanged: (text) {
                value2 = text;
              },
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(

                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 50.0),
            SizedBox(height: 60.0,width:150.0 ,
              child: ElevatedButton(
              onPressed: () {
                if(value1=='gdsc'&&value2=='great'){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return MyHomePage(title:'MedNeed');
                    }),
                  );
                }
              },
              child: Text('Login',style: TextStyle(color: Colors.white,fontSize: 15)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, //background color of button
                      //side: BorderSide(width:3, color:Colors.brown), //border width and color
                      elevation: 3, //elevation of button
                      shape: RoundedRectangleBorder( //to set border radius to button
                          borderRadius: BorderRadius.circular(50)
                      ),
                      padding: EdgeInsets.all(20) //content padding inside button
                  )
            ),),
            SizedBox(height: 80.0),
            SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height:100,width: 200,
                  child:ElevatedButton(

                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return HospLoginPage();
                      }),
                    );
                  },
                  child: Text('Hospital Portal',style: TextStyle(color: Colors.white,fontSize: 20)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, //background color of button
                        //side: BorderSide(width:3, color:Colors.brown), //border width and color
                        elevation: 3, //elevation of button
                        shape: RoundedRectangleBorder( //to set border radius to button
                            borderRadius: BorderRadius.circular(50)
                        ),
                        padding: EdgeInsets.all(20) //content padding inside button
                    )
                ),
    )              ],
            ),
          ],
        ),
      ),
      ])
    );
  }
}

class HospLoginPage extends StatelessWidget {

  String value3 = "";
  String value4 = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
      children:[
          Container(
          constraints: BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/doc.jpg"),
              fit: BoxFit.cover),
        ),

          )
,
        Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            SizedBox(height: 150.0),
            Text(
              'Hospital Login',
              style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(0,0,139,1),
              ),
            ),
            SizedBox(height: 32.0),
            TextField(
              onChanged: (text) {
                value3 = text;
              },
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),

              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              onChanged: (text) {
                value4 = text;
              },
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 50.0),
            SizedBox(height: 60.0,width:150 ,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent, //background color of button
                    side: BorderSide(width:3, color:Colors.brown), //border width and color
                    elevation: 3, //elevation of button
                    shape: RoundedRectangleBorder( //to set border radius to button
                        borderRadius: BorderRadius.circular(50)
                    ),
                    padding: EdgeInsets.all(20) //content padding inside button
                ),
              onPressed: () {
                if(value3=='gdsc'&&value4=='great'){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return FilteredDataScreen();
                    }
                    ),
                  );
                }
              },
              child: Text('Login'),
            ),),
            SizedBox(height: 80.0),
            SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height:100,width: 200,
                  child:ElevatedButton(

                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Health workers login'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent, //background color of button
                          side: BorderSide(width:3, color:Colors.brown), //border width and color
                          elevation: 3, //elevation of button
                          shape: RoundedRectangleBorder( //to set border radius to button
                              borderRadius: BorderRadius.circular(50)
                          ),
                          padding: EdgeInsets.all(20) //content padding inside button
                      )
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ]
      )
    );
  }
}


Future<Position> _getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw 'Location services are disabled.';
  }

  // Request location permissions if not already granted
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw 'Location permissions are denied.';
    }
  }

  // Get the current location of the device
  return await Geolocator.getCurrentPosition();
}

class User {
  final String name;
  final String phoneNumber;
  final String role;
  final String specialization;

  User({
    required this.name,
    required this.phoneNumber,
    required this.role,
    required this.specialization,
  });
}



class FilteredDataScreen extends StatefulWidget {
  @override
  _FilteredDataScreenState createState() => _FilteredDataScreenState();
}

class _FilteredDataScreenState extends State<FilteredDataScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? _selectedRole='NA';
  String? _selectedSpecialization='NA';
  final List<String> _firstDropdownItems = ['NA', 'Doctor', 'Nurse'];
  final Map<String, List<String>> _secondDropdownItems = {
  'Doctor': ['NA','Immunologists', 'Anesthesiologists','Cardiologists','Colon and Recta','Critical Care','Dermatologists','Endocrinologists','Family Physicians','Gastroenterologists','Geriatric Medicine','Orthopedics','Internal Medicine','Obstetrics and Gynecology','Pediatrics','Radiology','General Surgery','Ophthalmology','ENT','other'],
  'Nurse': ['NA','Faith Community Nurse', 'Rural Nurse','School Nurse','Family Nurse Practitioner','Nurse Case Manager','Community Health Nurse','Public Health Nurse','Forensic Nurse','Legal Nurse Consultant','Infection Control Nurse','Advanced Practice Registered Nurse','Adult Nurse','Charge Nurse','Clinical Nurse Leader','Nurse Administrator'],
  'NA':['NA'],};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Data'),
      ),
      body:
      Stack(
        children:[
          Container(
          width: 411,
          height: 919,
          decoration: BoxDecoration(
            color : Color.fromRGBO(255, 255, 255, 1),
          ),
          child: Stack(
              children: <Widget>[
              Positioned(
              top: 0,
              left: 0,
              child: Container(
                  width: 411,
                  height: 919,
                  decoration: BoxDecoration(
                    color : Color.fromRGBO(144,238,144, 1),
                  )
              )
          ),
          ]
          )
      )

          ,Container(
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder()
                ,filled: true,
                fillColor: Colors.white,
              ),
              value: _selectedRole,
              items: _firstDropdownItems
                  .map((item) =>
                  DropdownMenuItem<String>(child: Text(item), value: item))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRole = value;
                  _selectedSpecialization = null; // reset the second dropdown
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Specialization',
                border: OutlineInputBorder()
                ,filled: true,
                fillColor: Colors.white,
              ),
              value: _selectedSpecialization,
              items: _secondDropdownItems[_selectedRole]!
                  .map((item) =>
                  DropdownMenuItem<String>(child: Text(item), value: item))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSpecialization = value;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('users')
                  .where('role', isEqualTo: _selectedRole)
                  .where('specialization', isEqualTo: _selectedSpecialization)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<User> users = snapshot.data!.docs.map((doc) {
                  return User(
                    name: doc['name'],
                    phoneNumber: doc['ph'],
                    role: doc['role'],
                    specialization: doc['specialization'],
                  );
                }).toList();

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: <DataColumn>[
                      DataColumn(
                        label: Text('Name',style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        ),
                      ),
                      DataColumn(
                        label: Text('Phone Number',style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),),
                      ),
                      DataColumn(
                        label: Text('Role',style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),),
                      ),
                      DataColumn(
                        label: Text('Specialization',style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),),
                      ),
                    ],
                    rows: users.map((user) {
                      return DataRow(cells: <DataCell>[
                        DataCell(Text(user.name,style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      ),
                        )),
                        DataCell(Text(user.phoneNumber,style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),)),
                        DataCell(Text(user.role,style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),)),
                        DataCell(Text(user.specialization,style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),)),
                      ]);
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      )]
      )
    );
  }
}





