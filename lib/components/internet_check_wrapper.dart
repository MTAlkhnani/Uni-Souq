import 'dart:async';

import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:unisouq/no_internet_page.dart'; // Import the NoInternetPage

class InternetCheckWrapper extends StatefulWidget {
  final Widget child;

  const InternetCheckWrapper({Key? key, required this.child}) : super(key: key);

  @override
  _InternetCheckWrapperState createState() => _InternetCheckWrapperState();
}

class _InternetCheckWrapperState extends State<InternetCheckWrapper> {
  late Connectivity _connectivity;
  late StreamSubscription<ConnectivityResult> _subscription;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _subscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _checkConnection();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      _isConnected = result != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isConnected ? widget.child : NoInternetPage();
  }
}
