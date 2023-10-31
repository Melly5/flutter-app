import 'package:flutter_bloc/flutter_bloc.dart';

import 'main_screen_state.dart';

class MainScreenCubit extends Cubit<MainScreenState> {
  MainScreenCubit() : super(MainScreenUpdateCounterState(value: 0.0));

  double result = 0.0;

  void calculateValue(double weight, double height) {
    result = weight / (height * height * 0.01);
    emit(MainScreenUpdateCounterState(value: result));
  }


}
