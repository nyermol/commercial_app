// ignore_for_file: always_specify_types

import 'dart:async';

import 'package:commercial_app/presentation/cubit/internet_state.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InternetCubit extends Cubit<InternetState> {
  final Connectivity _connectivity;
  late final StreamSubscription _connectivityStream;

  InternetCubit({
    required Connectivity connectivity,
  })  : _connectivity = connectivity,
        super(InternetState()) {
    _connectivityStream =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult res) {
      _updateState(res);
    });
  }

  void checkConnectivity() async {
    final ConnectivityResult result = await _connectivity.checkConnectivity();
    _updateState(result);
  }

  void _updateState(ConnectivityResult result) {
    if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      emit(InternetState(type: InternetTypes.connected));
    } else if (result == ConnectivityResult.none) {
      emit(InternetState(type: InternetTypes.offline));
    } else {
      emit(InternetState(type: InternetTypes.unknown));
    }
  }

  @override
  Future<void> close() {
    _connectivityStream.cancel();
    return super.close();
  }
}
