import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../styles.dart';

class ImagePreviewScreen extends StatelessWidget {
  const ImagePreviewScreen({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Center(
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: Hero(
                  tag: url,
                  child: CachedNetworkImage(imageUrl: url),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 15,
              left: MediaQuery.of(context).size.width / 15,
              child: IconButton(
                onPressed: (() {
                  Navigator.pop(context);
                }),
                icon: Icon(
                  Icons.close,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
