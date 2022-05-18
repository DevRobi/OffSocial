// ignore_for_file: unnecessary_import, unused_import
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


// image widget (permission and imageloader from android filesys)
class FileImageWidget extends StatefulWidget {
  const FileImageWidget({Key? key}) : super(key: key);

  @override
  _FileImageWidgetState createState() => _FileImageWidgetState();
}

class _FileImageWidgetState extends State<FileImageWidget> {

  late PermissionStatus _permissionStatus;
  
  @override // thats why it final worked (loading the image)
  initState() {
      super.initState();
  
      () async {
        _permissionStatus = await Permission.storage.status;
  
        if (_permissionStatus != PermissionStatus.granted) {
          PermissionStatus permissionStatus= await Permission.storage.request();
          setState(() {
            _permissionStatus = permissionStatus;
          });
        }
      } ();
    }

  @override
  Widget build(BuildContext context) {

    return Container(
        color: Colors.white,
        child: Image.file(
          File(
            '/storage/emulated/0/Pictures/qr-code.png',
          ),
        ),
      );
  }
}