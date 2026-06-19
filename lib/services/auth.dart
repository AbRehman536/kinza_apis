import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kinza_apis/models/login.dart';
import 'package:kinza_apis/models/register.dart';
import 'package:kinza_apis/models/user.dart';

class AuthServices{
  String baseURL = "https://todo-nu-plum-19.vercel.app/";
  ///Register User
  Future<RegisterModel> registerUser({
    required String name,
    required String email,
    required String password,
})async{
    try{
      http.Response response = await http.post(
        Uri.parse("$baseURL/users/register"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
        }),
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        return RegisterModel.fromJson(jsonDecode(response.body));
      }else{
        throw Exception("Failed to register user");
      }
    }
    catch(e){
      throw Exception(e.toString());
    }
  }
  ///Login User
  Future<LoginModel> loginUser({
    required String email,
    required String password,
  })async{
    try{
      http.Response response = await http.post(
        Uri.parse("$baseURL/users/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        return LoginModel.fromJson(jsonDecode(response.body));
      }else{
        throw Exception("Failed to register user");
      }
    }
    catch(e){
      throw Exception(e.toString());
    }
  }
  ///Get User
  Future<UserModel> getUser({
    required String token,
  })async{
    try{
      http.Response response = await http.get(
        Uri.parse("$baseURL/users/profile"),
        headers: {'Authorization': token},
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        return UserModel.fromJson(jsonDecode(response.body));
      }else{
        throw Exception("Failed to register user");
      }
    }
    catch(e){
      throw Exception(e.toString());
    }
  }
  ///Update User
  Future<bool> updateUser({
    required String token,
    required String name
  })async{
    try{
      http.Response response = await http.put(
        Uri.parse("$baseURL/users/profile"),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": name,
        }),
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        return true;
      }else{
        throw Exception("Failed to register user");
      }
    }
    catch(e){
      throw Exception(e.toString());
    }
  }
}