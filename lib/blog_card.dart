import 'package:blogger_app/blog_detail_screen.dart';
import 'package:blogger_app/blog_model.dart';
import 'package:flutter/material.dart';


class BlogCard extends StatelessWidget {
  final BlogModel blog;

  const BlogCard({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin:  EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlogDetailsScreen(blog: blog),
            ),
          );
        },
        child: Padding(
          padding:  EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Chip(label: Text(blog.category)),
               SizedBox(height: 8),
              Text(
                blog.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:  TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
               SizedBox(height: 6),
              Text(
                blog.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
               SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('By ${blog.authorName}'),
                  Text(blog.date),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}