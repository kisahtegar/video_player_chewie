import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:video_player_chewie/model3/video_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List videoInfo = [];
  String? _controllerS;

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
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
          leading: InkWell(
            onTap: () {
              debugPrint('[dbg]debug: Length video ${videoInfo.length}');
              debugPrint('[dbg]debug: _controllerS = $_controllerS');
              //debugPrint('[dbg]debug: videoInfo = ${videoInfo}');
            },
            child: const Icon(Icons.settings),
          ),
        ),
        body: Column(
          children: [
            // list of video
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: videoInfo.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    _initializeVideo(index);
                    debugPrint(videoInfo[index]["videoUrl"]);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VideoScreen(
                                  value: _controllerS,
                                )));
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
