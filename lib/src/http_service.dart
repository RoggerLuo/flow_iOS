import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'note.dart';
final String baseUrl = "http://rorrc.3322.org:32818/v1";
// final String baseUrl = "http://0.0.0.0:8999";

int pageSize = 15;
Future sleep(int _milliseconds) {
  return new Future.delayed(Duration(milliseconds: _milliseconds), () => "1");
}

Future<List> getNotes(int start) async {
  var response = await http.get(
    Uri.encodeFull('$baseUrl/notes?startIndex=${start.toString()}&pageSize=${pageSize.toString()}'),
    headers: {"Accept": "application/json"}
  ).catchError((e){
    print(e);
  });
  if(response == null) {
    List<Note> empty= [Note(id:-2,content:'')];
    return empty;
  }
  if(response.statusCode==200) {
    Map _jsonData = json.decode(response.body);
    List data = _jsonData['data'];
    List<Note> notes = data.map((note)=> Note.fromJson(note)).toList(); 
    return notes;
  }else{
    return [];
  }
}

Future<List> getSimilar(int noteId) async {
  var response = await http.get(
      Uri.encodeFull('$baseUrl/getSimilar/$noteId'),
      headers: {"Accept": "application/json"}
  ).catchError((e){
    print(e);
  });
  List data = json.decode(response.body);
  List<Note> notes = data.map((note)=> Note.fromJson(note)).toList(); 
  return notes;
}

Future<String> modifyNote(note) async {  
  var response = await http.post(
    Uri.encodeFull('$baseUrl/note/${note.id}'), 
    body: {"content": note.content},
    headers: {"content-type": "application/x-www-form-urlencoded"}
  ).catchError((e){
    print(e);
  });
  if(response.statusCode==200) {
    Map data = json.decode(response.body);
    return data['data'];
  } else {
    return 'fail';
  }
}

Future<int> createNote(note) async {  
  var response = await http.post(
    Uri.encodeFull('$baseUrl/note'),
    body: {"content": note.content,"category_id":"0"},
    headers: {"content-type": "application/x-www-form-urlencoded"}
  ).catchError((e){
    print(e);
  });
  if(response == null){
    return -1;
  }
  if(response.statusCode == 200) {
    Map data = json.decode(response.body);
    return data['data']['insert_id'];
  } else {
    return -1;
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
