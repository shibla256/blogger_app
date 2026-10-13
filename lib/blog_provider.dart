import 'dart:convert';
import 'package:blogger_app/blog_model.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class BlogProvider extends ChangeNotifier {
  List<BlogModel> blogs = [];

  List<String> categories = [
    'Technology',
    'Travel',
    'Food',
    'Lifestyle',
    'Education',
    'Health',
    'Sports',
    'Other',
  ];

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('blogs') ?? [];
    blogs = [];
    for (String item in saved) {
      blogs.add(BlogModel.fromMap(jsonDecode(item)));
    }
    notifyListeners();
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> list = [];
    for (BlogModel b in blogs) {
      list.add(jsonEncode(b.toMap()));
    }
    await prefs.setStringList('blogs', list);
  }

  Future<void> addBlog({
    required String title,
    required String content,
    required String category,
    required String authorName,
    required String authorEmail,
  }) async {
    final blog = BlogModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      category: category,
      authorName: authorName,
      authorEmail: authorEmail,
      date: DateTime.now().toString().substring(0, 10),
    ); 
    blogs.insert(0, blog); 
    await save();
    notifyListeners();
  }

  Future<void> updateBlog({
    required String id,
    required String title,
    required String content,
    required String category,
  }) async {
    for (BlogModel b in blogs) {
      if (b.id == id) {
        b.title = title;
        b.content = content;
        b.category = category;
      }
    }
    await save();
    notifyListeners();
  }

  Future<void> deleteBlog(String id) async {
    blogs.removeWhere((b) => b.id == id);
    await save();
    notifyListeners();
  }

  List<BlogModel> searchBlogs(String query) {
    List<BlogModel> result = [];
    String q = query.trim().toLowerCase();
    if (q.isEmpty) return result;

    for (BlogModel b in blogs) {
      if (b.title.toLowerCase().contains(q) ||
          b.content.toLowerCase().contains(q) ||
          b.category.toLowerCase().contains(q)) {
        result.add(b);
      }
    }
    return result;
  }

  List<BlogModel> getBlogsByCategory(String category) {
    return blogs.where((b) => b.category == category).toList();
  }

  List<BlogModel> getBlogsByAuthor(String email) {
    return blogs.where((b) => b.authorEmail == email).toList();
  }

  Future<void> loadBlogs() async {}
}