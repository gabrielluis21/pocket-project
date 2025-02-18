import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class SharePhotoScreen extends StatelessWidget {
  final File imageUrl;

  const SharePhotoScreen(this.imageUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create a new post"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Share.share(imageUrl.path);
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(child: Image.file(imageUrl)),
    );
  }
}
