import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class NonCacheNetworkImage extends StatefulWidget {
  const NonCacheNetworkImage(this.imageUrl, {Key? key}) : super(key: key);
  final String imageUrl;

  @override
  _NonCacheNetworkImageState createState() => _NonCacheNetworkImageState();
}

class _NonCacheNetworkImageState extends State<NonCacheNetworkImage> {
  Future<Uint8List> getImageBytes() async {
    Response response = await get(Uri.parse(widget.imageUrl));
    return response.bodyBytes;
  }

  @override
  Widget build(BuildContext context) {
    print('image_building');
    return FutureBuilder<Uint8List>(
      future: getImageBytes(),
      builder: (context, snapshot) {
        if (snapshot.hasData) return Image.memory(snapshot.data!);
        return Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: Text("Loading Cam Data"),
          ),
        );
      },
    );
  }
}
