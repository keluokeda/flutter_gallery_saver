import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _gallerySaverPlugin = GallerySaver();
  final dio = Dio();
  final urlController = TextEditingController(
    text:
        'https://p26.toutiaoimg.com/origin/tos-cn-i-qvj2lq49k0/22f10850c5234b5285350743cfa16357',
  );

  String? imagePath;

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _gallerySaverPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('保存图片到相册')),
        body: Column(
          children: [
            ListTile(
              title: TextFormField(
                controller: urlController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('图片地址'),
                ),
              ),
            ),
            ListTile(
              title: ElevatedButton(
                onPressed: () async {
                  final dir = await getApplicationCacheDirectory();
                  final path =
                      "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";
                  if (kDebugMode) {
                    print('path = $path');
                  }
                  try {
                    final response = await dio.download(
                      urlController.text,
                      path,
                    );
                    if (response.statusCode == 200) {
                      setState(() {
                        imagePath = path;
                      });

                      _gallerySaverPlugin.toGallery(
                        path,
                        DateTime.now().millisecondsSinceEpoch.toString(),
                        'image/jpeg',
                      );
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('提示'),
                            content: Text('保存成功'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('确定'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  } catch (e) {
                    if (kDebugMode) {
                      print(e);
                    }
                  }
                },
                child: Text('下载并保存'),
              ),
            ),
            if (imagePath != null) Image.file(File(imagePath!)),
          ],
        ),
      ),
    );
  }
}
