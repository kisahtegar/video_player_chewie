import 'dart:convert';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'chewie_list_item.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key, this.value}) : super(key: key);
  final value;

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  List videoInfo = [];
  String? _controllerS;
  //VideoScreen _controllerT = widget;
  bool _playArea = false;
  late ChewieController _controllerC;

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
    //_controllerT;
    _initData();
  }

  _initializeVideo(int index) async {
    debugPrint("[dbg]_initializeVideo() : ===================================");
    //
    final controller = videoInfo[index]["videoUrl"];
    final old = _controllerS;
    debugPrint('[dbg]_initializeVideo() : old is $old');
    _controllerS = controller;

    if (old != null) {
      debugPrint('[dbg]_initializeVideo() : Remove old video');
      //_controllers.removeListener();
    }
    //
    debugPrint("[dbg]_initializeVideo() : ===================================");
  }

  @override
  Widget build(BuildContext context) {
    //double _w = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Chewie Video Player'),
        ),
        body: Column(
          children: <Widget>[
            ChewieListItem(
              videoPlayerController:
                  VideoPlayerController.network(widget.value.toString()),
            ),

            // Testing debug button
            TextButton(
                onPressed: () {
                  debugPrint('[dbg]TestingButton:===========================');
                  //
                  debugPrint(
                      '[dbg]TestingButton: widget.value = ${widget.value.toString()}');
                  debugPrint("[dbg]TestingButton: _controller = $_controllerS");
                  debugPrint(
                      "[dbg]TestingButton: _playArea = ${_playArea.toString()}");

                  //
                  debugPrint('[dbg]TestingButton:===========================');
                },
                child: const Icon(Icons.settings)),

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
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VideoScreen(
                                  value: _controllerS,
                                )));
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
