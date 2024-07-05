class Comment {
  final String id;
  final String productId;
  final String userId;
  final String content;
  final int rating;
  String? username;
  String? avatar;
  final DateTime date;

  Comment({
    required this.id,
    required this.productId,
    required this.userId,
    required this.content,
    required this.rating,
    this.username,
    this.avatar,
    required this.date,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'],
      productId: json['product'],
      userId: json['user']['_id'],
      content: json['content'],
      rating: json['rating'],
      username: json['user']['name'] ?? 'Ẩn Danh',  // Assumes nested user object
      avatar: json['user']['avatar'] ?? 'NoAvatar',      // Assumes nested user object
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'product': productId,
      'user': userId,
      'content': content,
      'rating': rating,
      'username': username,
      'avatar': avatar,
      'date': date.toIso8601String(),
    };
  }
}
