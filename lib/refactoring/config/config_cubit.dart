import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'configration_model.dart';
import 'config_repo.dart';

part 'config_state.dart';

class ConfigCubit extends Cubit<ConfigState> {
  final ConfigRepository _configRepository;
  late ConfigModel?configModel;

  ConfigCubit(this._configRepository) : super(ConfigInitial());

  Future<void> loadConfig() async {
    emit(ConfigLoading());
    try {
      final config = await _configRepository.fetchConfig();
      configModel=config;
      emit(ConfigLoaded(config));
    } catch (e) {
      emit(ConfigError(e.toString()));
    }
  }
}