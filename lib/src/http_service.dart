import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'note.dart';
final String baseUrl = "http://rorrc.3322.org:6664";
Future<List> getNotes(int pageNum,int pageSize) async {
  var response = await http.get(
      Uri.encodeFull('$baseUrl/notes?pageNum=${pageNum.toString()}&pageSize=${pageSize.toString()}'),
      headers: {"Accept": "application/json"}
  );
  Map _jsonData = json.decode(response.body);
  List data = _jsonData['data'];
  List<Note> notes = data.map((note)=> Note.fromJson(note)).toList(); 
  return notes;
}
Future<List> getSimilar(int noteId) async {
  var response = await http.get(
      Uri.encodeFull('$baseUrl/getSimilar/$noteId'),
      headers: {"Accept": "application/json"}
  );
  // Map _jsonData 
  List data = json.decode(response.body);
  List<Note> notes = data.map((note)=> Note.fromJson(note)).toList(); 
  return notes;
}

