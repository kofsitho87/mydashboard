import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../models/User.dart';

class FileStorage {
  final String tag;
  final Future<Directory> Function() getDirectory;

  const FileStorage(
    this.tag,
    this.getDirectory,
  );

  // Future<List<TodoEntity>> loadTodos() async {
  //   final file = await _getLocalFile();
  //   final string = await file.readAsString();
  //   final json = JsonDecoder().convert(string);
  //   final todos = (json['todos'])
  //       .map<TodoEntity>((todo) => TodoEntity.fromJson(todo))
  //       .toList();

  //   return todos;
  // }

  // Future<File> saveTodos(List<TodoEntity> todos) async {
  //   final file = await _getLocalFile();

  //   return file.writeAsString(JsonEncoder().convert({
  //     'todos': todos.map((todo) => todo.toJson()).toList(),
  //   }));
  // }

  Future<User> loadUser() async {
    final file = await _getLocalFile();
    final string = await file.readAsString();
    final json = JsonDecoder().convert(string);
    
    return User.fromJson(json['user']);
  }

  Future<File> saveUser(User user) async{
    final file = await _getLocalFile();
    return file.writeAsString(JsonEncoder().convert({
      'user': user.toJson(),
    }));
  }


  Future<String> loadTodosFilter() async {
    final file = await _getLocalFile();
    final string = await file.readAsString();
    final json = JsonDecoder().convert(string);
    return json['todos_filter'];
  }

  Future<File> saveTodosFilter(String filter) async {
    final file = await _getLocalFile();
    return file.writeAsString(JsonEncoder().convert({
      'todos_filter': filter,
    }));
  }


  Future<File> _getLocalFile() async {
    final dir = await getDirectory();
    //print(dir);
    return File('${dir.path}/ArchSampleStorage__$tag.json');
  }

  Future<FileSystemEntity> clean() async {
    final file = await _getLocalFile();

    return file.delete();
  }
}