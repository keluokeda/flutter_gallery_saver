import 'package:flutter_test/flutter_test.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:gallery_saver/gallery_saver_platform_interface.dart';
import 'package:gallery_saver/gallery_saver_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGallerySaverPlatform
    with MockPlatformInterfaceMixin
    implements GallerySaverPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final GallerySaverPlatform initialPlatform = GallerySaverPlatform.instance;

  test('$MethodChannelGallerySaver is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGallerySaver>());
  });

  test('getPlatformVersion', () async {
    GallerySaver gallerySaverPlugin = GallerySaver();
    MockGallerySaverPlatform fakePlatform = MockGallerySaverPlatform();
    GallerySaverPlatform.instance = fakePlatform;

    expect(await gallerySaverPlugin.getPlatformVersion(), '42');
  });
}
