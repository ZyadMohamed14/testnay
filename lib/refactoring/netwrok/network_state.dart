part of 'network_cubit.dart';

@immutable
sealed class NetworkState {}


class NetworkInitial extends NetworkState {}

class NetworkConnected extends NetworkState {}

class NetworkDisconnected extends NetworkState {}
