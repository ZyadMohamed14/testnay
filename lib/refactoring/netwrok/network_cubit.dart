import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'network_state.dart';



class NetworkCubit extends Cubit<NetworkState> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  NetworkCubit() : super(NetworkInitial()) {
    _initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _initConnectivity() async {
    try {
      final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
      _updateConnectionStatus(results);
    } catch (e) {
      emit(NetworkDisconnected());
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    // Handle multiple connection types (mobile, wifi, etc.)
    final hasConnection = results.any((result) => result != ConnectivityResult.none);

    if (hasConnection) {
      emit(NetworkConnected());
    } else {
      emit(NetworkDisconnected());
    }
  }
  Future<void> checkConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateConnectionStatus(results);
    } catch (e) {
      emit(NetworkDisconnected());
    }
  }


  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}

class InternetConnectivityService {
  InternetConnectivityService._internal();

  static final InternetConnectivityService instance =
  InternetConnectivityService._internal();

  factory InternetConnectivityService() => instance;

  List<ConnectivityResult>? connectionStatus;
  final Connectivity connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? connectivitySubscription;

  ValueNotifier<bool> isOffline = ValueNotifier(false);

  /// Starts listening to internet connection changes
  void startListening() {
    connectivitySubscription =
        connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    connectionStatus = result;
    isOffline.value = connectionStatus!.contains(ConnectivityResult.none);
  }

  /// Stops listening to network changes and prevents memory leaks
  void dispose() {
    connectivitySubscription?.cancel();
    connectivitySubscription = null;
  }
}