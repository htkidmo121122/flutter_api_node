import 'package:flutter/material.dart';
import 'package:health_care/constants.dart';
import 'package:health_care/screens/info_screen/edit_profile.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../../models/Comment.dart';

class CommentsSection extends StatefulWidget {
  final String productId;

  const CommentsSection({required this.productId, Key? key}) : super(key: key);

  @override
  _CommentsSectionState createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  late Future<List<Comment>> futureComments;
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  List<Comment> comments = [];
  int _rating = 0;
  int _currentPage = 0;
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    futureComments = fetchCommentsByProduct(widget.productId);
    _setupSocket();
  }

  void _setupSocket() {
    socket = IO.io(
        'http://10.0.2.2:3001',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());

    socket.connect();

    socket.onConnect((_) {
      // print('Connected to socket.io server');
    });

    // Lắng nghe sự kiện newComment và cập nhật danh sách bình luận khi có bình luận mới từ server.
    socket.on('newComment', (data) {
      Comment comment = Comment.fromJson(data);
      if (comment.productId == widget.productId) {
        if (mounted) {
          setState(() {
            comments.insert(0, comment);  // Thêm comment vào đầu danh sách
          });
        }
      }
    });

    socket.onDisconnect((_) {
      // print('Disconnected from socket.io server');
    });
  }

  Future<List<Comment>> fetchCommentsByProduct(String productId) async {
    final url = Uri.parse('http://10.0.2.2:3001/api/comment/$productId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Comment> comments =
          body.map((dynamic item) => Comment.fromJson(item)).toList();
      comments.sort((a, b) => b.date.compareTo(a.date));
      return comments;
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<void> _addComment(String content, int rating) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('user_data');

    if (userDataString == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bạn chưa đăng nhập')),
      );
      return;
    }

    try {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      final userId = userData['_id'];
      final username = userData['name'];
      final avatar = userData['avatar'];

      // Kiểm tra thông tin cá nhân
      if (username == null ||
          username.isEmpty ||
          avatar == null ||
          avatar.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bạn chưa điền thông tin cá nhân')),
        );
        Navigator.pushNamed(context, EditProfileScreen.routeName);
        return;
      }
      final url = Uri.parse('http://10.0.2.2:3001/api/comment');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'productId': widget.productId,
          'userId': userId,
          'content': content,
          'rating': rating,
        }),
      );

      if (response.statusCode == 201) {
        _commentController.clear();
        _ratingController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gửi Thành Công')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bạn chưa điền bình luận và đánh giá')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Image imageFromBase64String(String base64String) {
    String base64Image = base64String.split(',').last;
    return Image.memory(base64Decode(base64Image));
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: 'Thêm bình luận',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(12.0),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Đánh giá:',
                    style: TextStyle(fontSize: 16),
                  ),
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          if (mounted) {
                            setState(() {
                              _rating = index + 1;
                            });
                          }
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    String content = _commentController.text;
                    if (mounted) {
                      _addComment(content, _rating);
                    }
                  },
                  child: Text(
                    'Gửi',
                    style: TextStyle(color: white, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 12.0),
                      backgroundColor: kcolorminor),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        FutureBuilder<List<Comment>>(
          future: futureComments,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No comments found');
            } else {
              comments = snapshot.data!;
              int totalPages = (comments.length / 5).ceil();
              return Column(
                children: [
                  SizedBox(
                    height: 500,
                    child: PageView.builder(
                      itemCount: totalPages,
                      onPageChanged: (page) {
                        if (mounted) {
                          setState(() {
                            _currentPage = page;
                          });
                        }
                      },
                      itemBuilder: (context, pageIndex) {
                        int startIndex = pageIndex * 5;
                        int endIndex =
                            (startIndex + 5).clamp(0, comments.length);
                        List<Comment> pageComments =
                            comments.sublist(startIndex, endIndex);
                        return ListView.builder(
                          itemCount: pageComments.length,
                          itemBuilder: (context, index) {
                            Comment comment = pageComments[index];
                            DateTime dated = comment.date;
                            String formattedDate =
                                DateFormat('dd/MM/yyyy HH:mm').format(dated);
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    imageFromBase64String(comment.avatar!)
                                        .image,
                              ),
                              title: Text(comment.username!),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(comment.content),
                                  Row(
                                    children:
                                        List.generate(comment.rating, (index) {
                                      return Icon(Icons.star,
                                          color: Colors.amber);
                                    }),
                                  ),
                                  Text(formattedDate,
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(totalPages, (index) {
                      return GestureDetector(
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              _currentPage = index;
                            });
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          width: 12.0,
                          height: 12.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? Colors.blue
                                : Colors.grey,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }
}
