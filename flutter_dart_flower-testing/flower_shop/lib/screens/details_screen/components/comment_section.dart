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
  ////////////////
  int _rating = 0;
  int _currentPage = 0;
  late IO.Socket socket;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    futureComments = fetchCommentsByProduct(widget.productId);
    _setupSocket();
  }

  void _setupSocket() {
    socket = IO.io(
        'http://localhost:3001',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());

    socket.connect();

    socket.onConnect((_) {
      // print('Connected to socket.io server');
    });

    socket.on('newComment', (data) {
      Comment comment = Comment.fromJson(data);
      if (comment.productId == widget.productId) {
        if (mounted) {
          setState(() {
            comments.insert(0, comment);
            if (comments.length == 1) {
              futureComments = Future.value(comments);
            }
          });
        }
      }
    });

    socket.onDisconnect((_) {
      // print('Disconnected from socket.io server');
    });
  }

  Future<List<Comment>> fetchCommentsByProduct(String productId) async {
    final url = Uri.parse('http://localhost:3001/api/comment/$productId');
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
    setState(() {
      _isLoading = true;
    });
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

      if (username == null || username.isEmpty || avatar == null || avatar.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bạn chưa điền thông tin cá nhân')),
        );
        Navigator.pushNamed(context, EditProfileScreen.routeName);
        return;
      }

      final url = Uri.parse('http://localhost:3001/api/comment');
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
       
        setState(() {
          _isLoading = false;

        });
    
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gửi Thành Công')),
        );
        // if(comments.isEmpty){
        //   futureComments = fetchCommentsByProduct(widget.productId);  
        // }
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
      crossAxisAlignment: CrossAxisAlignment.start,
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              
              _isLoading ? 
                  Center(child: Image.asset('assets/images/send.gif'))
                : Center(
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
        const SizedBox(height: 10),
        const Divider(),
        const SizedBox(height: 20),
        FutureBuilder<List<Comment>>(
          future: futureComments, 
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Image.asset('assets/images/loadingflower.gif'));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No comments found'));
            } else {
              comments = snapshot.data!;
              int totalPages = (comments.length / 5).ceil();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        int endIndex = (startIndex + 5).clamp(0, comments.length);
                        List<Comment> pageComments = comments.sublist(startIndex, endIndex);
                        return ListView.builder(
                          itemCount: pageComments.length,
                          itemBuilder: (context, index) {
                            Comment comment = pageComments[index];
                            DateTime dated = comment.date;
                            String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(dated);
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              elevation: 4,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: imageFromBase64String(comment.avatar!).image,
                                ),
                                title: Text(
                                  comment.username!,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: Text(comment.content),
                                    ),
                                    Row(
                                      children: List.generate(comment.rating, (index) {
                                        return Icon(Icons.star, color: Colors.amber);
                                      }),
                                    ),
                                    Text(formattedDate,
                                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 15,),
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
                            color: _currentPage == index ? Colors.blue : Colors.grey,
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
        const SizedBox(height: 20),
        const Divider(),
      ],

    );
  }
}
