import 'package:flutter/material.dart';
import 'package:flutter_app/entities/message.dart';
import 'package:intl/intl.dart';

import '../entities/user.dart';

class ChatBubble extends StatefulWidget {
  final Message message;
  final User? currentUser;

  const ChatBubble({super.key, required this.message, this.currentUser});

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}
class _ChatBubbleState extends State<ChatBubble> {
  bool _isDateVisible = false;
  @override
  Widget build(BuildContext context) {
    bool isCurrentUser = widget.currentUser?.username == widget.message.user.username;
    return GestureDetector(
      onTap: () {
        setState(() {
          _isDateVisible = !_isDateVisible;
        });
      },
      child: Container(
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            color: isCurrentUser ? Colors.blue[300] : Colors.grey[600],
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.message.user.username}:',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.message.content,
              ),
              if(_isDateVisible)
                Text(
                  DateFormat('yyyy-MM-dd HH:mm').format(widget.message.sentAt),
                  style: const TextStyle(
                    fontSize: 10,
                  ),
                )
            ],
          ),
        ),
      )
    );
  }
}