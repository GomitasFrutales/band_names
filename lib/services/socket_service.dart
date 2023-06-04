// ignore_for_file: constant_identifier_names, avoid_print, prefer_final_fields, unused_field, library_prefixes

import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus{
  Online,
  Offline,
  Connecting,
}
     
class SocketService with ChangeNotifier{
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  Function get emit => _socket.emit;
  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;
     
  SocketService(){
    _initConfig();
  }
     
  void _initConfig(){  
    _socket = IO.io(
      "http://192.168.0.8:3000",
      IO.OptionBuilder()
        .setTransports(['websocket'])
        .enableAutoConnect() 
        .build()
    );
     
    _socket.onConnect((_) {
      //socket.emit('mensaje', 'conectado desde app Flutter');
      //print('connected');
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      //print('disconnected');
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    /*_socket.on('nuevo-mensaje', (payload){
      print('nuevo-mensaje:');
      print('nombre: $payload[nombre]');
      print('mensaje: $payload[mensaje]');
      print(payload.containsKey('mensaje2') ? payload['mensaje2'] : '');
    });*/
  }
}
