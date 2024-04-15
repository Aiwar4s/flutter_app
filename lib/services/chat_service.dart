import 'dart:convert';

import 'package:flutter_app/api_constants.dart';
import 'package:flutter_app/entities/message.dart';
import 'package:flutter_app/services/auth/auth_service.dart';
import 'package:flutter_app/services/auth/secure_storage_service.dart';
import 'package:signalr_netcore/ihub_protocol.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:http/http.dart' as http;

class ChatService {
  HubConnection? connection;
  Function(Message)? onMessageReceived;

  Future<void> connectToServer() async{
    if(connection != null){
      return;
    }
    AuthService().refreshToken();
    String? token = await SecureStorageService().readAccessToken();
    if(token == null){
      throw Exception('No access token found');
    }
    final defaultHeaders = MessageHeaders();
    defaultHeaders.setHeaderValue('Authorization', 'Bearer $token');
    final httpConnectionOptions = HttpConnectionOptions(
      transport: HttpTransportType.WebSockets,
      accessTokenFactory: () => Future.value(token),
      headers: defaultHeaders,
    );
    connection = HubConnectionBuilder().withUrl(
        ApiConstants.hubUrl,
        options: httpConnectionOptions
    ).build();

    connection!.on('ReceiveMessage', (message){
      if(onMessageReceived != null && message?[0] is Map<String, dynamic>){
        onMessageReceived!(Message.fromJson(message?[0] as Map<String, dynamic>));
      }
    });

    await connection!.start();
  }

  Future<void> joinTripChat(int tripId) async {
    await connectToServer();
    await connection!.invoke('JoinTripChat', args: [tripId]);
  }

  void leaveTripChat(int tripId) async {
    await connection!.invoke('LeaveTripChat', args: [tripId]);
  }

  Future<void> sendMessage(int tripId, String message) async {
    await connectToServer();
    connection!.invoke('SendMessage', args: [tripId, message]);
  }

  Future<List<Message>> getTripMessages(int tripId) async {
    AuthService().refreshToken();
    final accessToken = await SecureStorageService().readAccessToken();
    final response = await http.get(Uri.parse('${ApiConstants.trips}/$tripId/messages'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken'
      });
    if(response.statusCode == 200){
      List<dynamic> body = jsonDecode(response.body);
      return body.map((message) => Message.fromJson(message)).toList();
    }
    else {
      throw Exception('Failed to load messages');
    }
  }
}