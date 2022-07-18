// ignore_for_file: prefer_const_declarations

import 'dart:convert';
import 'dart:ffi';
import 'package:alert/alert.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/data/model/activityApi.dart';
import 'package:to_do/data/model/taskApi.dart';
import 'package:to_do/data/model/todoApi.dart';

import '../data/model/todoCount.dart';
import '../data/model/userApi.dart';

class ApiService {
  static final String _baseUrl = "http://uyich-production.herokuapp.com";
  static final String _registerUrl = "register";
  static final String _loginUrl = "login";
  static final String _taskUrl = "task";
  static final String _taskDoneUrl = "taskDone";
  static final String _todoDoneUrl = "todoDone";
  static final String _todoHasnt = "todoHasnt";
  static final String _todo = "todo";
  static final String _todoUpdate = "updateTodo";
  static final String _userUrl = "user";
  static final String _activityUrl = "activity";
  static final String _createTask = "createTask";
  static final String _taskUpdate = "updateTask";
  static final String _createTodo = "createTodo";
  static final String _deleteTodo = "hapusTodo";
  static final String _deleteTask = "hapusTask";
  static final String _perbaruiTodo = "perbaruiTodo";
  static final String _userUpdate = "updateUser";
  static final String _calUpdate = "cal";
  // static late String _idTodo;

