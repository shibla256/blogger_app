class BlogModel {
  String id;
  String title;
  String content;
  String category;
  String authorName;
  String authorEmail;
  String date;
  String imagePath; 
  BlogModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.authorName,
    required this.authorEmail,
    required this.date,
    this.imagePath = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'authorName': authorName,
      'authorEmail': authorEmail,
      'date': date,
      'imagePath': imagePath,
    };
  }

  factory BlogModel.fromMap(Map<String, dynamic> map) {
    return BlogModel(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      category: map['category'],
      authorName: map['authorName'],
      authorEmail: map['authorEmail'],
      date: map['date'],
      imagePath: map['imagePath'] ?? '',
    );
  }
}