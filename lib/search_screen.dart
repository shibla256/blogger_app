import 'package:blogger_app/blog_card.dart';
import 'package:blogger_app/blog_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = TextEditingController();
  String query = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = context.watch<BlogProvider>().searchBlogs(query);

    Widget body;
    if (query.trim().isEmpty) {
      body =  Center(child: Text('Type to search blogs'));
    } else if (results.isEmpty) {
      body =  Center(child: Text('No blogs found'));
    } else {
      body = ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          return BlogCard(blog: results[index]);
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          autofocus: true,
          decoration:  InputDecoration(
            hintText: 'Search blogs...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              query = value;
            });
          },
        ),
      ),
      body: body,
    );
  }
}