  Future saveUser(String name, String username, String password) async {
    Uri urlApi = Uri.parse(_baseUrl + "/$_registerUrl");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final response = await http.post(urlApi,
        body: jsonEncode(
            {"name": name, "username": username, "password": password}),
        headers: requestHeaders);
    if (response.statusCode == 422) {
      Alert(message: jsonDecode(response.body)["messege"], shortDuration: true)
          .show();
      return false;
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future logUser(String username, String password) async {
    Uri urlApi = Uri.parse(_baseUrl + "/$_loginUrl");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final response = await http.post(urlApi,
        body: jsonEncode({
          "username": username.toLowerCase(),
          "password": password,
        }),
        headers: requestHeaders);
    print(response.body);
    if (response.statusCode == 422) {
      Alert(message: jsonDecode(response.body)["messege"], shortDuration: true)
          .show();
      return false;
    }
    if (response.statusCode == 200) {
      await sharedPreferences.setInt(
          "id", jsonDecode(response.body)["data"]["id"]);
      await sharedPreferences.setString(
          "name", jsonDecode(response.body)["data"]["name"]);
      await sharedPreferences.setString(
          "gender", jsonDecode(response.body)["data"]["gender"]);
      if (jsonDecode(response.body)["data"]["identity"] != null) {
        await sharedPreferences.setString(
            "identity", jsonDecode(response.body)["data"]["identity"]);
      } else {
        return true;
      }
      return true;
    } else {
      return false;
    }
  }

  Future<UserApi> userData(id) async {
    Uri urlApi = Uri.parse(_baseUrl + "/$_userUrl" + "/$id");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.get(urlApi, headers: requestHeaders);
    if (response.statusCode == 200) {
      return userApiFromJson(response.body.toString());
    } else {
      throw Exception('Failed To Load');
    }
  }

  Future taskData(id) async {
    Uri urlApi = Uri.parse(_baseUrl + "/$_taskUrl" + "/$id");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.get(urlApi, headers: requestHeaders);
    if (response.statusCode == 200) {
      return taskApiFromJson(response.body.toString());
    } else {
      throw Exception('Failed To Load');
    }
  }

  Future taskDone(id) async {
    Uri urlApi = Uri.parse(_baseUrl + "/$_taskDoneUrl" + "/$id");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.get(urlApi, headers: requestHeaders);
    if (response.statusCode == 200) {
      return taskApiFromJson(response.body.toString());
    } else {
      throw Exception('Failed To Load');
    }
  }

  Future addTask(int id_user, String title) async {
    Uri urlApi = Uri.parse(_baseUrl + "/$_createTask");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final response = await http.post(urlApi,
        body: jsonEncode({
          "id_user": id_user,
          "title": title,
        }),
        headers: requestHeaders);
    if (response.statusCode == 422) {
      await sharedPreferences.setString(
          "failTask", jsonDecode(response.body)["messege"]);
      return false;
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<ActivityApi> activityData() async {
    Uri urlApi = Uri.parse(_baseUrl + "/$_activityUrl");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.get(urlApi, headers: requestHeaders);
    if (response.statusCode == 200) {
      return activityApiFromJson(response.body.toString());
    } else {
      throw Exception('Failed To Load');
    }
  }

  Future<TodoApi> todoDataCompleted(id) async {
    Uri urlApi = Uri.parse(_baseUrl + "/$_todoDoneUrl" + "/$id");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.get(urlApi, headers: requestHeaders);
    if (response.statusCode == 200) {
      return todoApiFromJson(response.body.toString());
    } else {
      throw Exception('Failed To Load');
    }
  }

  Future<TodoApi> todoDataInComplete(id) async {
    Uri urlApi = Uri.parse(_baseUrl + "/$_todoHasnt" + "/$id");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.get(urlApi, headers: requestHeaders);
    if (response.statusCode == 200) {
      return todoApiFromJson(response.body.toString());
    } else {
      throw Exception('Failed To Load');
    }
  }

  Future<TaskCountApi> todoCount(id) async {
    Uri urlApi = Uri.parse(_baseUrl + "/$_todo" + "/$id");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.get(urlApi, headers: requestHeaders);
    if (response.statusCode == 200) {
      return taskCountApiFromJson(response.body.toString());
    } else {
      throw Exception('Failed To Load');
    }
  }

  Future updateTodo(String active, id) async {
    Uri urlApi = Uri.parse(_baseUrl + "/$_todoUpdate" + "/$id");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.put(urlApi,
        body: jsonEncode({
          "active": active,
        }),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future updateTask(String? percentage, id) async {
    Uri urlApi = Uri.parse(_baseUrl + "/$_taskUpdate" + "/$id");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.put(urlApi,
        body: jsonEncode({"percentage": percentage}), headers: requestHeaders);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future perbaruiTask(String title, id) async {
    Uri urlApi = Uri.parse(_baseUrl + "/$_taskUpdate" + "/$id");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.put(urlApi,
        body: jsonEncode({"title": title}), headers: requestHeaders);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future addTodo(int id_task, String title, String active, String priority,
      String deadline) async {
    Uri urlApi = Uri.parse(_baseUrl + "/$_createTodo");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    // ignore: unnecessary_null_comparison

    final response = await http.post(urlApi,
        body: jsonEncode({
          "task_id": id_task,
          "title": title,
          "active": active,
          "priority": priority,
          "deadline": deadline,
        }),
        headers: requestHeaders);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<TodoApi> deleteTodo(id) async {
    Uri urlApi = Uri.parse(_baseUrl + "/$_deleteTodo" + "/$id");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.delete(urlApi, headers: requestHeaders);
    if (response.statusCode == 200) {
      return todoApiFromJson(response.body.toString());
    } else {
      throw Exception('Failed To Load');
    }
  }

  Future<TodoApi> deleteTask(id) async {
    Uri urlApi = Uri.parse(_baseUrl + "/$_deleteTask" + "/$id");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.delete(urlApi, headers: requestHeaders);
    if (response.statusCode == 200) {
      return todoApiFromJson(response.body.toString());
    } else {
      throw Exception('Failed To Load');
    }
  }

  Future perbaruiToDo(String title, String deadline, id) async {
    Uri urlApi = Uri.parse(_baseUrl + "/$_perbaruiTodo" + "/$id");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.put(urlApi,
        body: jsonEncode({"title": title, "deadline": deadline}),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future updateUser(String username, String name, String identity,
      String imageUrl, id) async {
    Uri urlApi = Uri.parse(_baseUrl + "/$_userUpdate" + "/$id");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.put(urlApi,
        body: jsonEncode({
          "username": username,
          "name": name,
          "identity": identity,
          "image_url": imageUrl,
        }),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future updateCal(String cal, String gender, id) async {
    Uri urlApi = Uri.parse(_baseUrl + "/$_calUpdate" + "/$id");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    final response = await http.put(urlApi,
        body: jsonEncode({
          "cal": cal,
          "gender": gender,
        }),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
