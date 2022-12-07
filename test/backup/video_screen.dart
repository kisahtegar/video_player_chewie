import 'dart:convert';
import 'package:flutter/material.dart';
import 'chewie_list_item.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  List videoInfo = [];
  String? _controller;
  bool _playArea = false;

  _initData() async {
    await DefaultAssetBundle.of(context)
        .loadString("json/videoinfo.json")
        .then((value) {
      setState(() {
        videoInfo = json.decode(value);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  _initializeVideo(int index) async {
    debugPrint("[dbg]_initializeVideo() : ===================================");
    String controller = videoInfo[index]["videoUrl"];
    String? old = _controller;
    debugPrint('[dbg]_initializeVideo() : $old');
    _controller = controller;

    if (old != null) {
      debugPrint('[dbg]_initializeVideo() : Remove old video');
    }
  }

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(title: const Text('Chewie Video Player')),
        body: Column(
          children: <Widget>[
            _playArea == false
                ? AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(color: Colors.redAccent),
                  )
                : ChewieListItem(
                    videoPlayerController:
                        VideoPlayerController.network(_controller.toString()),
                    looping: false,
                  ),
            TextButton(
                onPressed: () {
                  debugPrint("_controller = $_controller");
                  debugPrint("_playArea = ${_playArea.toString()}");
                },
                child: const Icon(Icons.restart_alt)),

            const SizedBox(height: 10),
            // List View
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: videoInfo.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    _initializeVideo(index);
                    debugPrint(videoInfo[index]["videoUrl"]);
                    setState(() {
                      if (_playArea == false) {
                        _playArea = true;
                      }
                    });
                    //debugPrint(index.toString());
                  },
                  child: ListTile(
                    title: Text(videoInfo[index]['title']),
                    subtitle: Text(videoInfo[index]['videoUrl']),
                  ),
                );
              },
            )
          ],
        ));
  }
}
