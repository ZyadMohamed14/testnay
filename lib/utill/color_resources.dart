
import 'package:flutter_bloc/flutter_bloc.dart';

enum AppTheme { light, dark }
class ThemeCubit extends Cubit<AppTheme> {
  ThemeCubit() : super(AppTheme.dark);

  void toggleTheme() {

    if (state == AppTheme.light) {
      print('toggleTheme AppThem ${state}');
      emit(AppTheme.dark);

    } else {
      print('toggleTheme AppThem ${state}');
      emit(AppTheme.light);
    }
  }

}
