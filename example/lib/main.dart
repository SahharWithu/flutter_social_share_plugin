import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_social_share_plugin/file_type.dart';
import 'package:flutter_social_share_plugin/flutter_social_share.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

///sharing platform
enum Share {
  facebook,
  twitter,
  whatsapp,
  whatsapp_business,
  share_system,
  share_instagram,
  share_telegram,
  share_sms,
  share_mail,
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? file;
  ImagePicker picker = ImagePicker();
  bool videoEnable = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 30),
              ElevatedButton(onPressed: pickImage, child: Text('Pick Image')),
              ElevatedButton(onPressed: pickVideo, child: Text('Pick Video')),
              ElevatedButton(
                  onPressed: () => onButtonTap(Share.twitter),
                  child: const Text('share to twitter')),
              ElevatedButton(
                onPressed: () => onButtonTap(Share.whatsapp),
                child: const Text('share to WhatsApp'),
              ),
              ElevatedButton(
                onPressed: () => onButtonTap(Share.whatsapp_business),
                child: const Text('share to WhatsApp Business'),
              ),
              ElevatedButton(
                onPressed: () => onButtonTap(Share.facebook),
                child: const Text('share to  FaceBook'),
              ),
              ElevatedButton(
                onPressed: () => onButtonTap(Share.share_instagram),
                child: const Text('share to Instagram'),
              ),
              ElevatedButton(
                onPressed: () => onButtonTap(Share.share_telegram),
                child: const Text('share to Telegram'),
              ),
              ElevatedButton(
                onPressed: () => onButtonTap(Share.share_system),
                child: const Text('share to System'),
              ),
              ElevatedButton(
                onPressed: () => onButtonTap(Share.share_sms),
                child: const Text('share to sms'),
              ),
              ElevatedButton(
                onPressed: () => onButtonTap(Share.share_mail),
                child: const Text('share to mail'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickImage() async {
    PermissionStatus status = await Permission.photos.request();
    if (!status.isGranted) {
      await Permission.photos.request();
    }
    final XFile? xFile = await picker.pickImage(source: ImageSource.gallery);
    print(xFile);
    if (xFile != null) {
      file = File(xFile.path);
      setState(() {
        videoEnable = false;
      });
    }
  }

  Future<void> pickVideo() async {
    final XFile? xFile = await picker.pickVideo(source: ImageSource.gallery);
    print(xFile);
    if (xFile != null) {
      file = File(xFile.path);
      setState(() {
        videoEnable = true;
      });
    }
  }

  Future<void> onButtonTap(Share share) async {
    String msg =
        'Flutter share is great!!\n Check out full example at https://pub.dev/packages/flutter_social_share_plugin';
    String url = 'https://pub.dev/packages/flutter_social_share_plugin';

    String? response;
    final FlutterSocialShare flutterShareMe = FlutterSocialShare();
    switch (share) {
      case Share.facebook:
        response = await flutterShareMe.shareToFacebook(
            imagePath: file!.path, msg: msg);
        break;
      case Share.twitter:
        response = await flutterShareMe.shareToTwitter(url: url, msg: msg);
        break;
      case Share.whatsapp:
        if (file != null) {
          response = await flutterShareMe.shareToWhatsApp(
              imagePath: file!.path,
              fileType: videoEnable ? FileType.video : FileType.image);
        } else {
          response = await flutterShareMe.shareToWhatsApp(msg: msg);
        }
        break;
      case Share.whatsapp_business:
        response = await flutterShareMe.shareToWhatsApp(msg: msg);
        break;
      case Share.share_instagram:
        response = await flutterShareMe.shareToInstagram(
            filePath: file!.path,
            fileType: videoEnable ? FileType.video : FileType.image);
        break;
      case Share.share_system:
        response = await flutterShareMe.shareToSystem(msg: msg);
        break;
      case Share.share_telegram:
        response = await flutterShareMe.shareToTelegram(msg: msg);
        break;
      case Share.share_sms:
        response = await flutterShareMe.shareToSms(msg: msg);
        break;
      case Share.share_mail:
        response = await flutterShareMe.shareToMail(
            mailBody: msg,
            mailSubject: 'Flutter Social Share',
            mailRecipients: [
              'fluttersocialshare@pub.dev',
            ]);
        break;
    }
    debugPrint(response);
  }
}
