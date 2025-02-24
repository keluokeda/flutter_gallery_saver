import Flutter
import UIKit

public class GallerySaverPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "gallery_saver", binaryMessenger: registrar.messenger())
        let instance = GallerySaverPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case "toGallery":
            toGallery(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func toGallery(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let map = call.arguments as! [String: String]
//        print(map)
        let url = map["path"]
        if let image = UIImage(contentsOfFile: url!) {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(didFinishSavingImage(image:error:contextInfo:)), nil)
        }
        result(nil)
    }

    @objc func didFinishSavingImage(image: UIImage, error: NSError?, contextInfo: UnsafeMutableRawPointer?) {
//           saveResult(isSuccess: error == nil, error: error?.description)
    }
}
