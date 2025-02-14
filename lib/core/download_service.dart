import 'dart:io';


import 'package:path_provider/path_provider.dart';

Future<String?> downloadFolder() async {
  // await requestStoragePermission();

  Directory? directory = Directory('/storage/emulated/0/Download');

  if (!(await directory.exists())) {
    directory.create(recursive: true);
    directory = await getExternalStorageDirectory();
  }

  return directory!.path;
}