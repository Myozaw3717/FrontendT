import 'dart:convert';

import 'package:flutter_exe/config/app_config.dart';
import 'package:flutter_exe/model/category_data.dart';
import 'package:flutter_exe/model/create_category_model.dart';
import 'package:flutter_exe/model/create_user_model.dart';
import 'package:flutter_exe/model/get_user.dart';
import 'package:flutter_exe/model/update_user_model.dart';

import 'package:http/http.dart' as http;

class ApiService {
  Future<List<User>> fetchUsers() async {
    final url = Uri.parse(
      '${AppConfig.baseUrl}/api/v1/intern/users/',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> data =
       decoded is List ? decoded : decoded['results'];

       return data
         .map((item) => User.fromJson(item))
         .toList();
    }
    throw Exception(
      'Failed to load users: ${response.statusCode}',
    );
  }
  Future<void> deleteUser(int user_id) async{
    final url =Uri.parse(
      '${AppConfig.baseUrl}/api/v1/intern/users/$user_id/',
    );
    final response = await http.delete(
      url,
      headers: {
        'Accept':'application/json',
      },
    );
    if (response.statusCode == 200||
      response.statusCode == 202 ||
      response.statusCode == 204 ) {
        return;
      }
      throw Exception(
        'fail to delete user: ${response.statusCode}'
        '${response.body}'
      );
  }
  Future<User> createUser(CreateUser user) async {
    final url =Uri.parse(
      '${AppConfig.baseUrl}/api/v1/intern/users/',);



      final response = await http.post(url,
      headers:{
        'Content-Type':'application/json',
        'Accept':'application/json',

      },
      body : jsonEncode(user.toJson()),
    );
    if (response.statusCode == 200 ||
    response.statusCode == 201 ){
    return User.fromJson(jsonDecode(response.body));

  }
  throw Exception(
    'failed to create user: ${response.statusCode}'
  );
  }
  Future<List<Category>> fetchCategory() async{
    final url = Uri.parse(
      '${AppConfig.baseUrl}/api/v1/intern/categories/',
    );
  final response = await http.get(url);
  
  if (response.statusCode== 200){
    final decoded = jsonDecode(response.body);

    final List<dynamic> data = 
      decoded is List ? decoded : decoded['result'];

    return data
    .map((item) => Category.fromJson(item))
    .toList();

  }
  throw Exception(
    'Failed to load category: ${response.statusCode}',
  );

  }

  Future<void> deleteCategory(int category_id) async{
    final url = Uri.parse(
      '${AppConfig.baseUrl}/api/v1/intern/categories/$category_id/',
    );
    final response = await http.delete(
      url,
      headers: {
        'Accept':'application/json',
      },
    );
    if (response.statusCode==200 ||
        response.statusCode==202 ||
        response.statusCode==204){
          return;
        }

        throw Exception(
          'Failed to delete category: ${response.statusCode}'
          '${response.body}',
        );
  }


 Future<void> updateUser({
  required int user_id,
  required UpdateUser user,
 }) async {
  final url=Uri.parse(
    '${AppConfig.baseUrl}/api/v1/intern/users/$user_id/',

  );
  final response = await http.patch(
      url,
      headers: {
        'Content-Type':'application/json',
        'Accept':'application/json',
      },
      body: jsonEncode(user.toJson()),
    );
    if(response.statusCode==200 ||
       response.statusCode==202 ||
       response.statusCode==204){
         return;
       }
       throw Exception(
        'Failed to update user: ' 
        '${response.statusCode} ${response.body}',
       );
 }

 Future<Category> createCategory(CreateCategoryData category) async {
    final url = Uri.parse(
      '${AppConfig.baseUrl}/api/v1/intern/categories/',
    );
    
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(category.toJson()),
    );
    if(response.statusCode == 200 ||
       response.statusCode == 201) {
       return Category.fromJson(jsonDecode(response.body));

       }
  
  throw Exception(
    'Failed to create category: ${response.statusCode} ${response.body}',
  );
  
  }
}