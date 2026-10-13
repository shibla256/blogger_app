import 'package:blogger_app/auth_provider.dart';
import 'package:blogger_app/blog_card.dart';
import 'package:blogger_app/blog_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> logout(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title:  Text('Logout'),
          content:  Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child:  Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child:  Text('Logout'),
            ),
          ],
        );
      },
    );

    if (result != true) return;
    if (!context.mounted) return;

    await context.read<AuthProvider>().logout();

    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final blogProvider = context.watch<BlogProvider>();

    if (user == null) {
      return  Scaffold(body: SizedBox());
    }

    final myBlogs = blogProvider.getBlogsByAuthor(user.email);

    return Scaffold(
      appBar: AppBar(
        title:  Text('Profile'),
        actions: [
          IconButton(
            icon:  Icon(Icons.logout),
            onPressed: () {
              logout(context);
            },
          ),
        ],
      ),
      body: ListView(
        children: [
           SizedBox(height: 24),
          Center(
            child: CircleAvatar(
              radius: 45,
              backgroundColor: const Color.fromARGB(255, 13, 14, 14),
              child: Text(
                user.name[0].toUpperCase(),
                style:  TextStyle(fontSize: 36, color: const Color.fromARGB(255, 225, 209, 209)),
              ),
            ),
          ),
           SizedBox(height: 12),
          Center(
            child: Text(
              user.name,
              style:  TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Center(child: Text(user.email)),
           SizedBox(height: 12),
          Center(child: Text('${myBlogs.length} blogs written')),
           Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 4),
            child: Text(
              'My Blogs',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          if (myBlogs.isEmpty)
             Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text("You haven't written any blogs yet")),
            ),

          for (var blog in myBlogs) BlogCard(blog: blog),

           SizedBox(height: 16),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: () {
                logout(context);
              },
              icon:  Icon(Icons.logout, color: Colors.red),
              label:  Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ),
           SizedBox(height: 24),
        ],
      ),
    );
  }
}