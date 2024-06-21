import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class EventObserver extends BlocObserver {
  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    log('🧱${bloc.runtimeType} $event', name: 'Bloc Event');
  }
}
