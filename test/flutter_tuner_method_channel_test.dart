import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tuner/flutter_tuner_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFlutterTuner platform = MethodChannelFlutterTuner();
  const MethodChannel channel = MethodChannel('flutter_tuner');

  final List<MethodCall> log = <MethodCall>[];

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          log.add(methodCall);
          return null;
        });
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(MethodChannelFlutterTuner.eventChannel.name,
            (message) async {
          // EventChannel first sends a `listen` control message. A successful
          // envelope mirrors a native stream handler accepting that listener.
          return const StandardMethodCodec().encodeSuccessEnvelope(null);
        });
  });

  tearDown(() {
    log.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(MethodChannelFlutterTuner.eventChannel.name, null);
  });

  test('startTuning', () async {
    await platform.startTuning();
    expect(log, <Matcher>[isMethodCall('startTuning', arguments: null)]);
  });

  test('stopTuning', () async {
    await platform.stopTuning();
    expect(log, <Matcher>[isMethodCall('stopTuning', arguments: null)]);
  });

  test('frequencyStream receives native frequency events as doubles', () async {
    final stream = platform.frequencyStream;
    final frequency = stream.first;

    // Let EventChannel complete its listen handshake before delivering the
    // platform event.
    await Future<void>.delayed(Duration.zero);

    await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .handlePlatformMessage(
      'flutter_tuner_stream',
      const StandardMethodCodec().encodeSuccessEnvelope(440.0),
      (_) {},
    );

    expect(await frequency, 440.0);
  });
}
