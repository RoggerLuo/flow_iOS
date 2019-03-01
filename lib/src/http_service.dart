import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'note.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String baseUrl = "http://rorrc.3322.org:32818/v1";
// final String baseUrl = "http://0.0.0.0:8999";

int pageSize = 10;
Future sleep(int _milliseconds) {
  return new Future.delayed(Duration(milliseconds: _milliseconds), () => "1");
}

Future<List> getNotes(int start) async {
  SharedPreferences prefs = await SharedPreferences.getInstance(); // Get shared preference instance
  String token = (prefs.getString('token') ?? ''); 
  if(token=='') return [];
  var response = await http.get(
    Uri.encodeFull('$baseUrl/note?startIndex=${start.toString()}&pageSize=${pageSize.toString()}'),
    headers: {
      "content-type": "application/x-www-form-urlencoded",
      "token":token
    }
  ).catchError((e){
    print(e);
  });
  if(response == null) {
    List<Note> empty= [];
    return empty;
  }
  if(response.statusCode==200) {
    Map _jsonData = json.decode(response.body);
    if(_jsonData['status']=='ok') {
      List data = _jsonData['results']['data'];
      List<Note> notes = data.map((note)=> Note.fromJson(note)).toList(); 
      return notes;
    }
    return [];
  }else{
    return [];
  }
}

Future<List> getSimilar(String noteId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance(); // Get shared preference instance
  String token = (prefs.getString('token') ?? ''); 
  var response = await http.get(
    Uri.encodeFull('$baseUrl/similar/$noteId'),
    headers: {
      "content-type": "application/x-www-form-urlencoded",
      "token":token
    }
  ).catchError((e){
    print(e);
  });
  Map data = json.decode(response.body);
  List results = data['results'];
  List<Note> notes = results.map((note)=> Note.fromJson(note)).toList(); 
  return notes;
}

Future<String> modifyNote(note) async {  
  SharedPreferences prefs = await SharedPreferences.getInstance(); // Get shared preference instance
  String token = (prefs.getString('token') ?? ''); 
  var response = await http.post(
    Uri.encodeFull('$baseUrl/note/${note.id}'), 
    body: {"content": note.content},
    headers: {
      "content-type": "application/x-www-form-urlencoded",
      "token":token
    }
  ).catchError((e){
    print(e);
  });
  if(response.statusCode==200) {
    Map data = json.decode(response.body);
    return data['results'];
  } else {
    return 'fail';
  }
}

Future<String> createNote(note) async {
  SharedPreferences prefs = await SharedPreferences.getInstance(); // Get shared preference instance
  String token = (prefs.getString('token') ?? ''); 

  var response = await http.post(
    Uri.encodeFull('$baseUrl/note'),
    body: {"content": note.content},
    headers: {
      "content-type": "application/x-www-form-urlencoded",
      "token":token
    }
  ).catchError((e){
    print(e);
  });
  if(response == null){
    return 'error';
  }
  if(response.statusCode == 200) {
    Map data = json.decode(response.body);
    return 'success';
  } else {
    return 'error';
  }
}

Future<Map> login(username,password) async {  
  var response = await http.post(
    Uri.encodeFull('$baseUrl/auth/login'),
    body: {"username": username,"password":password},
    headers: {"content-type": "application/x-www-form-urlencoded"}
  ).catchError((e){
    print(e);
  });
  if(response == null) return {'status':'error'};
  if(response.statusCode == 200) {
    var data = json.decode(response.body);
    return data;
  } else {
    return {'status':'error'};
  }
}
