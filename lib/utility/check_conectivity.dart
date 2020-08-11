import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_offline/flutter_offline.dart';

class CheckConnectivity {
  CheckConnectivity._internal();

  static final CheckConnectivity _instance = CheckConnectivity._internal();

  static CheckConnectivity get instance => _instance;

  Connectivity connectivity = Connectivity();

  StreamController controller = StreamController.broadcast();

  String _connectionType = "None";
  bool _isOnline = false;

  Stream get myStream => controller.stream;

  void initialise() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    _checkStatus(result);
    _setConnectionType(result);

    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
      _setConnectionType(result);
    });
  }

  void setStatus(bool isOnline) {
    this._isOnline = isOnline;
  }

  bool getStatusOnline() {
    return _isOnline;
  }

  String getConnectionType() {
    return _connectionType;
  }

  void _setConnectionType(ConnectivityResult result) {
    String cType;

    switch (result) {
      case ConnectivityResult.none:
        cType = "Internet is Offline";
        break;
      case ConnectivityResult.mobile:
        cType = "Mobile: Online";
        break;
      case ConnectivityResult.wifi:
        cType = "WiFi: Online";
        break;
    }

    _connectionType = cType;
    // print(_connectionType);
  }

  Future<bool> checkInternetConnection(ConnectivityResult result) async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else
        return false;
    } on SocketException catch (_) {
      return false;
    }
  }

  void _checkStatus(ConnectivityResult result) async {
    print("STATUS RESULT : ");
    print(result);

    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else
        isOnline = false;
    } on SocketException catch (_) {
      isOnline = false;
    }

    setStatus(!isOnline);
    controller.sink.add({result: isOnline});
  }

  void disposeStream() => controller.close();
}
