import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/entities/message.dart';
import 'package:flutter_app/screens/base_screen.dart';
import 'package:flutter_app/services/chat_service.dart';
import 'package:flutter_app/widgets/chat_bubble.dart';
import 'package:flutter_app/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

import '../../entities/user.dart';
import '../../providers/user_provider.dart';

class TripChatScreen extends StatefulWidget {
  final int tripId;

  const TripChatScreen({super.key, required this.tripId});

  @override
  _TripChatScreenState createState() => _TripChatScreenState();
}

class _TripChatScreenState extends State<TripChatScreen> with WidgetsBindingObserver {
  List<Message> messages = [];
  final messageController = TextEditingController();
  final ChatService chatService = ChatService();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    chatService.onMessageReceived = (message) {
      setState(() {
        messages.add(message);
      });
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    };
    _connectToServerAndLoadMessages();
  }

  Future<void> _connectToServerAndLoadMessages() async {
    await chatService.connectToServer();
    await chatService.joinTripChat(widget.tripId);
    messages = await chatService.getTripMessages(widget.tripId);
    setState(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    chatService.leaveTripChat(widget.tripId);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).user;
    bool loggedIn = user != null;
    return BaseScreen(
        title: 'Trip Chat',
        loggedIn: loggedIn,
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints){
                  return Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),  // Add this line
                    child: Flex(
                        direction: Axis.vertical,
                        children: [
                          Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                return ChatBubble(message: messages[index], currentUser: user);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: messageController,
                                    decoration: const InputDecoration(hintText: 'Type a message'),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.send),
                                  onPressed: () async {
                                    await chatService.sendMessage(widget.tripId, messageController.text);
                                    messageController.clear();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ]
                    ),
                  );
                }
            )
        )
    );
  }
}