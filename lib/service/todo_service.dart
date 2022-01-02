import 'dart:convert';

import 'package:flutter_packages/models/todo_model.dart';
import 'package:http/http.dart' as http;

class TodoService {
  static const _basicUrl = 'https://jsonplaceholder.typicode.com/';

  static Future<List<TodoModel>?> getTodos() async {
    var tempList = <TodoModel>[];
    var response = await http.get(Uri.parse('${_basicUrl}todos'));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      for (var item in jsonData) {
        tempList.add(TodoModel.fromJson(item));
      }
      return tempList;
    } else {
      print(response.body);
      print(response.statusCode);
      return null;
    }
  }

  static Future postTodo(TodoModel todoModel) async {
    var msg = {'title': 'veri', 'userId': '1', 'completed': 'true'};
    print(msg);
    print(todoModel.toJson());
    var response = await http.post(Uri.parse('${_basicUrl}todos'),
        body: todoModel.toJson());
    if (response.statusCode == 201) {
      print(response.body);
    } else {
      print('hata ${response.body}');
    }
  }

  static Future patchTodo(TodoModel todoModel)async{
    var msg = {
      'title':'yeni veri'
    };
    print(todoModel.toJson());
    print(json.encode(msg));
    var response = await http.patch(Uri.parse('${_basicUrl}todos/${todoModel.id}'),body:todoModel.toJsonTitle() );
    if(response.statusCode == 200){
      print(response.body);
    }else{
      print('hatalı ${response.statusCode}');
    }
  }

  static Future putTodo(TodoModel todoModel)async{
    var msg = {
      'title':'yeni veri'
    };
    var response = await http.put(Uri.parse('${_basicUrl}todos/${todoModel.id}'),body: json.encode(msg));
    if(response.statusCode == 200){
      print(response.body);
    }else{
      print('hatalı ${response.statusCode}');
    }
  }
  
  static Future<bool> deleteTodo(id)async{
    var response = await http.delete(Uri.parse('${_basicUrl}todos/$id'));
    if(response.statusCode == 200){
      return true;
    }else{
      return false;
    }
  }

}
