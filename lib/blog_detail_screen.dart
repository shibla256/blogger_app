import 'package:blogger_app/auth_provider.dart';
import 'package:blogger_app/blog_model.dart';
import 'package:blogger_app/blog_provider.dart';
import 'package:blogger_app/edit_blog_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class BlogDetailsScreen extends StatelessWidget {
  final BlogModel blog;

  const BlogDetailsScreen({super.key, required this.blog});

  Future<void> confirmDelete(BuildContext context, BlogModel b) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title:  Text('Delete Blog?'),
          content:  Text('This cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child:  Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child:  Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (result != true) return;
    if (!context.mounted) return;

    await context.read<BlogProvider>().deleteBlog(b.id);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Blog deleted')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final blogs = context.watch<BlogProvider>().blogs;
    final currentUser = context.read<AuthProvider>().user;

    BlogModel b = blog;
    for (BlogModel item in blogs) {
      if (item.id == blog.id) {
        b = item;
      }
    }

    final isOwner = currentUser != null && currentUser.email == b.authorEmail;

    return Scaffold(
      appBar: AppBar(
        title:  Text('Blog Details'),
        actions: [
          if (isOwner)
            IconButton(
              icon:  Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditBlogScreen(blog: b),
                  ),
                );
              },
            ),
          if (isOwner)
            IconButton(
              icon:  Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                confirmDelete(context, b);
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding:  EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chip(label: Text(b.category)),
             SizedBox(height: 8),
            Text(
              b.title,
              style:  TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
             SizedBox(height: 12),
            Text('By ${b.authorName}  |  ${b.date}'),
             Divider(height: 30),
            Text(
              b.content,
              style:  TextStyle(fontSize: 16, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}