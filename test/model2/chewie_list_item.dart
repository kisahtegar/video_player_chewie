import 'dart:convert';
import 'dart:ffi';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChewieListItem extends StatefulWidget {
  const ChewieListItem({
    required this.videoPlayerController,
    Key? key,
  }) : super(key: key);

  final VideoPlayerController videoPlayerController;

  @override
  State<ChewieListItem> createState() => _ChewieListItemState();
}

class _ChewieListItemState extends State<ChewieListItem> {
  late ChewieController _chewieController;
  List videoInfo = [];

  //initialize
  @override
  void initState() {
    super.initState();
    _initData();
    // Wrapper on top of the videoPlayerController.
    _chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController,
        aspectRatio: 16 / 9,
        autoPlay: true,
        // Prepare the video to be played and display.
        autoInitialize: true,
        // Errors can occur for example when trying to play a video from a
        // non-existent URL.
        errorBuilder: (BuildContext context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        });
  }

  // convert json
  _initData() async {
    await DefaultAssetBundle.of(context)
        .loadString("json/videoinfo.json")
        .then((value) {
      setState(() {
        videoInfo = json.decode(value);
      });
    });
  }

  // Disposed the video
  @override
  void dispose() {
    super.dispose();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
    debugPrint('dispposed');
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 16 / 9, child: Chewie(controller: _chewieController));
  }
}
