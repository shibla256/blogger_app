import 'dart:convert';
import 'package:blogger_app/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  List<UserModel> users = []; 
  UserModel? user;

  get currentUser => null;
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    final savedUser = prefs.getStringList('users') ?? [];
    users = [];
    for (String item in savedUser) {
      users.add(UserModel.fromMap(jsonDecode(item)));
    }

    final savedEmail = prefs.getString('currentEmail');
    user = null;
    if (savedEmail != null) {
      for (UserModel u in users) {
        if (u.email == savedEmail) {
          user = u;
        }
      }
    }
    notifyListeners();
  }

  Future<void> saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> list = [];
    for (UserModel u in users) {
      list.add(jsonEncode(u.toMap()));
    }
    await prefs.setStringList('users', list);
  }

  Future<String?> signUp(String name, String email, String password) async {
    for (UserModel u in users) {
      if (u.email == email) {
        return 'This email is already registered';
      }
    }

    final newUser = UserModel(name: name, email: email, password: password);
    users.add(newUser);
    await saveUsers();

    user = newUser;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentEmail', email);

    notifyListeners();
    return null;
  }

  Future<String?> login(String email, String password) async {
    for (UserModel u in users) {
      if (u.email == email && u.password == password) {
        user = u;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('currentEmail', email);
        notifyListeners();
        return null;
      }
    }
    return 'Wrong email or password';
  }

  Future<void> logout() async {
    user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentEmail');
    notifyListeners();
  }
}