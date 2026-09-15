package com.degastonapps.flutter_tuner

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlin.test.Test
import org.mockito.Mockito

/*
 * Tests the part of the method-channel contract that does not require Android
 * audio hardware. Microphone capture and JNI linkage are compiled by CI's
 * example-app build and DSP behavior is covered by cpp_tests.
 */

internal class FlutterTunerPluginTest {
  @Test
  fun onMethodCall_unknownMethod_isNotImplemented() {
    val plugin = FlutterTunerPlugin()

    val call = MethodCall("notAPluginMethod", null)
    val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
    plugin.onMethodCall(call, mockResult)

    Mockito.verify(mockResult).notImplemented()
  }
}
