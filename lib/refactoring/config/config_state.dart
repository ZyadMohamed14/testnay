part of 'config_cubit.dart';

@immutable
sealed class ConfigState {}


class ConfigInitial extends ConfigState {}

class ConfigLoading extends ConfigState {}

class ConfigLoaded extends ConfigState {
  final ConfigModel config;

  ConfigLoaded(this.config);
}

class ConfigError extends ConfigState {
  final String message;

  ConfigError(this.message);
}
