import 'package:blogger_app/blog_card.dart';
import 'package:blogger_app/blog_provider.dart';
import 'package:blogger_app/categories_screen.dart';
import 'package:blogger_app/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const AllBlogsPage(),
      const CategoriesScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: pages[currentIndex],

      floatingActionButton: currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(context, '/create');
              },
              icon: Icon(Icons.add),
              label: Text('Write'),
            )
          : null,

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(icon: Icon(Icons.home_filled), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.category_outlined),
            label: 'Categories',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class AllBlogsPage extends StatelessWidget {
  const AllBlogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final blogProvider = context.watch<BlogProvider>();
    final blogs = blogProvider.blogs;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 239, 239),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 28, 10, 10),
        title: Text('All Blogs', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
        ],
      ),
      body: blogs.isEmpty
          ? Center(child: Text('No blogs yet. Tap "Write" to add one!'))
          : ListView.builder(
              padding: EdgeInsets.only(bottom: 90),
              itemCount: blogs.length,
              itemBuilder: (context, index) {
                return BlogCard(blog: blogs[index]);
              },
            ),
    );
  }
}
