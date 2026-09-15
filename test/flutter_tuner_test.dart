import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tuner/flutter_tuner.dart';
import 'package:flutter_tuner/flutter_tuner_platform_interface.dart';
import 'package:flutter_tuner/flutter_tuner_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterTunerPlatform
    with MockPlatformInterfaceMixin
    implements FlutterTunerPlatform {
  bool startTuningCalled = false;
  bool stopTuningCalled = false;
  final StreamController<double> frequencies = StreamController<double>();

  @override
  Future<void> startTuning() async {
    startTuningCalled = true;
  }

  @override
  Future<void> stopTuning() async {
    stopTuningCalled = true;
  }

  @override
  Stream<double> get frequencyStream => frequencies.stream;
}

void main() {
  final FlutterTunerPlatform initialPlatform = FlutterTunerPlatform.instance;

  tearDown(() {
    FlutterTunerPlatform.instance = initialPlatform;
  });

  test('$MethodChannelFlutterTuner is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterTuner>());
  });

  test('startTuning', () async {
    FlutterTuner flutterTunerPlugin = FlutterTuner();
    MockFlutterTunerPlatform fakePlatform = MockFlutterTunerPlatform();
    FlutterTunerPlatform.instance = fakePlatform;

    await flutterTunerPlugin.startTuning();
    expect(fakePlatform.startTuningCalled, true);
  });

  test('stopTuning', () async {
    FlutterTuner flutterTunerPlugin = FlutterTuner();
    MockFlutterTunerPlatform fakePlatform = MockFlutterTunerPlatform();
    FlutterTunerPlatform.instance = fakePlatform;

    await flutterTunerPlugin.stopTuning();
    expect(fakePlatform.stopTuningCalled, true);
  });

  test('frequencyStream is delegated to the platform implementation', () async {
    FlutterTunerPlatform.instance = MockFlutterTunerPlatform();
    final fakePlatform = FlutterTunerPlatform.instance as MockFlutterTunerPlatform;
    addTearDown(fakePlatform.frequencies.close);

    final frequency = FlutterTuner().frequencyStream.first;
    fakePlatform.frequencies.add(440.0);

    expect(await frequency, 440.0);
  });
}
