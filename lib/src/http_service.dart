import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'note.dart';
import 'package:shared_preferences/shared_preferences.dart';

final String baseUrl = "http://rorrc.3322.org:32818/v1";
// final String baseUrl = "http://192.168.1.3:8999/v1";

int pageSize = 20;

Future sleep(int _milliseconds) {
  return new Future.delayed(Duration(milliseconds: _milliseconds), () => "1");
}

Future<String> verifyAuth() async {  
  SharedPreferences prefs = await SharedPreferences.getInstance(); // Get shared preference instance
  String token = (prefs.getString('token') ?? ''); 
  var response = await http.get(
    Uri.encodeFull('$baseUrl/auth/verify'), 
    headers: {
      "content-type": "application/x-www-form-urlencoded",
      "token":token
    }
  ).catchError((e){
    print(e);
  });
  if(response.statusCode==200) {
    Map data = json.decode(response.body);
    return data['status'];
  } else {
    return 'error';
  }
}

Future<String> unstarNote(note) async {  
  SharedPreferences prefs = await SharedPreferences.getInstance(); // Get shared preference instance
  String token = (prefs.getString('token') ?? ''); 
  var response = await http.delete(
    Uri.encodeFull('$baseUrl/note-star/${note.id}'), 
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

Future<String> starNote(note) async {  
  SharedPreferences prefs = await SharedPreferences.getInstance(); // Get shared preference instance
  String token = (prefs.getString('token') ?? ''); 
  var response = await http.post(
    Uri.encodeFull('$baseUrl/note-star/${note.id}'), 
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

Future<List> getKeywords() async {
  SharedPreferences prefs = await SharedPreferences.getInstance(); 
  String token = (prefs.getString('token') ?? ''); 
  if(token=='') return [];
  var response = await http.get(
    Uri.encodeFull('$baseUrl/keywords?limit=16'),
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
      List data = _jsonData['results'];
      return data;
    }
    return [];
  }else{
    return [];
  }
}
Future<List> getNotes(int start,{bool isStar,bool isReverse}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance(); 
  String token = (prefs.getString('token') ?? ''); 
  if(token=='') return [];
  var response = await http.get(
    Uri.encodeFull('$baseUrl/note?startIndex=${start.toString()}&pageSize=${pageSize.toString()}&star=$isStar&reverse=$isReverse'),
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
Future<List> getNotesByKeywords(int start,keywords) async {
  SharedPreferences prefs = await SharedPreferences.getInstance(); 
  String token = (prefs.getString('token') ?? ''); 
  if(token=='') return [];
  var response = await http.get(
    Uri.encodeFull('$baseUrl/search/keywords?keywords=$keywords&startIndex=${start.toString()}&pageSize=${pageSize.toString()}'),
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
      List data = _jsonData['results'];
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

Future<String> deleteNote(note) async {  
  SharedPreferences prefs = await SharedPreferences.getInstance(); // Get shared preference instance
  String token = (prefs.getString('token') ?? ''); 
  var response = await http.delete(
    Uri.encodeFull('$baseUrl/note/${note.id}'), 
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

Future<String> postRegister(username,password) async {  
  var response = await http.post(
    Uri.encodeFull('$baseUrl/auth/register'),
    body: {"username": username,"password":password},
    headers: {"content-type": "application/x-www-form-urlencoded"}
  ).catchError((e){
    print(e);
  });
  if(response == null) return 'error';
  if(response.statusCode == 200) {
    var data = json.decode(response.body);
    if(data['errorCode'] == 1112) {
      return 'usernameTooLong';
    }

    if(data['errorCode'] == 113) {
      return 'duplicated'; 
    }
    return data['status'];
  } else {
    return 'error';
  }
}
