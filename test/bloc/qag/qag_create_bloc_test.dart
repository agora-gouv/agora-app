import 'package:agora/bloc/qag/create/qag_create_bloc.dart';
import 'package:agora/bloc/qag/create/qag_create_event.dart';
import 'package:agora/bloc/qag/create/qag_create_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/qag/fake_device_id_helper.dart';
import '../../fakes/qag/fakes_qag_repository.dart';

void main() {
  group("CreateQagEvent", () {
    blocTest(
      "when repository succeed - should emit success state",
      build: () => CreateQagBloc(
        qagRepository: FakeQagSuccessRepository(),
        deviceInfoHelper: FakeDeviceInfoHelper(),
      ),
      act: (bloc) => bloc.add(
        CreateQagEvent(
          title: "title",
          description: "description",
          author: "author",
          thematiqueId: "thematiqueId",
        ),
      ),
      expect: () => [
        CreateQagLoadingState(),
        CreateQagSuccessState(),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when device id is null - should emit failure state",
      build: () => CreateQagBloc(
        qagRepository: FakeQagSuccessRepository(),
        deviceInfoHelper: FakeDeviceIdNullHelper(),
      ),
      act: (bloc) => bloc.add(
        CreateQagEvent(
          title: "title",
          description: "description",
          author: "author",
          thematiqueId: "thematiqueId",
        ),
      ),
      expect: () => [
        CreateQagLoadingState(),
        CreateQagErrorState(),
      ],
      wait: const Duration(milliseconds: 5),
    );

    blocTest(
      "when repository failed - should emit failure state",
      build: () => CreateQagBloc(
        qagRepository: FakeQagFailureRepository(),
        deviceInfoHelper: FakeDeviceInfoHelper(),
      ),
      act: (bloc) => bloc.add(
        CreateQagEvent(
          title: "title",
          description: "description",
          author: "author",
          thematiqueId: "thematiqueId",
        ),
      ),
      expect: () => [
        CreateQagLoadingState(),
        CreateQagErrorState(),
      ],
      wait: const Duration(milliseconds: 5),
    );
  });
}
