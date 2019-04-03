import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async'; // for import function called futuer
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //futuer its function we dont know when it will complite
  // it return list of type User and function callled _getuser()
  // syncronuns func
  Future<List<User>> _getUsers() async {
    // http get request from site called json gnerator
    // await to use it u hve to convert syncr func to asyncrons by put async word
    var data = await http
        .get("http://www.json-generator.com/api/json/get/bOtuKLWQqG?indent=2");

    var jsondata = json.decode(data.body);
    // bc json data is arry we hve to loop on it
    //list of type User and named as users
    List<User> users = [];
    for (var u in jsondata) {
      // constractor form User class
      User user =
          User(u["index"], u["about"], u["picture"], u["name"], u["email"]);
      // user is object from users arry
      // insert user object to users arry
      users.add(user);
    }
    print(users.length);
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getUsers(), // name of func
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // snapshot hve data rutern from _getusers()
            print(snapshot.data);
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text('lodaing...'),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data
                    .length, // snapshot.data arry hve my data execute when future execte
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(snapshot.data[index].picture),
                    ),
                    title: Text(snapshot.data[index].name),
                    subtitle: Text(snapshot.data[index].email),
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => Detailpage(snapshot.data[index])));
                    },
                  ); // how each item in list will look like
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class Detailpage extends StatelessWidget {
  final User user;
  Detailpage(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
    );
  }
}

class User {
  final int index;
  final String about;

  final String email;
  final String name;
  final String picture;

  User(this.index, this.about, this.picture, this.name, this.email);
}
