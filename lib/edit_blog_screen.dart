import 'package:blogger_app/blog_model.dart';
import 'package:blogger_app/blog_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditBlogScreen extends StatefulWidget {
  final BlogModel blog;

  const EditBlogScreen({super.key, required this.blog});

  @override
  State<EditBlogScreen> createState() => _EditBlogScreenState();
}

class _EditBlogScreenState extends State<EditBlogScreen> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController contentController;
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.blog.title);
    contentController = TextEditingController(text: widget.blog.content);
    selectedCategory = widget.blog.category;
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  Future<void> updateBlog() async {
    if (!formKey.currentState!.validate()) return;

    await context.read<BlogProvider>().updateBlog(
      id: widget.blog.id,
      title: titleController.text.trim(),
      content: contentController.text.trim(),
      category: selectedCategory,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Blog updated')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.read<BlogProvider>().categories;

    return Scaffold(
      appBar: AppBar(title: Text('Edit Blog')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: categories.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: contentController,
                minLines: 8,
                maxLines: 20,
                decoration: InputDecoration(
                  labelText: ' your blog...',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().length < 10) {
                    return 'Write at least 10 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: updateBlog,
                  child: Text('Update Blog'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
