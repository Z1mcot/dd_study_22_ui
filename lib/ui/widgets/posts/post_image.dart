import 'package:flutter/material.dart';

class PostImage extends StatelessWidget {
  final String imageUrl;
  final Map<String, String>? headers;
  const PostImage({super.key, required this.imageUrl, required this.headers});

  @override
  Widget build(BuildContext context) {
    return Image(
      image: NetworkImage(imageUrl, headers: headers),
      fit: BoxFit.cover,
    );
  }
}
