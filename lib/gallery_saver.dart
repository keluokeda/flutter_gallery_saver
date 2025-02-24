import 'gallery_saver_platform_interface.dart';

class GallerySaver {
  Future<String?> getPlatformVersion() {
    return GallerySaverPlatform.instance.getPlatformVersion();
  }

  Future toGallery(String path, String name, String type) {
    return GallerySaverPlatform.instance.toGallery(path, name, type);
  }
}
