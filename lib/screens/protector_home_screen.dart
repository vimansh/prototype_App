
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prototype/auth/login.dart';
import 'package:prototype/util/getDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class protectorHomeScreen extends StatefulWidget {
  FirebaseUser user;

  protectorHomeScreen(this.user);

  @override
  _protectorHomeScreenState createState() => _protectorHomeScreenState(user);
}

class _protectorHomeScreenState extends State<protectorHomeScreen> with SingleTickerProviderStateMixin {



  FirebaseUser user;
  var count = 0;

  _protectorHomeScreenState(this.user);

  String uid;
  var selectedItemId = 'Home';

  String _message = '';

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  _register() {
    _firebaseMessaging.getToken().then((token) => print(token));
  }

  void getMessage() {
    _firebaseMessaging.configure(

        // ignore: missing_return
        onMessage: (Map<String, dynamic> message) {
      var level1 = message['data']['level1'];

      var level2 = message['data']['level2'];
      var level3 = message['data']['level3'];
      var pressedLevel = message['data']['pressedLevel'];
      var batteryLevel = message['data']['battery'];
      var girluserid = message['data']['girl_id'];
      print('pressed level $pressedLevel and level1 is $level1');
      if (pressedLevel == 'level1' && level1 == 'true' && count == 0) {
        print("on message $message");
        print("current count is $count");
        count += 1;
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: ListTile(
                  title: Text(message['notification']['title']),
                  subtitle: Text(message['notification']['body']),
                  leading: Icon(Icons.message),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("onmessage"),
                    onPressed: () { Navigator.of(context).pop(); count = 0;},
                  )
                ],
              );
              //TODO setstate to show changes according to levels and data
            });
      }
    },
        onResume: (Map<String, dynamic> message) async {
          print('on resume hello in resumed state $message');
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: ListTile(
                  title: Text(message['notification']['title']),
                  subtitle: Text(message['notification']['body']),
                  leading: Icon(Icons.play_arrow),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("resume"),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ));


          print("resume");
          print("resume");
          print("resume");

      print('on resume hello in resumed state $message');
      setState(() =>
          _message = "hello on resume ${message["notification"]["title"]}");
    },
        onLaunch: (Map<String, dynamic> message) async {

          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: ListTile(
                  title: Text(message['notification']['title']),
                  subtitle: Text(message['notification']['body']),
                  leading: Icon(Icons.launch),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("launch"),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ));
          print('on launch on aunched state $message');
          print("launch");
          print("launch");
          print("launch");
          print("launch");

      print('on launch on aunched state $message');

    });
  }

  @override
  void initState() {
    super.initState();
    uid = user.uid;
    print('calling get message in inint state');
    getMessage();
    print('got out of mesej with count $count');
  }



  final TextStyle dropdownMenuItem =
  TextStyle(color: Colors.black, fontSize: 18);

  final primary = Color(0xff696b9e);
  final secondary = Color(0xfff29a94);

