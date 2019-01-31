import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
		title: 'Startup Name Generator',            
		home: new MyGetHttpData(),
    );
  }
}
// Create a stateful widget
class MyGetHttpData extends StatefulWidget {
  @override
  MyGetHttpDataState createState() => new MyGetHttpDataState();
}
// Create the state for our stateful widget

class MyGetHttpDataState extends State<MyGetHttpData> {
  final String url = "http://rorrc.3322.org:6664/notes";
  List data;
  
  Future<String> getJSONData() async {
    var response = await http.get(
        Uri.encodeFull(url),
        headers: {"Accept": "application/json"}
	);
    // print(response.body);
    setState(() {
		  var dataConvertedToJSON = json.decode(response.body);
		  data = dataConvertedToJSON['data'];
    });
    return "Successfull";
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Data Demo"),
      ),
      // Create a Listview and load the data when available
      body: new ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {
            return new Container(
              child: new Center(
                  child: new Column(
                // Stretch the cards in horizontal axis
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new Card(
                    child: new Container(
                      child: new Text(
                        // Read the name field value and set it in the Text widget
                        data[index]['content'],
                        // set some style to text
                        style: new TextStyle(
                            fontSize: 20.0, color: Colors.lightBlueAccent),
                      ),
                      // added padding
                      padding: const EdgeInsets.all(15.0),
                    ),
                  )
                ],
              )),
            );
          }),
    );
  }
   @override
  void initState() {
    super.initState();

    // Call the getJSONData() method when the app initializes
    this.getJSONData();
  }
}

// var url = "http://example.com/whatsit/create";
// http.post(url, body: {"name": "doodle", "color": "blue"})
//     .then((response) {
//   print("Response status: ${response.statusCode}");
//   print("Response body: ${response.body}");
// });

// http.read("http://example.com/foobar.txt").then(print);

Future<Post> fetchPost() async {
  final response = await http.get('https://jsonplaceholder.typicode.com/posts/1');

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}
