// Copyright (c) 2015, Seth Ladd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// The vendorizor app.
library vendorizor;

import 'dart:io' show File, exit, Directory, FileSystemEntity, FileSystemEntityType;
import 'package:package_config/packages_file.dart';
import 'package:path/path.dart' as path;

main(List<String> args) {
  var packagesFile = new File('.packages');

  if (!packagesFile.existsSync()) {
    print('Did not find a .packages file in the current directory.\n');
    exit(1);
  }

  var packagesContents = packagesFile.readAsBytesSync();
  Map<String, Uri> packageConfig = parse(packagesContents, Directory.current.uri);

  print(packageConfig);

  var packagesDir = new Directory('packages');
  if (packagesDir.existsSync()) {
    packagesDir.deleteSync(recursive: true);
  }
  packagesDir.createSync();

  print('Vendorizing');

  packageConfig.forEach((String packageName, Uri uri) {
    if (!uri.toString().contains('/.pub-cache/')) return; // TODO: does this work on Windows?
    var packageSource = new Directory.fromUri(uri);
    print('Copying $packageName from ${packageSource.path}');

    var packageDir = new Directory(path.join(packagesDir.path, packageName));
    packageDir.createSync();

    packageSource.listSync(recursive: true).forEach((FileSystemEntity entity) {
      if (entity is File) {
        File file = entity as File;
        var destPath = path.join(packageDir.path, file.path.substring(packageSource.path.length));
        new File(destPath).createSync(recursive: true);
        file.copySync(destPath);
      }
    });
  });
}
