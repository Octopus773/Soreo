
import 'dart:ffi';

import 'package:soreo/repositories/authentication_repository.dart';
import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:soreo/blocs/authentication/authentication_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';


void main() {

  group('CounterBloc', () {
    late AuthenticationBloc aB;

    setUp(() {
      aB = AuthenticationBloc(auth: AuthenticationRepository(reddit: nullptr), user: );
    });

    test('initial state is 0', () {
      expect(counterBloc.state, 0);
    });

    blocTest(
      'emits [1] when CounterEvent.increment is added',
      build: () => counterBloc,
      act: (bloc) => bloc.add(Increment()),
      expect: () => [1],
    );

    blocTest(
      'emits [-1] when CounterEvent.decrement is added',
      build: () => counterBloc,
      act: (bloc) => bloc.add(Decrement()),
      expect: () => [-1],
    );
  });
}