//  final List<Map> schoolLists = [
//    {
//      "name": "Edgewick Scchol",
//      "location": "572 Statan NY, 12483",
//      "type": "Higher Secondary School",
//      "logoText":
//      "https://cdn.pixabay.com/photo/2017/03/16/21/18/logo-2150297_960_720.png"
//    },
//    {
//      "name": "Xaviers International",
//      "location": "234 Road Kathmandu, Nepal",
//      "type": "Higher Secondary School",
//      "logoText":
//      "https://cdn.pixabay.com/photo/2017/01/31/13/14/animal-2023924_960_720.png"
//    },
//    {
//      "name": "Kinder Garden",
//      "location": "572 Statan NY, 12483",
//      "type": "Play Group School",
//      "logoText":
//      "https://cdn.pixabay.com/photo/2016/06/09/18/36/logo-1446293_960_720.png"
//    },
//    {
//      "name": "Campare Handeson",
//      "location": "Kasai Pantan NY, 12483",
//      "type": "Lower Secondary School",
//      "logoText":
//      "https://cdn.pixabay.com/photo/2017/01/13/01/22/rocket-1976107_960_720.png"
//    },
//    {
//      "name": "Campare Handeson",
//      "location": "Kasai Pantan NY, 12483",
//      "type": "Lower Secondary School",
//      "logoText":
//      "https://cdn.pixabay.com/photo/2017/01/13/01/22/rocket-1976107_960_720.png"
//    },
//    {
//      "name": "Campare Handeson",
//      "location": "Kasai Pantan NY, 12483",
//      "type": "Lower Secondary School",
//      "logoText":
//      "https://cdn.pixabay.com/photo/2017/01/13/01/22/rocket-1976107_960_720.png"
//    },
//    {
//      "name": "Campare Handeson",
//      "location": "Kasai Pantan NY, 12483",
//      "type": "Lower Secondary School",
//      "logoText":
//      "https://cdn.pixabay.com/photo/2017/01/13/01/22/rocket-1976107_960_720.png"
//    },
//  ];


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('protector')
          .document(user.uid)
          .collection('girl_list')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return LinearProgressIndicator();
        else {
          return buildHomepageList(context, snapshot.data.documents);
        }
      },
    );
  }
    Widget buildHomepageList(context,girl_docs){
    return Scaffold(
      backgroundColor: Color(0xfff0f0f0),
      drawer: getDrawer(user, 'protector').getdrawer(context),
      appBar: AppBar(
        title: Text("Protector screen"),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 145),
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                width: double.infinity,
                child: ListView.builder(
                    itemCount: girl_docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildList(context, index,girl_docs);
                    }),
              ),
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Girl's List",
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.filter_list,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 110,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: TextField(
                          // controller: TextEditingController(text: locations[0]),
                          cursorColor: Theme
                              .of(context)
                              .primaryColor,
                          style: dropdownMenuItem,
                          decoration: InputDecoration(
                              hintText: "Search School",
                              hintStyle: TextStyle(
                                  color: Colors.black38, fontSize: 16),
                              prefixIcon: Material(
                                elevation: 0.0,
                                borderRadius:
                                BorderRadius.all(Radius.circular(30)),
                                child: Icon(Icons.search),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 13)),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildList(BuildContext context, int index,girl_docs) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      width: double.infinity,
      height: 110,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(width: 3, color: secondary)),
            child: Image.network(
              girl_docs[index]['picture'],
              width: 50,
              height: 50,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${girl_docs[index]['name']} ${girl_docs[index]['surname']}',
                  style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.phone,
                      color: secondary,
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(girl_docs[index]['phone'],
                        style: TextStyle(
                            color: primary, fontSize: 13, letterSpacing: .3)),
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.battery_charging_full,
                      color: secondary,
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text('%hello',
                        style: TextStyle(
                            color: primary, fontSize: 13, letterSpacing: .3)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

 /*ListView(
        children: <Widget>[
          *//* StreamBuilder<QuerySnapshot>(

            stream: Firestore.instance //TODO this is dummy query
                .collection('girl_user') //TODO change this as protector -> userid -> girluser ->
            //TODO -> uid of girls who have added this member as trusted member
                .document(user.uid)
                .collection('trusted_member')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                print('caught inside null snapshots');
                return LinearProgressIndicator();
              } else {
                print('i have got the list data of trusted members');
                return buildgirlList(snapshot.data.documents);
              }
            },
          ),
*//*

   *//*       CupertinoButton(
            // color: Color(0xff93E7AE),
              onPressed: () async {
                // widget._signOut();

                SharedPreferences prefs =
                await SharedPreferences.getInstance();
                await prefs.setBool('Loggedin', false);
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => LoginPage()));
              },
              child: Text("Sign Out")),*//*
          SizedBox(height: 20,),

        ],
      )
    );
  }


}*/



Widget buildgirlList(List<DocumentSnapshot> documents) {
  // TODO build girl's list like did in trusted member in girl screen

}
